clear; close all
load data/extended_trial_data_025.mat M1

for i=1:26

hold on
plotSpikes(3000+(1:1500), M1(i,1:1500), i*0.1, 'k', 5)

end
hold off

%%
figure(1)
rat = '025';
latent_dim = 4;
test_fold = 2;

region = 'M1';
load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu');

plot(gaussianSmooth(latent_mu(1:3000,1)/2, 5), 'LineWidth',2, 'Color', 'k')
hold on
plot(gaussianSmooth(latent_mu(1:3000,2)/2+1.5, 5), 'LineWidth',2, 'Color', 'k')
plot(gaussianSmooth(latent_mu(1:3000,3)/2+3, 5), 'LineWidth',2, 'Color', 'k')
plot(gaussianSmooth(latent_mu(1:3000,4)/2+4.8, 5), 'LineWidth',2, 'Color', 'k')
hold off