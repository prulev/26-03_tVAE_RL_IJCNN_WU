% 绘图：展示test set上neural reconstruction的结果
close all; clc; clear;
addpath plotUtils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [1 -3 25 9];

%% 
rat = '028';
region = 'M1';
latent_dim = 4;
test_fold = 2;

test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);

test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);

plotIndex = (1:3000) + 3000;  % TODO: explore for best fit
% plotNeurons = [2 7 12];
for i=1:size(test_data.truth_fr, 2)
%   if strcmp(region, 'M1')
%     subplot(3,3,i)
%   else
%     subplot(4,4,i)
%   end
%   subplot(1,3,i)
%   show_one_neuron(test_data, plotNeurons(i), plotIndex)
%   title([region ' Neuron ', num2str(plotNeurons(i))])
  subplot(5,5,i)
  show_one_neuron(test_data, i, plotIndex)
  title([region ' Neuron ', num2str(i)])

end
legend({'Rest', 'Press Low', 'Press High', 'Real', 'Reconstruct'}, ...
  'Interpreter','latex', 'Orientation','horizontal')
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