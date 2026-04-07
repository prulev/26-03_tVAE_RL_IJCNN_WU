% 绘图：看latent factor的trajectory
close all; clc; clear;
addpath plotUtils\ utils\ plotUtils\Matlab_arrowPlot-master\
% load color_map.mat
% cmap = [flipud(high_lever); low_lever];

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-40 -3 14 25];

%% 
rat = '025';
region = 'M1';
latent_dim = 4;
test_fold = 2;

test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'latent_std', 'movements', 'trials');
train_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos_train_set.mat' ], ...
    'latent_mu', 'latent_std', 'movements', 'trials');

% show latent factors in each subplot
plotIndex = 3001:6000;
timeIndex = 30.01:0.01:60;


for i=1:4
  subplot(4,2,i)
  show_1_latent(test_data, i, timeIndex, plotIndex)
end

% show latent scatter
subplot(212)
% plot_latent_space_by_points(test_data, [1 2])
plot_latent_space_by_trial_traj(test_data, [1 4])
hold on
plot_latent_space_by_trial_traj(train_data, [1 4])
hold off
% colormap(cmap);

%% show one latent
function show_1_latent(data, i, timeIndex, plotIndex)

yl = [0,0];
yl(1) = 1.2 * min(data.latent_mu(plotIndex, i) - 3*data.latent_std(plotIndex, i));
yl(2) = 1.2 * max(data.latent_mu(plotIndex, i) + 3*data.latent_std(plotIndex, i));

% plot action area
area(timeIndex, diff(yl)*((data.movements(plotIndex)==1) - 0.5) + mean(yl), yl(1), ...
  'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
hold on
area(timeIndex, diff(yl)*((data.movements(plotIndex)==2) - 0.5) + mean(yl), yl(1), ...
  'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
area(timeIndex, diff(yl)*((data.movements(plotIndex)==3) - 0.5) + mean(yl), yl(1), ...
  'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 

plot(timeIndex, data.latent_mu(plotIndex,i), 'k', LineWidth=1.5); hold on
fill([timeIndex, fliplr(timeIndex)], ...
  [data.latent_mu(plotIndex,i)+3*data.latent_std(plotIndex,i); ...
  flipud(data.latent_mu(plotIndex,i)-3*data.latent_std(plotIndex,i))], 'k', 'FaceAlpha', 0.2, 'EdgeAlpha',0)
hold off

ylim(yl/1.2);

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;

end

%% plot latent space by points
function plot_latent_space_by_points(data, plot_dim)

movements = data.movements;
latent_mu = data.latent_mu(:, plot_dim);

indices = (movements==0);
plot(latent_mu(indices,1),latent_mu(indices,2), '.', 'MarkerEdgeColor',[0.5 0.5 0.5],'MarkerSize',3)
hold on

indices = (movements==1);
plot(latent_mu(indices,1),latent_mu(indices,2), 'b.','MarkerSize',5);

indices = (movements==2);
plot(latent_mu(indices,1),latent_mu(indices,2), 'g.','MarkerSize',5);

indices = (movements==3);
plot(latent_mu(indices,1),latent_mu(indices,2), 'r.','MarkerSize',5);
hold off

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;

end

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
