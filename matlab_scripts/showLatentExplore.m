% 绘图：画出不同latent dim下的NLL，CC，success rate的performance，用于model selection
clear; clc; close all
addpath results\ utils\ matlab_decoding\

rat = '025';
data = load('data\rat025_0923.mat');
plot_1_rat(rat, data)

rat = '028';
data = load('data\rat028_1030.mat');
plot_1_rat(rat, data)


%%
function plot_1_rat(rat, data)

f = figure(Name=rat);

regionList = {'M1', 'mPFC'};
for regionIdx = 1:2
  region = regionList{regionIdx};
  latentList = [1 2 3 4 8 16 24];
  if strcmp(rat, '025') && strcmp(region, 'M1')
    latentList = [1 2 3 4 6 8 16 24];
  end
  train_loss = zeros(5,7);
  val_loss = zeros(5,7);
  val_loss_best = zeros(5,7);
  best_val_idx = zeros(5,7);
  % val_DBR = cell(3,3);
  train_cc = zeros(5,7);
  val_cc = zeros(5,7);
  train_behavioral = zeros(5,7);
  val_behavioral = zeros(5,7);
for latentIdx = 1:length(latentList)
  for test_fold=0:4
    latent_dim = latentList(latentIdx);

    file_name = ['tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ];
    results = load(file_name, 'train_loss_all', 'val_loss_all', 'predictions', 'truth', 'movements');
    train_loss(test_fold+1,latent_dim) = results.train_loss_all(end,2);
    val_loss(test_fold+1,latent_dim) = results.val_loss_all(end,2);
    [val_loss_best(test_fold+1,latent_dim), best_val_idx(test_fold+1,latent_dim)] = min(results.val_loss_all(:,2));

    results.truth_fr = get_truth_fr(results.truth);
    val_cc(test_fold+1,latent_dim) = mean(arrayfun(@(i) corr(results.predictions(:,i), results.truth_fr(:,i)), 1:size(results.truth, 2)));

    if strcmp(region, 'M1')
      [~,val_behavioral(test_fold+1,latent_dim),~] = emulator( ...
        results.predictions,results.movements,data.M1order(1:data.M1num_pre),data.his,data.modelName);
    end

    file_name = ['tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos_train_set.mat' ];
    train_results = load(file_name, 'predictions', 'truth', 'movements');
    train_results.truth_fr = get_truth_fr(train_results.truth);
    train_cc(test_fold+1,latent_dim) = mean(arrayfun(@(i) corr(train_results.predictions(:,i), train_results.truth_fr(:,i)), 1:size(train_results.truth, 2)));

    if strcmp(region, 'M1')
      [~,train_behavioral(test_fold+1,latent_dim),~] = emulator( ...
        train_results.predictions,train_results.movements,data.M1order(1:data.M1num_pre),data.his,data.modelName);
    end

  end
end

figure(f)
subplot(2,3,(regionIdx-1)*3+1)
l1 = plot_loss_curve_with_errorbar(train_loss);
hold on
l2 = plot_loss_curve_with_errorbar(val_loss);
% plot_loss_curve_with_errorbar(val_loss_best)
hold off
legend([l1, l2], {'train loss', 'test loss'})
title([rat, ' ', region, ' NLL'])

[~,worst_fold] = max(train_loss(:,latentList));
disp([rat ' worst fold in train loss: ', num2str(worst_fold)])
[~,worst_fold] = max(val_loss(:,latentList));
disp([rat ' worst fold in test loss: ', num2str(worst_fold)])

subplot(2,3,(regionIdx-1)*3+2)
plot_loss_curve_with_errorbar(train_cc);
hold on
plot_loss_curve_with_errorbar(val_cc);
hold off
title([rat, ' ', region, ' CC'])

[~,worst_fold] = min(train_cc(:,latentList));
disp([rat ' worst fold in train cc: ', num2str(worst_fold)])
[~,worst_fold] = min(val_cc(:,latentList));
disp([rat ' worst fold in test cc: ', num2str(worst_fold)])

if strcmp(region, 'M1')
%   [~,val_behavioral_truth,~] = emulator( ...
%     results.truth',results.movements,data.M1order(1:data.M1num_pre),data.his,data.modelName);

  subplot(2,3,(regionIdx-1)*3+3)
  plot_loss_curve_with_errorbar(train_behavioral);
  hold on
  plot_loss_curve_with_errorbar(val_behavioral);
%   plot([0.5 24.5], [val_behavioral_truth val_behavioral_truth], 'k')
  hold off
  title([rat, ' ', region, ' success rate'])
  
  [~,worst_fold] = min(train_behavioral(:,latentList));
  disp([rat ' worst fold in train success: ', num2str(worst_fold)])
  [~,worst_fold] = min(val_behavioral(:,latentList));
  disp([rat ' worst fold in test success: ', num2str(worst_fold)])
end

drawnow

end
end

%%
function l = plot_loss_curve_with_errorbar(plot_loss)
    index = find(plot_loss(1,:));
%     errorbar(index, ...
%       mean(plot_loss(:,index)), ...
%       mean(plot_loss(:,index)) - min(plot_loss(:,index)), ...
%       max(plot_loss(:,index)) - mean(plot_loss(:,index)), ...
%       "LineWidth", 1.5)
    l = plot(index, mean(plot_loss(:,index)), "LineWidth", 1.5);
    hold on
    for i=1:length(index)
      plot(index(i), plot_loss(:,index(i)), 'Color',l.Color, 'Marker','.')
    end
    hold off
    xticks(index)
end
