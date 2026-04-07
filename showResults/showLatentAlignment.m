% 绘图：看latent factor align之后的trajectory
close all; clc; clear;
% addpath plotUtils\ utils\ plotUtils\Matlab_arrowPlot-master\

% load color_map.mat
% cmap = [flipud(high_lever); low_lever];

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-30 -3 25 25];

%% 
rat = '025';
DataName = 'rat025_0923';
latent_dim = 4;
test_fold = 2;

test_data = load(['latent_models_backup/tVAE_' rat '_M1_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'movements', 'trials', 'latent_std');
test_mPFC = load(['latent_models_backup/tVAE_' rat '_mPFC_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'movements', 'trials');
% train_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos_train_set.mat' ], ...
%     'latent_mu', 'latent_std', 'movements', 'trials');
SL_weights = load(['results/' DataName '_Sup_' num2str(test_fold) '.mat'], 'weights');
RL_weights = load(['results/' DataName '_RL_oldHP_' num2str(test_fold) '.mat'], 'weights');

TestSamples = length(test_mPFC.latent_mu);
inputUnitTest = [test_mPFC.latent_mu';ones(1,TestSamples)];

SL_data = test_data;
SL_data.latent_mu = (SL_weights.weights * inputUnitTest)';
RL_data = test_data;
RL_data.latent_mu = (RL_weights.weights * inputUnitTest)';

for i=1:4
  subplot(4,2,2*i-1)

  plot(30.01:0.01:60, test_data.latent_mu(3001:6000, i), 'k', 'LineWidth',1.5)
  hold on
  fill([30.01:0.01:60 fliplr(30.01:0.01:60)], ...
    [test_data.latent_mu(3001:6000, i)-test_data.latent_std(3001:6000, i); ...
    flipud(test_data.latent_mu(3001:6000, i)+test_data.latent_std(3001:6000, i))], ...
    'k', 'EdgeColor','none', 'FaceAlpha',0.3)
  plot(30.01:0.01:60, SL_data.latent_mu(3001:6000, i), 'r', 'LineWidth',1.5)
  plot(30.01:0.01:60, RL_data.latent_mu(3001:6000, i), 'b', 'LineWidth',1.5)
  hold off

  ax = gca;
  ax.XAxis.FontSize = 13;
  ax.YAxis.FontSize = 13;
  ax.XAxis.FontWeight = 'bold';
  ax.YAxis.FontWeight = 'bold';
  ax.LineWidth = 1.5;

  title(['\textbf{Rat~A~M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')

  text(-0.1, 1.1, ['\textbf{(' char('a'+i-1) ')}'], 'Interpreter','latex', ...
    'FontSize',14, 'Units','normalized', 'HorizontalAlignment','right')
end

legend(["M1 Latent dynamics", "", "Aligned by SL", "Aligned by RL"], ...
  'AutoUpdate','off', 'Box','on', 'Interpreter','latex', 'FontSize',14, ...
  'Orientation','horizontal', ...
  'Position',[0.26 0.96 0.65 0.0279]);

xlabel("\bf{time (sec)}", 'Interpreter','latex', 'FontSize',14)
ylabel("\bf{latent}", 'Interpreter','latex', 'FontSize',14)

% sum(SL_data.latent_mu < (test_data.latent_mu - 3*test_data.latent_std)) + ...
% sum(SL_data.latent_mu > (test_data.latent_mu + 3*test_data.latent_std))


%% 
rat = '028';
DataName = 'rat028_1030';
latent_dim = 4;
test_fold = 2;

test_data = load(['latent_models_backup/tVAE_' rat '_M1_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'movements', 'trials', 'latent_std');
test_mPFC = load(['latent_models_backup/tVAE_' rat '_mPFC_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'movements', 'trials');
% train_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos_train_set.mat' ], ...
%     'latent_mu', 'latent_std', 'movements', 'trials');
SL_weights = load(['results/' DataName '_Sup_' num2str(test_fold) '.mat'], 'weights');
RL_weights = load(['results/' DataName '_RL_oldHP_' num2str(test_fold) '.mat'], 'weights');

TestSamples = length(test_mPFC.latent_mu);
inputUnitTest = [test_mPFC.latent_mu';ones(1,TestSamples)];

SL_data = test_data;
SL_data.latent_mu = (SL_weights.weights * inputUnitTest)';
RL_data = test_data;
RL_data.latent_mu = (RL_weights.weights * inputUnitTest)';

for i=1:4
  subplot(4,2,2*i)

  plot(30.01:0.01:60, test_data.latent_mu(3001:6000, i), 'k', 'LineWidth',1.5)
  hold on
  fill([30.01:0.01:60 fliplr(30.01:0.01:60)], ...
    [test_data.latent_mu(3001:6000, i)-test_data.latent_std(3001:6000, i); ...
    flipud(test_data.latent_mu(3001:6000, i)+test_data.latent_std(3001:6000, i))], ...
    'k', 'EdgeColor','none', 'FaceAlpha',0.3)
  plot(30.01:0.01:60, SL_data.latent_mu(3001:6000, i), 'r', 'LineWidth',1.5)
  plot(30.01:0.01:60, RL_data.latent_mu(3001:6000, i), 'b', 'LineWidth',1.5)
  hold off

  ax = gca;
  ax.XAxis.FontSize = 13;
  ax.YAxis.FontSize = 13;
  ax.XAxis.FontWeight = 'bold';
  ax.YAxis.FontWeight = 'bold';
  ax.LineWidth = 1.5;

  title(['\textbf{Rat~B~M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')

  text(-0.1, 1.1, ['\textbf{(' char('e'+i-1) ')}'], 'Interpreter','latex', ...
    'FontSize',14, 'Units','normalized', 'HorizontalAlignment','right')
end


%%
% plot_dims = [1 3];
% subplot(131)
% plot_latent_space_by_trial_traj(test_data, plot_dims)
% xl = xlim(); yl = ylim();
% subplot(132)
% plot_latent_space_by_trial_traj(SL_data, plot_dims)
% xlim(xl); ylim(yl);
% subplot(133)
% plot_latent_space_by_trial_traj(RL_data, plot_dims)
% xlim(xl); ylim(yl);

%%
% figure(2)

%% plot latent space by single trial trajectory
function plot_latent_space_by_trial_traj(data, plot_dim)

[low_traj, high_traj] = find_trial_trajectory(data);

% for trialIdx = 1:size(low_traj, 1)
%   latent_mu = squeeze(low_traj(trialIdx,:,plot_dim));
% 
%   c = length(latent_mu) + (1:length(latent_mu));
%   dot_c = [0 1 0];
%   start = [mean(latent_mu(end-10,1)),mean(latent_mu(end-10,2))];
%   stop = [latent_mu(end,1),latent_mu(end,2)];
%   dir = stop - start;
%   start = start + 3*dir;
%   stop = stop + 3*dir;
% 
%   patch([latent_mu(:,1); NaN], [latent_mu(:,2); NaN], [c NaN], ...
%     'EdgeColor', 'flat', 'LineWidth', 1, 'MarkerFaceColor', 'flat', 'FaceColor', 'none');
%   hold on
%   plot(latent_mu(1,1),latent_mu(1,2), '.', 'MarkerSize',10, 'Color',dot_c)
%   arrow(start, stop, ...
%   'baseAngle', 60,...
%   'Length', 10, 'FaceColor','w', 'EdgeColor', dot_c, 'lineWidth', 1)
% end
% 
% for trialIdx = 1:size(high_traj, 1)
%   latent_mu = squeeze(high_traj(trialIdx,:,plot_dim));
% 
%   c = fliplr(1:length(latent_mu));
%   dot_c = [1 0 0];
%   start = [mean(latent_mu(end-10,1)),mean(latent_mu(end-10,2))];
%   stop = [latent_mu(end,1),latent_mu(end,2)];
%   dir = stop - start;
%   start = start + 3*dir;
%   stop = stop + 3*dir;
% 
%   patch([latent_mu(:,1); NaN], [latent_mu(:,2); NaN], [c NaN], ...
%     'EdgeColor', 'flat', 'LineWidth', 1, 'MarkerFaceColor', 'flat', 'FaceColor', 'none');
%   hold on
%   plot(latent_mu(1,1),latent_mu(1,2), '.', 'MarkerSize',10, 'Color',dot_c)
%   arrow(start, stop, ...
%   'baseAngle', 60,...
%   'Length', 10, 'FaceColor','w', 'EdgeColor', dot_c, 'lineWidth', 1)
% end


for trialIdx = 1:size(low_traj, 1)
  plot(squeeze(low_traj(trialIdx,1:200,plot_dim(1))), squeeze(low_traj(trialIdx,1:200,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
  hold on
  plot(squeeze(low_traj(trialIdx,201:251,plot_dim(1))), squeeze(low_traj(trialIdx,201:251,plot_dim(2))), 'b', 'LineWidth',0.2)
  plot(squeeze(low_traj(trialIdx,252:551,plot_dim(1))), squeeze(low_traj(trialIdx,252:551,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
  plot(squeeze(low_traj(trialIdx,552:651,plot_dim(1))), squeeze(low_traj(trialIdx,552:651,plot_dim(2))), 'g', 'LineWidth',0.2)
  plot(squeeze(low_traj(trialIdx,652:end,plot_dim(1))), squeeze(low_traj(trialIdx,652:end,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)    
end
for trialIdx = 1:size(high_traj, 1)
  plot(squeeze(high_traj(trialIdx,1:200,plot_dim(1))), squeeze(high_traj(trialIdx,1:200,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
  hold on
  plot(squeeze(high_traj(trialIdx,201:251,plot_dim(1))), squeeze(high_traj(trialIdx,201:251,plot_dim(2))), 'b', 'LineWidth',0.2)
  plot(squeeze(high_traj(trialIdx,252:551,plot_dim(1))), squeeze(high_traj(trialIdx,252:551,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
  plot(squeeze(high_traj(trialIdx,552:651,plot_dim(1))), squeeze(high_traj(trialIdx,552:651,plot_dim(2))), 'r', 'LineWidth',0.2)
  plot(squeeze(high_traj(trialIdx,652:end,plot_dim(1))), squeeze(high_traj(trialIdx,652:end,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)    
end
hold off

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;

end

%%
function [low_traj, high_traj] = find_trial_trajectory(data)

trial_no = unique(data.trials);
latent_dim = size(data.latent_mu, 2);

low_traj.rest = zeros(1, 251, latent_dim);
low_traj.reach = zeros(1, 300, latent_dim);
low_traj.press = zeros(1, 100, latent_dim);
low_traj.release = zeros(1, 100, latent_dim);

high_traj.rest = zeros(1, 251, latent_dim);
high_traj.reach = zeros(1, 300, latent_dim);
high_traj.press = zeros(1, 100, latent_dim);
high_traj.release = zeros(1, 100, latent_dim);

low_count = 1;
high_count = 1;
for i = 1:length(trial_no)

  all_indices = find(data.trials==trial_no(i));
  
  movements = data.movements(all_indices);

%   if length(movements)<600
%     continue
%   end

  trialType = max(movements);
  press_start = find(movements==trialType, 1, 'first');
  press_end = find(movements==trialType, 1, 'last');

  if length(movements(press_end:end))<10 % no release
    continue
  end

  if length(movements(252:press_start))<10 % no reaching
    continue
  end

  latent_mu = gaussianSmooth(data.latent_mu(all_indices,:), 10);
%   latent_mu = data.latent_mu(all_indices,:);

  if trialType == 2
    low_traj.rest(low_count,:,:) = latent_mu(1:251,:);
    low_traj.reach(low_count,:,:) = resample_vector(latent_mu(252:press_start-1,:), 300);
    low_traj.press(low_count,:,:) = resample_vector(latent_mu(press_start:press_end,:), 100);
    low_traj.release(low_count,:,:) = resample_vector(latent_mu(press_end+1:end,:), 100);
    low_count = low_count + 1;
  elseif trialType == 3
    high_traj.rest(high_count,:,:) = latent_mu(1:251,:);
    high_traj.reach(high_count,:,:) = resample_vector(latent_mu(252:press_start-1,:), 300);
    high_traj.press(high_count,:,:) = resample_vector(latent_mu(press_start:press_end,:), 100);
    high_traj.release(high_count,:,:) = resample_vector(latent_mu(press_end+1:end,:), 100);  
    high_count = high_count + 1;
  end

end

low_traj = cat(2, low_traj.rest, low_traj.reach, low_traj.press, low_traj.release);
high_traj = cat(2, high_traj.rest, high_traj.reach, high_traj.press, high_traj.release);

end

function Y = resample_vector(X, len)
  
Y = zeros(len, size(X,2));

for i = 1:size(X,2)
  x = X(:,i);

  % 创建原始数据的 x 坐标
  x_orig = linspace(1, length(x), length(x));

  % 创建插值数据的 x 坐标
  x_interp = linspace(1, length(x), len);

  % 使用线性插值
  Y(:,i) = interp1(x_orig, x, x_interp, 'linear');
end

end
