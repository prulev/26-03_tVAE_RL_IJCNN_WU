% 绘图：不同模型得到的latent factors经过PCA之后，各PC的explained百分比
% 可发现即使latent dim更高，其latent factor之间存在线性相关，实际latent dim其实更低
clear; close all; clc
addpath results\
%% PCA on latent space
plot_1_rat_on_latent('025')
plot_1_rat_on_latent('028')

%%
function plot_1_rat_on_latent(rat)

f = figure(Name=[rat ' PCA on latent']);
regionList = {'M1', 'mPFC'};
for regionIdx = 1:2
  region = regionList{regionIdx};
  latentList = [4 8 16 24];
  if strcmp(rat, '025') && strcmp(region, 'M1')
    latentList = [4 6 8 16 24];
  end
for latentIdx = 1:length(latentList)
  latent_dim = latentList(latentIdx);
  train_explained = zeros(5, latent_dim+1);
  test_explained = zeros(5, latent_dim+1);
  train_explained_n = zeros(5, latent_dim+1);
  test_explained_n = zeros(5, latent_dim+1);
  for test_fold=0:4
      
    file_name = ['tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos_train_set.mat' ];
    train_results = load(file_name, 'latent_mu', 'truth');
    [~, ~, ~, ~, explained] = pca(train_results.latent_mu);
    train_explained(test_fold+1,:) = [0 cumsum(explained)'/100];
    if latent_dim == 24
      train_results.truth_fr = get_truth_fr(train_results.truth);
      [~, ~, ~, ~, explained] = pca(train_results.truth_fr);
      train_explained_n(test_fold+1,1:(1+length(explained))) = [0 cumsum(explained)'/100];
    end

    file_name = ['tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ];
    results = load(file_name, 'latent_mu', 'truth');
    [~, ~, ~, ~, explained] = pca(results.latent_mu);
    test_explained(test_fold+1,:) = [0 cumsum(explained)'/100];
    if latent_dim == 24
      results.truth_fr = get_truth_fr(results.truth);
      [~, ~, ~, ~, explained] = pca(results.truth_fr);
      test_explained_n(test_fold+1,1:(1+length(explained))) = [0 cumsum(explained)'/100];
    end
  end
  figure(f)
%   subplot(2,7,(regionIdx-1)*7+latentIdx)
  subplot(2,2,regionIdx)
  errorbar(0:latent_dim, mean(train_explained), ...
    mean(train_explained)-min(train_explained), ...
    mean(train_explained)-max(train_explained), 'LineWidth',1);
  hold on
  if latent_dim == 24
    errorbar(0:latent_dim, mean(train_explained_n), ...
      mean(train_explained_n)-min(train_explained_n), ...
      mean(train_explained_n)-max(train_explained_n), 'Color', 'k', 'LineWidth',1);
  end
  xlim([0 size(results.truth, 2)])
  ylim([0 1.1])
  title([rat ' ' region ' train set'])

  subplot(2,2,regionIdx+2)
  errorbar(0:latent_dim, mean(test_explained), ...
    mean(test_explained)-min(test_explained), ...
    mean(test_explained)-max(test_explained), 'LineWidth',1);
  hold on
  if latent_dim == 24
    errorbar(0:latent_dim, mean(test_explained_n), ...
      mean(test_explained_n)-min(test_explained_n), ...
      mean(test_explained_n)-max(test_explained_n), 'Color', 'k', 'LineWidth',1);
  end
  xlim([0 size(results.truth, 2)])
  ylim([0 1.1])
  title([rat ' ' region ' test set'])
  %   hold off
%   ylim([0 1])
end

if strcmp(rat, '025') && strcmp(region, 'M1')
  legend({'4', '6', '8', '16', '24', 'neural'}, 'Location','southeast')
else
  legend({'4', '8', '16', '24', 'neural'}, 'Location','southeast')
end

end


end
