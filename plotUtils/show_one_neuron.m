function show_one_neuron(data, i, plotIndex)

% [bestStart, bestEnd] = findBestFit(data.truth_fr(:,i), data.predictions(:,i), data.movements, 3000);
% plotIndex = bestStart:bestEnd;
timeIndex = plotIndex/100;

pos = max([data.truth_fr(plotIndex, i); data.predictions(plotIndex, i)]);

area(timeIndex, 1.1*pos*(data.movements(plotIndex)==1), 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
hold on
area(timeIndex, 1.1*pos*(data.movements(plotIndex)==2), 'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeAlpha',0);
area(timeIndex, 1.1*pos*(data.movements(plotIndex)==3), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha',0);

hold on
plot(timeIndex, data.truth_fr(plotIndex, i), 'k', LineWidth=2.5);
plot(timeIndex, gaussianSmooth(data.predictions(plotIndex, i), 1), 'Color', 'm', LineWidth=2); 
yl = ylim();

plotSpikes(timeIndex, data.truth(plotIndex,i)', pos*1.35, 'k', 12);
plotSpikes(timeIndex, data.predicted_spikes(plotIndex,i)', pos*1.2, 'm', 12);

hold off
set(gca, 'TickLabelInterpreter', 'latex')
ylim([yl(1) pos*1.45]);

xlabel('time (sec)', FontSize=19, Interpreter='latex', FontWeight='bold')
ylabel('firing probability', FontSize=19, Interpreter='latex', FontWeight='bold')

ax = gca;
ax.XAxis.FontSize = 19;
ax.YAxis.FontSize = 19;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 2;
end

