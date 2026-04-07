% 绘图：展示test set上neural reconstruction的结果
close all; clc; clear;
addpath plotUtils\ utils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-30 -3 25 23];

timeslot = 10;              % interval of time-bin
opt.sampleRate = 1000/timeslot; %s ampleRate
opt.DTCorrelation = 1;      % 1 for DTKS, 0 for prototyped KS
opt.KS_N = 10;              % number of repeated calculations


%% 
rat = '025';
latent_dim = 4;
test_fold = 2;

region = 'mPFC';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);
plotIndex = (1:3000) + 3000;  % TODO: explore for best fit
plotNeurons = 2; %[2 7 12];
for i=1:length(plotNeurons)
  subplot(2,1,1)
  show_one_neuron(test_data, plotNeurons(i), plotIndex)
  title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
end
legend({'Rest', 'Press Low', 'Press High', 'Real', 'Reconstruct'}, ...
  'Interpreter','latex', 'Orientation','horizontal', 'FontSize',13, ...
  'Position',[0.3 0.48 0.61 0.03])
subplot(2,1,1)
text(-0.2, 1.3, "\textbf{Rat~A}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

region = 'M1';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);
plotIndex = (1:3000) + 3000;
plotNeurons = 1; %[1 2 3];
for i=1:length(plotNeurons)
  subplot(2,1,2)
  show_one_neuron(test_data, plotNeurons(i), plotIndex)
  title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
end