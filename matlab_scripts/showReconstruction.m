% 绘图：展示test set上neural reconstruction的结果
close all; clc; clear;
addpath plotUtils\

%%
rat = '028';
region = 'mPFC';
latent_dim = 4;

for test_fold = 0:4

full_dim = load(['results/tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_24latent_decoder_pos.mat' ]);
full_dim.predicted_spikes = double(full_dim.predicted_spikes);
full_dim.truth_fr = get_truth_fr(full_dim.truth);

less_dim = load(['results/tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
less_dim.predicted_spikes = double(less_dim.predicted_spikes);

figure("Name", [rat ' ' region ' fold: ' num2str(test_fold)])
plotIndex = (1:3000) + 3000;  % TODO: explore for best fit
for i=1:size(full_dim.truth_fr, 2)
  if strcmp(region, 'M1')
    subplot(3,3,i)
  else
    subplot(4,4,i)
  end

  show_one_neuron(full_dim, less_dim, i, plotIndex)
end

end

%% show 1 neuron
function show_one_neuron(data1, data2, i, plotIndex)

% [bestStart, bestEnd] = findBestFit(data.truth_fr(:,i), data.predictions(:,i), data.movements, 3000);
% plotIndex = bestStart:bestEnd;
timeIndex = plotIndex/100;

pos = max([data1.truth_fr(plotIndex, i); data1.predictions(plotIndex, i)]);

area(timeIndex, 1.1*pos*(data1.movements(plotIndex)==1), 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
hold on
area(timeIndex, 1.1*pos*(data1.movements(plotIndex)==2), 'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeAlpha',0);
area(timeIndex, 1.1*pos*(data1.movements(plotIndex)==3), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha',0);

plot(timeIndex, data1.truth_fr(plotIndex, i), 'k', LineWidth=2);
plot(timeIndex, data1.predictions(plotIndex, i), 'Color', 'm', LineWidth=1.5); 
plot(timeIndex, data2.predictions(plotIndex, i), 'Color', 'c', LineWidth=1.5); 
yl = ylim();

plotSpikes(timeIndex, data1.truth(plotIndex,i)', pos*1.35, 'k', 6);
plotSpikes(timeIndex, data1.predicted_spikes(plotIndex,i)', pos*1.2, 'm', 6);
plotSpikes(timeIndex, data2.predicted_spikes(plotIndex,i)', pos*1.5, 'c', 6);

hold off
set(gca, 'TickLabelInterpreter', 'latex')
ylim([yl(1) pos*1.6]);

% xlabel('time (sec)', FontSize=19, Interpreter='latex', FontWeight='bold')
% ylabel('firing probability', FontSize=19, Interpreter='latex', FontWeight='bold')

% ax = gca;
% ax.XAxis.FontSize = 19;
% ax.YAxis.FontSize = 19;
% % ax.XAxis.FontWeight = 'bold';
% % ax.YAxis.FontWeight = 'bold';
% ax.LineWidth = 2;
end