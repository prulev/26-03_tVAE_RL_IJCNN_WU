% 绘图：看latent factor在time domain上的表现
close all; clc; clear;
addpath plotUtils\ utils\

%%
rat = '028';
region = 'M1';
latent_dim = 4;

for test_fold = 0:4

  test_data = load(['results/tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'latent_std', 'movements', 'trials');
  
  [~, test_data.latent_mu] = pca(test_data.latent_mu);
  [low_traj, high_traj] = find_trial_trajectory(test_data);

  subplot(2,3,test_fold+1)
  for trialIdx = 1:size(low_traj, 1)
    plot(squeeze(low_traj(trialIdx,1:200,1)), squeeze(low_traj(trialIdx,1:200,2)), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
    hold on
    plot(squeeze(low_traj(trialIdx,201:251,1)), squeeze(low_traj(trialIdx,201:251,2)), 'b', 'LineWidth',0.2)
    plot(squeeze(low_traj(trialIdx,252:551,1)), squeeze(low_traj(trialIdx,252:551,2)), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
    plot(squeeze(low_traj(trialIdx,552:651,1)), squeeze(low_traj(trialIdx,552:651,2)), 'g', 'LineWidth',0.2)
    plot(squeeze(low_traj(trialIdx,652:end,1)), squeeze(low_traj(trialIdx,652:end,2)), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)    
  end
  for trialIdx = 1:size(high_traj, 1)
    plot(squeeze(high_traj(trialIdx,1:200,1)), squeeze(high_traj(trialIdx,1:200,2)), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
    hold on
    plot(squeeze(high_traj(trialIdx,201:251,1)), squeeze(high_traj(trialIdx,201:251,2)), 'b', 'LineWidth',0.2)
    plot(squeeze(high_traj(trialIdx,252:551,1)), squeeze(high_traj(trialIdx,252:551,2)), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)
    plot(squeeze(high_traj(trialIdx,552:651,1)), squeeze(high_traj(trialIdx,552:651,2)), 'r', 'LineWidth',0.2)
    plot(squeeze(high_traj(trialIdx,652:end,1)), squeeze(high_traj(trialIdx,652:end,2)), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.2)    
  end
  hold off

end

figure()
for i=1:min(4, latent_dim)

  subplot(4,2,2*i-1)
  plot(squeeze(low_traj(:,:,i))', 'LineWidth',0.3); hold on
  yl = ylim();
  plot([252 252], yl, 'k', LineWidth=3)
  plot([552 552], yl, 'k', LineWidth=3)
  plot([652 652], yl, 'k', LineWidth=3)
  hold off

  subplot(4,2,2*i)
  plot(squeeze(high_traj(:,:,i))', 'LineWidth',0.3); hold on
  yl = ylim();
  plot([252 252], yl, 'k', LineWidth=3)
  plot([552 552], yl, 'k', LineWidth=3)
  plot([652 652], yl, 'k', LineWidth=3)
  hold off
end
subplot(4,2,1)
title('low trials PC 1~4')
subplot(4,2,2)
title('high trials PC 1~4')

% subplot(1,2,1)
% for trialIdx = 1:size(low_traj, 1)
%   plot3(squeeze(low_traj(trialIdx,:,1)), squeeze(low_traj(trialIdx,:,2)), squeeze(low_traj(trialIdx,:,3)))
%   hold on
% end
% hold off
% 
% subplot(1,2,2)
% for trialIdx = 1:size(high_traj, 1)
%   plot3(squeeze(high_traj(trialIdx,:,1)), squeeze(high_traj(trialIdx,:,2)), squeeze(high_traj(trialIdx,:,3)))
%   hold on
% end
% hold off

% figure()
% for trialIdx = 1:size(low_traj, 1)
%   plot3(squeeze(low_traj(trialIdx,:,1)), squeeze(low_traj(trialIdx,:,2)), squeeze(low_traj(trialIdx,:,3)), 'g')
%   hold on
% end
% for trialIdx = 1:size(high_traj, 1)
%   plot3(squeeze(high_traj(trialIdx,:,1)), squeeze(high_traj(trialIdx,:,2)), squeeze(high_traj(trialIdx,:,3)), 'r')
%   hold on
% end
% hold off

% figure()
% for trialIdx = 1:size(low_traj, 1)
%   plot(squeeze(low_traj(trialIdx,:,1)), squeeze(low_traj(trialIdx,:,2)), 'g')
%   hold on
% end
% for trialIdx = 1:size(high_traj, 1)
%   plot(squeeze(high_traj(trialIdx,:,1)), squeeze(high_traj(trialIdx,:,2)), 'r')
%   hold on
% end
% hold off


%%

% figure("Name", rat)
% for test_fold = 0:4
% 
% load(['results/tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
%   'latent_mu', 'latent_std', 'movements');
% 
% % figure("Name", [rat ' ' region ' fold: ' num2str(test_fold)])
% 
% plotIndex = (1:3000) + 3000;  % TODO: explore for best fit
% for i=1:size(latent_mu, 2)
%   subplot(4,5,test_fold+i*5-4)
%   plot_1_latent(latent_mu, latent_std, movements, plotIndex, i)
% end
% 
% end

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

function plot_1_latent(mu, std, movements, plotIndex, i)

timeIndex = plotIndex / 100;

pos = max(mu(plotIndex, i) + 3*std(plotIndex, i));

area(timeIndex, 1.1*pos*(movements(plotIndex)==1), 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
hold on
area(timeIndex, 1.1*pos*(movements(plotIndex)==2), 'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeAlpha',0);
area(timeIndex, 1.1*pos*(movements(plotIndex)==3), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha',0);

plot(timeIndex, mu(plotIndex, i), 'k', LineWidth=1)
hold on
fill([timeIndex, fliplr(timeIndex)], ...
  [mu(plotIndex, i)-3*std(plotIndex, i); flipud(mu(plotIndex, i)+3*std(plotIndex, i))], ...
  'k', FaceAlpha=0.3, EdgeColor="none")
hold off

end
