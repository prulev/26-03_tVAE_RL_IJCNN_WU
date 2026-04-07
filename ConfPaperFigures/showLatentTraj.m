% 绘图：看latent factor的trajectory
close all; clc; clear;

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [1 1 25 25];

actionsColor = [0 0.4470 0.7410; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840];

rat = '025';
latent_dim = 4;
test_fold = 2;

region = 'mPFC';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'latent_std', 'movements', 'trials');
s = subplot(221);
plot_latent_space_by_trial_traj(test_data, [1 3], actionsColor)
% title("\textbf{Rat~A~mPFC~latent~dynamics}", 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
title("\textbf{mPFC~latent~dynamics}", 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
xlabel("\bf{latent dimension 1}", 'Interpreter','latex', 'FontSize',14)
ylabel("\bf{latent dimension 3}", 'Interpreter','latex', 'FontSize',14)
text(-0.1, 1.05, "\textbf{(a)}", 'Interpreter','latex', ...
  'FontSize',14, 'Units','normalized', 'HorizontalAlignment','right')
temp = get(gca, "Children");
leg = legend([temp(5) temp(103) temp(248) temp(6)], ...
  ["\textbf{Rest}", "\textbf{Press~high}", "\textbf{Press~low}", "\textbf{Intermediate~states}"], ...
  'AutoUpdate','off', 'Box','on', 'Interpreter','latex', 'FontSize',14, ...
  'Orientation','horizontal', ...
  'NumColumns',2,...
  'Position',[0.08 0.92 0.4 0.05]);
s.Position(2) = s.Position(2) - 0.06;

%%
region = 'M1';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
    'latent_mu', 'latent_std', 'movements', 'trials');
% temp = load(['results/rat025_0923', '_RL_oldHP_', num2str(test_fold), '.mat']);  
% test_data.latent_mu = temp.M1_latent_test;

s = subplot(222);
plot_latent_space_by_trial_traj(test_data, [1 4], actionsColor)
% title("\textbf{Rat~A~M1~latent~dynamics}", 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
title("\textbf{M1~latent~dynamics}", 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
xlabel("\bf{latent dimension 1}", 'Interpreter','latex', 'FontSize',14)
ylabel("\bf{latent dimension 4}", 'Interpreter','latex', 'FontSize',14)
text(-0.1, 1.1, "\textbf{(b)}", 'Interpreter','latex', ...
  'FontSize',14, 'Units','normalized', 'HorizontalAlignment','right')
s.Position(2) = s.Position(2) - 0.06;

%%
xlim([-4 6])

temp = load(['results/rat025_0923', '_RL_oldHP_', num2str(test_fold), '.mat']);  
latent_mu = temp.M1_latent_pre_test;
movements = temp.testActions;

subplot(2,2,4)
plot(latent_mu(1, movements==1), latent_mu(4, movements==1), '.b')
hold on
plot(latent_mu(1, movements==2), latent_mu(4, movements==2), '.y')
hold on
plot(latent_mu(1, movements==3), latent_mu(4, movements==3), '.r')
hold off

subplot(224)
ylim([-3 2])

%% plot latent space by single trial trajectory
function plot_latent_space_by_trial_traj(data, plot_dim, actionsColor)

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
  plot(squeeze(low_traj(trialIdx,1:200,plot_dim(1))), squeeze(low_traj(trialIdx,1:200,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.5)
  hold on
  plot(squeeze(low_traj(trialIdx,201:251,plot_dim(1))), squeeze(low_traj(trialIdx,201:251,plot_dim(2))), 'Color', actionsColor(1,:), 'LineWidth',1)
  plot(squeeze(low_traj(trialIdx,252:551,plot_dim(1))), squeeze(low_traj(trialIdx,252:551,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.5)
  plot(squeeze(low_traj(trialIdx,552:651,plot_dim(1))), squeeze(low_traj(trialIdx,552:651,plot_dim(2))), 'Color', actionsColor(2,:), 'LineWidth',1)
  plot(squeeze(low_traj(trialIdx,652:end,plot_dim(1))), squeeze(low_traj(trialIdx,652:end,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.5)    
end
for trialIdx = 1:size(high_traj, 1)
  plot(squeeze(high_traj(trialIdx,1:200,plot_dim(1))), squeeze(high_traj(trialIdx,1:200,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.5)
  hold on
  plot(squeeze(high_traj(trialIdx,201:251,plot_dim(1))), squeeze(high_traj(trialIdx,201:251,plot_dim(2))), 'Color', actionsColor(1,:), 'LineWidth',1)
  plot(squeeze(high_traj(trialIdx,252:551,plot_dim(1))), squeeze(high_traj(trialIdx,252:551,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.5)
  plot(squeeze(high_traj(trialIdx,552:651,plot_dim(1))), squeeze(high_traj(trialIdx,552:651,plot_dim(2))), 'Color', actionsColor(3,:), 'LineWidth',1)
  plot(squeeze(high_traj(trialIdx,652:end,plot_dim(1))), squeeze(high_traj(trialIdx,652:end,plot_dim(2))), 'Color', [0.5 0.5 0.5 0.3], 'LineWidth',0.5)    
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

  latent_mu = gaussianSmooth(data.latent_mu(all_indices,:), 5);
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
