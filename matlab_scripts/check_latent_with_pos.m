% 绘图：查看latent factors是否还和绝对位置有关
close all; clear; clc

ps = pyenv;
if ~ (ps.Status == "Loaded")
%   pyenv("Version", "C:\Users\77057\Documents\PythonVenv\transformervae\Scripts\python.exe")
  pyenv("Version", "D:\Code\PythonVenv\tVAE_py39\Scripts\python.exe")
end
pyfunc = py.importlib.import_module('apis_for_matlab');
py.importlib.reload(pyfunc);

%%
rat = '028';
region = 'mPFC';

data = load(['data/extended_trial_data_', rat, '.mat'], 'M1_select', 'mPFC');
% neuron_num = size(data.M1_select, 1);
neuron_num = size(data.mPFC, 1);

latent_dim = 4;

plotIndex = (1:1000) + 2800;
for test_fold=0:4
  model = pyfunc.get_model(rat, test_fold, latent_dim, region, neuron_num);
  results = load(['results\tVAE_', rat, '_', region, '_', num2str(test_fold), '_1En1De_', num2str(latent_dim), 'latent_decoder_pos.mat']);

  % 修改delay而latent不变，说明latent factor与input的起始点无关，也就是和position无关
  delay = 0;
  res = pyfunc.neural2latent(model, [zeros(neuron_num, delay+1) results.truth'], latent_dim);
  latent_mu = double(res{1}); latent_mu = latent_mu(1:length(results.truth), :);
  latent_std = double(res{2}); latent_std = latent_std(1:length(results.truth), :);

  figure()
  for i=1:latent_dim
    subplot(4,2,2*i-1)
    plot(latent_mu(plotIndex+delay,i), 'r')
    hold on
    plot(results.latent_mu(plotIndex,i), 'k')
    hold off

    subplot(4,2,2*i)
    plot(latent_std(plotIndex+delay,i), 'r')
    hold on
    plot(results.latent_std(plotIndex,i), 'k')
    hold off
  end
end


% latent_dim = 24;
% plotIndex = (1:500) + 2800;
% for test_fold=0:4
%   model = pyfunc.get_model(rat, test_fold, latent_dim, region, neuron_num);
%   results = load(['results\tVAE_', rat, '_', region, '_', num2str(test_fold), '_1En1De_', num2str(latent_dim), 'latent_decoder_pos.mat']);
% 
%   % 修改delay而latent不变，说明latent factor与input的起始点无关，也就是和position无关
%   delay = 0;
%   res = pyfunc.neural2latent(model, [zeros(neuron_num, delay+1) results.truth'], latent_dim);
%   latent_mu = double(res{1}); latent_mu = latent_mu(1:length(results.truth), :);
%   latent_std = double(res{2}); latent_std = latent_std(1:length(results.truth), :);
% 
%   figure(Name=[num2str(test_fold), ' latent mu'])
%   for i=1:latent_dim
%     subplot(4,6,i)
%     plot(latent_mu(plotIndex+delay,i), 'r')
%     hold on
%     plot(results.latent_mu(plotIndex,i), 'k')
%     hold off
%   end
% 
%   figure(Name=[num2str(test_fold), ' latent std'])
%   for i=1:latent_dim
%     subplot(4,6,i)
%     plot(latent_std(plotIndex+delay,i), 'r')
%     hold on
%     plot(results.latent_std(plotIndex,i), 'k')
%     hold off
%   end
% end

%%
% % plot all mPFC
% load results\tVAE_025_mPFC_2_1En1De_24latent_explore.mat
% for i=0:3
%   for j=1:min(6, size(truth, 2)-6*i)
%     figure(i+2)
%     subplot(2,3,j)
%     plot(gaussianSmooth(truth(1:5e3,i*6+j), 10), 'k')
%     hold on
%     plot(predictions(1:5e3,i*6+j), 'r')
%     hold off
%   end
% end

% % plot all M1
% load results\tVAE_025_M1_0_1En1De_24latent_explore.mat
% for i=1:size(truth, 2)
% 
%   figure(3)
%   subplot(3,3,i)
%   plot(gaussianSmooth(truth(1:5e3,i), 10), 'k')
%   hold on
%   plot(predictions(1:5e3,i), 'r')
%   yl = ylim();
%   bar((movements(1:5e3)==1)*0.2*yl(2), 'b')
%   bar((movements(1:5e3)==2)*0.4*yl(2), 'y')
%   bar((movements(1:5e3)==3)*0.6*yl(2), 'g')
%   plot(gaussianSmooth(truth(1:5e3,i), 10), 'k')
%   plot(predictions(1:5e3,i), 'r')
%   hold off
% 
% end

% %% plot latent space
% figure(1)
% explained = zeros(24, 5);
% subplot(2,2,1)
% for fold=0:4
%   data = load(['results\tVAE_025_M1_', num2str(fold), '_1En1De_24latent_explore.mat'], 'latent_mu');
%   [~, ~, ~, ~, explained(:,fold+1)] = pca(data.latent_mu);
% end
% explained = cumsum(explained)'/100;
% errorbar(1:24, mean(explained), mean(explained)-min(explained), mean(explained)-max(explained));
% title('025 M1')
% 
% explained = zeros(24, 5);
% subplot(2,2,2)
% for fold=0:4
%   data = load(['results\tVAE_025_mPFC_', num2str(fold), '_1En1De_24latent_explore.mat'], 'latent_mu');
%   [~, ~, ~, ~, explained(:,fold+1)] = pca(data.latent_mu);
% end
% explained = cumsum(explained)'/100;
% errorbar(1:24, mean(explained), mean(explained)-min(explained), mean(explained)-max(explained));
% title('025 mPFC')
% 
% subplot(2,2,3)
% explained = zeros(24, 5);
% for fold=0:4
%   data = load(['results\tVAE_028_M1_', num2str(fold), '_1En1De_24latent_explore.mat'], 'latent_mu');
%   [~, ~, ~, ~, explained(:,fold+1)] = pca(data.latent_mu);
% end
% explained = cumsum(explained)'/100;
% errorbar(1:24, mean(explained), mean(explained)-min(explained), mean(explained)-max(explained));
% title('028 M1')
% 
% explained = zeros(24, 5);
% subplot(2,2,4)
% for fold=0:4
%   data = load(['results\tVAE_028_mPFC_', num2str(fold), '_1En1De_24latent_explore.mat'], 'latent_mu');
%   [~, ~, ~, ~, explained(:,fold+1)] = pca(data.latent_mu);
% end
% explained = cumsum(explained)'/100;
% errorbar(1:24, mean(explained), mean(explained)-min(explained), mean(explained)-max(explained));
% title('028 mPFC')
% 
% 
% for i=1:min(length(explained), 4)
%   figure(2)
%   subplot(4,1,i)
%   plot(score(1:5e3, i))
%   hold on
%   yl = ylim();
%   bar((movements(1:5e3)==1)*0.2*yl(2), 'b')
%   bar((movements(1:5e3)==2)*0.4*yl(2), 'y')
%   bar((movements(1:5e3)==3)*0.6*yl(2), 'r')
%   hold off
% end
