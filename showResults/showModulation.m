clear; clc; close all
addpath plotUtils\

% modelColor = [250 0 0; 54 56 131; 103 146 70] / 255;
modelColor = {'k', 'r', 'g', 'b', 'm'};
% actionsColor = [0 0.4470 0.8410; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840];

getPlotModulation = @(x) [
  smoothdata(squeeze(sum(x(:,:,1:51), 2))/size(x,2), 2, 'gaussian', 25) ...
  smoothdata(squeeze(sum(x(:,:,52:end), 2))/size(x,2), 2, 'gaussian', 25)
];

dataColor = [162,20,47; 247,146,52; 31,154,207; 148,181,51] / 255;

%%
fileName = 'rat025_0923_'; M1num = 9;
% fileName = 'rat028_1030_'; M1num = 7;

for fold = 1:5
  rl = load(['old_results/' fileName, 'RL_', num2str(fold), '.mat']);
  cons = load(['old_results/' fileName, 'Cons_', num2str(fold), '.mat']);
  vae = load(['results/' fileName, 'RL_', num2str(fold), '.mat']);  
  vae_v2 = load(['results/' fileName, 'RL_oldHP_', num2str(fold), '.mat']);  
  allRasters = { 
    vae.testActions, vae.testM1_truth; 
    rl.testActions, rl.spkOutPredictTest
    cons.testActions, cons.spkOutPredictTest; 
    vae.testActions, vae.spkOutPredictTest;
    vae_v2.testActions, vae_v2.spkOutPredictTest;};
  
  for i=1:5
    [lR, hR] = getRaster(allRasters{i,1}, allRasters{i,2});
    modulation = getModulation(lR, hR);
    for n=1:M1num
      subplot(5,9,9*(i-1)+n)
      plot(modulation(n,:)); hold on
    end
  end
end

%%
for n=1:M1num
  for i=[1 3 5]
    figure(1)
    h = findobj(subplot(5,9,9*(i-1)+n),'Type','line');
    stdOverTime = std(cell2mat({h(:).YData}'));
%     stdOverTime(102:111) = 0;
    meanOverTime = mean(cell2mat({h(:).YData}'));

    figure(2)
    subplot(3,3,n)
    plotModulation(meanOverTime, stdOverTime, modelColor{i})
%     plot(meanOverTime, 'Color', modelColor{i}, 'LineWidth',1);
%     hold on
% %     fill([1:212 212:-1:1], [meanOverTime-stdOverTime, fliplr(meanOverTime+stdOverTime)], ...
% %       modelColor{i}, 'faceAlpha', 0.1, 'EdgeAlpha',0)
%     fill([1:length(meanOverTime) length(meanOverTime):-1:1], ...
%       [meanOverTime-stdOverTime, fliplr(meanOverTime+stdOverTime)], ...
%       modelColor{i}, 'faceAlpha', 0.1, 'EdgeAlpha',0)
  end
  hold off
  title(['M1 neuron ', num2str(n)])
end



%%
function modulation = getModulation(lR, hR)

rm = ( squeeze(sum(lR(:,:,1:51), 2)) + squeeze(sum(hR(:,:,1:51), 2)) ) / (size(lR, 2) + size(hR, 2));
rm = smoothdata(rm, 2, 'gaussian', 25);

lm = smoothdata(squeeze(sum(lR(:,:,52:end), 2))/size(lR,2), 2, 'gaussian', 25);
hm = smoothdata(squeeze(sum(hR(:,:,52:end), 2))/size(hR,2), 2, 'gaussian', 25);

% modulation = [rm nan(1,10) lm nan(1,10) hm];
modulation = [rm lm hm];
end

function plotModulation(meanOverTime, stdOverTime, color)

segment = [0 51 101 151];

for i=1:3
  dataIndex = (segment(i)+1):segment(i+1);
  plotIndex = dataIndex + 25*(i-1);
  
  plot(plotIndex, meanOverTime(dataIndex), 'Color', color, 'LineWidth',1);
  hold on
  fill([plotIndex fliplr(plotIndex)], ...
    [meanOverTime(dataIndex)-stdOverTime(dataIndex), ...
    fliplr(meanOverTime(dataIndex)+stdOverTime(dataIndex))], ...
    color, 'faceAlpha', 0.1, 'EdgeAlpha',0)
end

end


% %%
% [lR, hR] = getRaster(res.testActions, res.testM1_truth);
% [lRp, hRp] = getRaster(res.testActions, res.spkOutPredictTest);
% 
% [lR_, hR_] = getRaster(old.testActions, old.testM1_truth);
% [lRc, hRc] = getRaster(old.testActions, old.spkOutPredictTest);
% 
% 
% 
% %%
% startIndexForSubplots = [1 3 5 19 21 23 37 39 41];
% figure(1)
% for neuronIdx = 1:size(allRasters{1}, 1)
% 
% s{1} = subplot(9, 6, startIndexForSubplots(neuronIdx));
% s{2} = subplot(9, 6, [6 12]+startIndexForSubplots(neuronIdx));
% subplot(s{2})
% for i=1:3
%   plotRasterModulation(squeeze(allRasters{2*(i-1)+1}(neuronIdx,:,:)), ...
%     allMean{2*(i-1)+1}(neuronIdx,:), 0.96+0.02*i, modelColor(i,:), s)
% end
% subplot(s{1}); hold off;
% 
% s{1} = subplot(9, 6, 1+startIndexForSubplots(neuronIdx));
% s{2} = subplot(9, 6, 1+[6 12]+startIndexForSubplots(neuronIdx));
% subplot(s{2})
% for i=1:3
%   plotRasterModulation(squeeze(allRasters{2*i}(neuronIdx,:,:)), ...
%     allMean{2*i}(neuronIdx,:,:), 0.96+0.02*i, modelColor(i,:), s)
% end
% subplot(s{1}); hold off;
% 
% end
% 
% %%
% function plotRasterModulation(R, plot_R, base, color, axes)
% 
% subplot(axes{1})
% for i=1:12
%   x = (base+i*0.001);
%   plotSpikes(1:101, R(i,:), x, color, 1); hold on
% end
% % hold off
% box off
% set(gca, 'YColor', 'white')
% set(gca, 'XColor', 'white')
% set(gca, 'TickLength', [0 0])
% ylim([0.97 1.05])
% 
% subplot(axes{2})
% plot(-0.5:0.01:0, plot_R(1:51), 'Color', color, 'LineWidth',1); hold on
% plot(0.01:0.01:0.5, plot_R(52:end), 'Color', color, 'LineWidth',1)
% % hold off
% box off
% % set(gca, 'YColor', 'white')
% % set(gca, 'XColor', 'white')
% set(gca, 'TickLength', [0 0])
% % set(gca, 'YTickLabel',[])
% % set(gca, 'XTickLabel',[])
% set(gca, "TickLabelInterpreter", 'latex')
% end
