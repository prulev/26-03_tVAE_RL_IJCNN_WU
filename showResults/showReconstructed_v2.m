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
plotNeurons = [2 7 12];
for i=1:length(plotNeurons)
  subplot(4,3,i)
  show_one_neuron(test_data, plotNeurons(i), plotIndex)
  title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
end
legend({'Rest', 'Press Low', 'Press High', 'Real', 'Reconstruct'}, ...
  'Interpreter','latex', 'Orientation','horizontal', 'FontSize',13, ...
  'Position',[0.3 0.48 0.61 0.03])
subplot(4,3,1)
text(-0.2, 1.3, "\textbf{Rat~A}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

[~, DBR] = DBR_avg_Calc(test_data.truth_fr', test_data.truth', opt);
disp(['Smoothed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])

[~, DBR] = DBR_avg_Calc(test_data.predictions', test_data.truth', opt);
disp(['Reconstructed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])
disp(' ')

region = 'M1';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);
plotIndex = (1:3000) + 3000;
plotNeurons = [1 2 3];
for i=1:length(plotNeurons)
  subplot(4,3,i+3)
  show_one_neuron(test_data, plotNeurons(i), plotIndex)
  title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
end

[~, DBR] = DBR_avg_Calc(test_data.truth_fr', test_data.truth', opt);
disp(['Smoothed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])

[~, DBR] = DBR_avg_Calc(test_data.predictions', test_data.truth', opt);
disp(['Reconstructed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])
disp(' ')

for i=1:6
  s = subplot(4,3,i);
  s.Position(2) = s.Position(2) + 0.01;
end

%%
rat = '028';
latent_dim = 4;
test_fold = 2;

region = 'mPFC';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);
plotIndex = (1:3000) + 3000;  % TODO: explore for best fit
plotNeurons = [12 13 14];
for i=1:length(plotNeurons)
  subplot(4,3,i+6)
  show_one_neuron(test_data, plotNeurons(i), plotIndex)
  title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
end
subplot(4,3,1+6)
text(-0.2, 1.3, "\textbf{Rat~B}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

[~, DBR] = DBR_avg_Calc(test_data.truth_fr', test_data.truth', opt);
disp(['Smoothed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])
[~, DBR] = DBR_avg_Calc(test_data.predictions', test_data.truth', opt);
disp(['Reconstructed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])
disp(' ')

region = 'M1';
test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);
plotIndex = (1:3000) + 3000;
plotNeurons = [1 3 5];
for i=1:length(plotNeurons)
  subplot(4,3,i+9)
  show_one_neuron(test_data, plotNeurons(i), plotIndex)
  title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
end

[~, DBR] = DBR_avg_Calc(test_data.truth_fr', test_data.truth', opt);
disp(['Smoothed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])
[~, DBR] = DBR_avg_Calc(test_data.predictions', test_data.truth', opt);
disp(['Reconstructed ' region ' mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])
disp([num2str(sum(DBR<1)/length(DBR)*100) '% DBR < 1'])
disp(' ')

subplot(4,3,10)
xlabel("time (sec)", 'Interpreter','latex', 'FontSize',14)
ylabel("firing probability", 'Interpreter','latex', 'FontSize',14)

for i=7:12
  s = subplot(4,3,i);
  s.Position(2) = s.Position(2) - 0.06;
end

%% show 1 neuron
function show_one_neuron(data, i, plotIndex)

% [bestStart, bestEnd] = findBestFit(data.truth_fr(:,i), data.predictions(:,i), data.movements, 3000);
% plotIndex = bestStart:bestEnd;
timeIndex = plotIndex/100;

pos = max([data.truth_fr(plotIndex, i); data.predictions(plotIndex, i)]);

area(timeIndex, 1.1*pos*(data.movements(plotIndex)==1), 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
hold on
area(timeIndex, 1.1*pos*(data.movements(plotIndex)==2), 'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeAlpha',0);
area(timeIndex, 1.1*pos*(data.movements(plotIndex)==3), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha',0);

plot(timeIndex, data.truth_fr(plotIndex, i), 'k', LineWidth=2);
plot(timeIndex, data.predictions(plotIndex, i), 'Color', 'm', LineWidth=1.5); 
yl = ylim();

plotSpikes(timeIndex, data.truth(plotIndex,i)', pos*1.35, 'k', 6);
plotSpikes(timeIndex, data.predicted_spikes(plotIndex,i)', pos*1.2, 'm', 6);

hold off
set(gca, 'TickLabelInterpreter', 'latex')
ylim([yl(1) pos*1.4]);

% xlabel('time (sec)', FontSize=19, Interpreter='latex', FontWeight='bold')
% ylabel('firing probability', FontSize=19, Interpreter='latex', FontWeight='bold')

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;
end