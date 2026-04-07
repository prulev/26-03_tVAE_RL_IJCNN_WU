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

subplot(4,2,1)
i= 1;
plot(30.01:0.01:60, test_data.latent_mu(3001:6000, i), 'k', 'LineWidth',1.5)
hold on
fill([30.01:0.01:60 fliplr(30.01:0.01:60)], ...
  [test_data.latent_mu(3001:6000, i)-3*test_data.latent_std(3001:6000, i); ...
  flipud(test_data.latent_mu(3001:6000, i)+3*test_data.latent_std(3001:6000, i))], ...
  'k', 'EdgeColor','none', 'FaceAlpha',0.3)
% plot(30.01:0.01:60, SL_data.latent_mu(3001:6000, i), 'r', 'LineWidth',1.5)
plot(30.01:0.01:60, RL_data.latent_mu(3001:6000, i), 'b', 'LineWidth',1.5)
hold off

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;

title(['\textbf{Rat~A~M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')


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


subplot(4,2,2)
i= 4;
plot(30.01:0.01:60, test_data.latent_mu(3001:6000, i), 'k', 'LineWidth',1.5)
hold on
fill([30.01:0.01:60 fliplr(30.01:0.01:60)], ...
  [test_data.latent_mu(3001:6000, i)-3*test_data.latent_std(3001:6000, i); ...
  flipud(test_data.latent_mu(3001:6000, i)+3*test_data.latent_std(3001:6000, i))], ...
  'k', 'EdgeColor','none', 'FaceAlpha',0.3)
% plot(30.01:0.01:60, SL_data.latent_mu(3001:6000, i), 'r', 'LineWidth',1.5)
plot(30.01:0.01:60, RL_data.latent_mu(3001:6000, i), 'b', 'LineWidth',1.5)
hold off

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;

title(['\textbf{Rat~B~M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')

% text(-0.1, 1.1, ['\textbf{(' char('a'+i-1) ')}'], 'Interpreter','latex', ...
%   'FontSize',14, 'Units','normalized', 'HorizontalAlignment','right')

legend(["M1 Latent dynamics", "3$\sigma$ range", "Aligned by RL"], ...
  'AutoUpdate','off', 'Box','on', 'Interpreter','latex', 'FontSize',14, ...
  'Orientation','horizontal', ...
  'Position',[0.26 0.96 0.65 0.0279]);

xlabel("\bf{time (sec)}", 'Interpreter','latex', 'FontSize',14)
ylabel("\bf{latent}", 'Interpreter','latex', 'FontSize',14)

% sum(SL_data.latent_mu < (test_data.latent_mu - 3*test_data.latent_std)) + ...
% sum(SL_data.latent_mu > (test_data.latent_mu + 3*test_data.latent_std))



