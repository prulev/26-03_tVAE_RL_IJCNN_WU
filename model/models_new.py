''' This module defines TC_tVAE model, Ziyi 260407
'''

from typing import Tuple
import torch
from torch import nn, Tensor
import torch.nn.functional
from model.network_modules import Encoder, Decoder


class VAE(nn.Module):

    def __init__(self, config, device, in_neuron_num: int, out_neuron_num: int):
        super(VAE, self).__init__()
        self.model_type = 'AutoEncoder'
        self.config = config
        self.device = device
        self.in_neuron_num = in_neuron_num
        self.out_neuron_num = out_neuron_num
        self.variational = self.config.MODEL.VARIATIONAL

        self.latent_dim = config.MODEL.LATENT_DIM

        self.encoder = Encoder(config, device, in_neuron_num)
        self.decoder = Decoder(config, device, out_neuron_num)

        self.batch_norm = nn.BatchNorm1d(config.MODEL.LATENT_DIM)
        self.batch_norm.bias = nn.Parameter(torch.zeros(config.MODEL.LATENT_DIM), requires_grad=False)

        # latent smooth
        sigma = self.config.TRAIN.MU_PRIORI_SIGMA
        kernel_size = 2 * 4 * sigma + 1
        self.padding_size = int(4 * sigma)
        kernel = get_kernel(kernel_size, sigma).unsqueeze(0).unsqueeze(0).repeat(self.latent_dim, 1, 1)
        self.register_buffer('kernel', kernel)

        # # priori variance
        # var_priori = (config.TRAIN.VAR_PRIORI *
        #               torch.ones((config.MODEL.TIME_WINDOW, config.TRAIN.BATCH_SIZE, self.latent_dim)))
        # self.register_buffer('var_priori', var_priori)

        # self.PoissonNLLLoss = nn.PoissonNLLLoss(reduction='mean', log_input=False)

    @staticmethod
    def _log_importance_weight_matrix(batch_size, dataset_size):
        """
        Reference:
        [1] https://github.com/rtqichen/beta-tcvae/blob/master/vae_quant.py#L231
        """
        N = dataset_size
        M = batch_size - 1
        strat_weight = (N - M) / (N * M)
        W = torch.Tensor(batch_size, batch_size).fill_(1 / M)
        W.view(-1)[::M + 1] = 1 / N
        W.view(-1)[1::M + 1] = strat_weight
        W[M - 1, 0] = strat_weight
        return W.log()

    @staticmethod
    def reparameterize(mu, log_var):
        std = torch.exp(0.5 * log_var)
        eps = torch.randn_like(std)
        return mu + eps * std

    def forward(self, src: Tensor, src_mask: Tensor = None) -> Tuple[Tensor, Tensor, Tensor, Tensor]:
        if src_mask is None:  # TODO: use a mask to control the number of points of look back? use triu maybe
            """Generate a square causal mask for the sequence. The masked positions are filled with float('-inf').
            Unmasked positions are filled with float(0.0).
            """
            src_mask = nn.Transformer.generate_square_subsequent_mask(len(src)).to(self.device)

        mu, log_var = self.encoder(src, src_mask)
        mu = self.batch_norm(mu.view(-1, self.config.MODEL.LATENT_DIM)).view(log_var.shape)
        if self.variational and self.training:  # do not sample in testing
            z = self.reparameterize(mu, log_var)
        else:
            z = mu
        return self.decoder(z, src_mask), mu, log_var, z

    def loss_function(self, recon_x, x, mu, log_var, z, beta, gamma, dataset_samples):
        if not self.config.MODEL.VARIATIONAL:
            beta = 0.
        if not self.config.MODEL.TC_LOSS:
            gamma = 0.

        # Reconstruction error
        if self.config.DATA.RATE_INPUT:
            recon_loss = nn.functional.mse_loss(recon_x, x, reduction='mean')
        else:
            recon_loss = nn.functional.binary_cross_entropy(recon_x, x, reduction='mean')
        # bce = self.PoissonNLLLoss(recon_x, x)

        # Get Priori distribution of latent space
        var_priori = torch.ones_like(log_var) * self.config.TRAIN.VAR_PRIORI
        var_priori[0, :, :] = 1.
        mu_priori = nn.functional.conv1d(
            nn.functional.pad(mu.detach().permute(1, 2, 0), (self.padding_size, self.padding_size), mode='reflect'),
            self.kernel,
            padding='valid', groups=mu.size(2)).permute(2, 0, 1)
        # mu_priori *= 0.999
        # mu_priori = torch.zeros_like(mu)
        # mu_priori[1:] = mu[:-1] - mu.mean(dim=(0, 1), keepdim=True)
        # TODO: use multiple past points to calculate priori

        # KL loss
        # calculate by sampling
        # log_q_z_cond_x = - 0.5 * (torch.log(torch.tensor(2 * torch.pi)) + log_var + 1)
        # log_p_z = - 0.5 * (
        #         torch.log(torch.tensor(2 * torch.pi) + self.var_priori.log()) +
        #         log_var.exp() / self.var_priori + (mu - mu_priori).pow(2) / self.var_priori)
        # kld = (log_q_z_cond_x - log_p_z).mean()
        # Analytical calculation
        kld = -0.5 * torch.mean(
            1 + log_var - var_priori.log() - log_var.exp() / var_priori - (mu - mu_priori).pow(2) / var_priori)

        # return bce + beta * kld, bce, kld, kld

        if gamma == 0.:
            return recon_loss + beta * kld, recon_loss, kld, torch.tensor(0.)
        
        # TC loss
        mini_mini_batch = self.config.TRAIN.TC_LOSS_BATCH_SIZE
        tc_loss_step_size = self.config.TRAIN.TC_LOSS_STEP_SIZE
        num_segments = (z.size(1) - 1) // mini_mini_batch + 1
        segmented_tc_losses = []

        for i in range(num_segments):
            start_idx = i * mini_mini_batch
            for offset in range(tc_loss_step_size):
                idx_range = range(offset, z.size(0), tc_loss_step_size)
                mu_segment = mu[idx_range, start_idx:min(start_idx+mini_mini_batch, z.size(1)), :].reshape(
                    -1, self.latent_dim)
                log_var_segment = log_var[idx_range, start_idx:min(start_idx+mini_mini_batch, z.size(1)), :].reshape(
                    -1, self.latent_dim)
                z_segment = z[idx_range, start_idx:min(start_idx+mini_mini_batch, z.size(1)), :].reshape(
                    -1, self.latent_dim)
                batch_samples = z_segment.size(0)

                mat_log_q_z = log_density_gaussian(z_segment.view(batch_samples, 1, self.latent_dim),
                                                   mu_segment.view(1, batch_samples, self.latent_dim),
                                                   log_var_segment.view(1, batch_samples, self.latent_dim))

                log_iw_matrix = self._log_importance_weight_matrix(batch_samples, dataset_samples).to(self.device)
                log_q_z = torch.logsumexp(log_iw_matrix + mat_log_q_z.sum(2), dim=1, keepdim=False)
                log_prod_q_z = torch.logsumexp(
                        log_iw_matrix.view(batch_samples, batch_samples, 1) + mat_log_q_z, dim=1, keepdim=False).sum(1)
                segmented_tc_losses.append((log_q_z - log_prod_q_z).mean())

        tc_loss = torch.stack(segmented_tc_losses).mean()

        loss = recon_loss + beta * kld + gamma * tc_loss

        return loss, recon_loss, kld, tc_loss


def initialize_weights(m):
    if isinstance(m, nn.Linear):
        nn.init.xavier_uniform_(m.weight)
        if m.bias is not None:
            nn.init.constant_(m.bias, 0)
    elif isinstance(m, nn.LayerNorm):
        nn.init.constant_(m.bias, 0)
        nn.init.constant_(m.weight, 1.0)


def get_kernel(size: int, sigma: float):
    x = torch.arange(-size // 2 + 1., size // 2 + 1.).cuda()
    x = x / sigma
    kernel = torch.exp(-0.5 * x ** 2)
    kernel = kernel / kernel.sum()
    return kernel


def log_density_gaussian(x: Tensor, mu: Tensor, log_var: Tensor):
    """
    Computes the log pdf of the Gaussian with parameters mu and log_var at x
    :param x: (Tensor) Point at whichGaussian PDF is to be evaluated
    :param mu: (Tensor) Mean of the Gaussian distribution
    :param log_var: (Tensor) Log variance of the Gaussian distribution
    :return: log_density: (Tensor) log pdf of the Gaussian
    Reference:
    [1] https://github.com/AntixK/PyTorch-VAE/blob/master/models/betatc_vae.py#L132
    """
    norm = - 0.5 * (torch.log(torch.tensor(2 * torch.pi)) + log_var)
    log_density = norm - 0.5 * ((x - mu) ** 2 * torch.exp(-log_var))
    return log_density
