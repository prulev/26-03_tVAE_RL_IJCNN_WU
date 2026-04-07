clear; clc; close all
addpath plotUtils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-30 3 30 12];

dataColor = {'k', 'g', 'b'};
foldColor = [0.3 0.3 0.3; 0.1 0.1 0.7; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880; 1, 0, 1];
actionsColor = [0 0 0; 0 0 0; 0 0 0];

getPlotModulation = @(x) [
  smoothdata(squeeze(sum(x(:,:,1:51), 2))/size(x,2), 2, 'gaussian', 25) ...
  smoothdata(squeeze(sum(x(:,:,52:end), 2))/size(x,2), 2, 'gaussian', 25)
];

%%
fileName = 'rat025_0923_';
neuronIdx = 4;
for fold = 1:5
%   rl = load(['old_results/' fileName, 'RL_', num2str(fold), '.mat']);
  cons = load(['old_results/' fileName, 'Cons_', num2str(fold), '.mat']);
%   vae = load(['results/' fileName, 'RL_', num2str(fold), '.mat']);  
  vae = load(['results/' fileName, 'RL_oldHP_', num2str(fold), '.mat']);  
  allRasters = { 
    vae.testActions, vae.testM1_truth; 
%     rl.testActions, rl.spkOutPredictTest
    cons.testActions, cons.spkOutPredictTest; 
%     vae.testActions, vae.spkOutPredictTest;
    vae.testActions, vae.spkOutPredictTest;};

  for i=1:3
    [lR, hR] = getRaster(allRasters{i,1}, allRasters{i,2});
    plot_lR = getPlotModulation(lR); plot_hR = getPlotModulation(hR);
    sl{1} = subplot(4,14,5*(i-1)+[1 2]); sl{2} = subplot(4,14,5*(i-1)+[1 2]+14);
    plotRasterModulation(squeeze(lR(neuronIdx,:,:)), squeeze(plot_lR(neuronIdx,:,:)), 0.016*(6-fold), foldColor(fold,:), sl)
    subplot(sl{1})
    text(-20, 0.1, char('a'+i-1), 'FontWeight','bold','FontSize',10,'EdgeColor','none')
    sr{1} = subplot(4,14,5*(i-1)+[3 4]); sr{2} = subplot(4,14,5*(i-1)+[3 4]+14);
    plotRasterModulation(squeeze(hR(neuronIdx,:,:)), squeeze(plot_hR(neuronIdx,:,:)), 0.016*(6-fold), foldColor(fold,:), sr)
  end
end

%%
for i=1:3

figure(1)
h = findobj(subplot(4,14,5*(i-1)+[1 2]+14),'Type','line');
stdOverTime = std(cell2mat({h(:).YData}'));
meanOverTime = mean(cell2mat({h(:).YData}'));
sl{2} = subplot(4,14,5*(i-1)+[1 2]+14);
hold off
% fill([-0.5:0.01:0.5, fliplr(-0.5:0.01:0.5)], [meanOverTime-stdOverTime, fliplr(meanOverTime+stdOverTime)] ...
%   , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
fill([-0.5:0.01:0, fliplr(-0.5:0.01:0)], [meanOverTime(1:51)-stdOverTime(1:51), fliplr(meanOverTime(1:51)+stdOverTime(1:51))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
hold on
fill([0.1+(0.01:0.01:0.5), fliplr(0.1+(0.01:0.01:0.5))], [meanOverTime(52:end)-stdOverTime(52:end), fliplr(meanOverTime(52:end)+stdOverTime(52:end))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
plot(-0.5:0.01:0, meanOverTime(1:51), 'Color',dataColor{i}, 'LineWidth',1.5)
plot(0.1+(0.01:0.01:0.5), meanOverTime(52:end), 'Color',dataColor{i}, 'LineWidth',1.5)
plot([0 0.1], meanOverTime(51:52), 'Color',dataColor{i}, 'LineWidth',1.5, 'LineStyle',':')
hold off
box off
set(gca, 'TickLength', [0 0])
set(gca, "TickLabelInterpreter", 'latex')
% figure(2)
% subplot(4,14,5*(i-1)+[1 2]+14)
% plot(-0.5:0.01:0.5, stdOverTime)

figure(1)
h = findobj(subplot(4,14,5*(i-1)+[3 4]+14),'Type','line');
stdOverTime = std(cell2mat({h(:).YData}'));
meanOverTime = mean(cell2mat({h(:).YData}'));
sr{2} = subplot(4,14,5*(i-1)+[3 4]+14);
hold off
% fill([-0.5:0.01:0.5, fliplr(-0.5:0.01:0.5)], [meanOverTime-stdOverTime, fliplr(meanOverTime+stdOverTime)] ...
%   , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
fill([-0.5:0.01:0, fliplr(-0.5:0.01:0)], [meanOverTime(1:51)-stdOverTime(1:51), fliplr(meanOverTime(1:51)+stdOverTime(1:51))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
hold on
fill([0.1+(0.01:0.01:0.5), fliplr(0.1+(0.01:0.01:0.5))], [meanOverTime(52:end)-stdOverTime(52:end), fliplr(meanOverTime(52:end)+stdOverTime(52:end))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
plot(-0.5:0.01:0, meanOverTime(1:51), 'Color',dataColor{i}, 'LineWidth',1.5)
plot(0.1+(0.01:0.01:0.5), meanOverTime(52:end), 'Color',dataColor{i}, 'LineWidth',1.5)
plot([0 0.1], meanOverTime(51:52), 'Color',dataColor{i}, 'LineWidth',1.5, 'LineStyle',':')
% hold on
% plot(-0.5:0.01:0.5, meanOverTime, 'Color',dataColor{i}, 'LineWidth',1.5)
box off
set(gca, 'TickLength', [0 0])
set(gca, "TickLabelInterpreter", 'latex')

subplot(sl{2}); ylim([0.1 0.42]); yll = ylim();
subplot(sr{2}); ylim([0.1 0.42]); ylr = ylim();

yl = [0 max(yll(2), ylr(2))];
subplot(sl{2}); ylim(yl);
hold on
% area([0 0.11], [yl(2) yl(2)], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor','none')
% line([0 0], yl, 'Color', 'k', 'lineWidth', 0.1)
% line([0.11 0.11], yl, 'Color', 'k', 'lineWidth', 0.1)
subplot(sr{2}); ylim(yl);
hold on
% area([0 0.11], [yl(2) yl(2)], 'FaceColor', [0.9 0.9 0.9], 'EdgeColor','none')
% line([0 0], yl, 'Color', 'k', 'lineWidth', 0.1)
% line([0.11 0.11], yl, 'Color', 'k', 'lineWidth', 0.1)

subplot(sl{2});
set(gca, 'TickLength', [0 0])
% set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])

if i==1
  hold on
  line([-0.5 -0.3], [0.3 0.3], 'LineWidth', 1.5, 'Color', 'k')
  text(-0.45, 0.36, '200 ms', 'Interpreter', 'latex', 'FontSize', 8)
  hold off
  text(0.05,1.3*yl(1)-yl(2)*0.3,{'(Low Trials)'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(1,:))
  text(-0.25,1.12*yl(1)-yl(2)*0.12,{'Rest'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(1,:))
  text(0.35,1.12*yl(1)-yl(2)*0.12,{'Press'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(2,:))
end

subplot(sr{2});
set(gca, 'TickLength', [0 0])
set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])
if i==1
  text(-0.25,1.12*yl(1)-yl(2)*0.12,{'Rest'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(1,:))
  text(0.35,1.12*yl(1)-yl(2)*0.12,{'Press'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(3,:))
  text(0.05,1.3*yl(1)-yl(2)*0.3,{'(High trials)'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(3,:))
end

end

for i=1:3

s{1} = subplot(4,14,5*(i-1)+[1 2]); 
s{2} = subplot(4,14,5*(i-1)+[1 2]+14);

s{3} = subplot(4,14,5*(i-1)+[3 4]); 
s{4} = subplot(4,14,5*(i-1)+[3 4]+14);

for j=[2 4]
pos = s{j}.Position;
pos(2) = pos(2)+0.05;
s{j}.Position = pos;
end

for j=1:4
pos = s{j}.Position;
pos(2) = pos(2)-0.06;
s{j}.Position = pos;
end

if i==1
  subplot(s{1})
  text(-52, 0.114, '\bf Rat A Neuron 4', 'Interpreter','latex', 'FontSize',12, HorizontalAlignment='left')
end

end

%%
fileName = 'rat028_1030_';
neuronIdx = 6;
figure(1)
for fold = 1:5

%   rl = load(['old_results/' fileName, 'RL_', num2str(fold), '.mat']);
  cons = load(['old_results/' fileName, 'Cons_', num2str(fold), '.mat']);
%   vae = load(['results/' fileName, 'RL_', num2str(fold), '.mat']);  
  vae = load(['results/' fileName, 'RL_oldHP_', num2str(fold), '.mat']);  
  allRasters = { 
    vae.testActions, vae.testM1_truth; 
%     rl.testActions, rl.spkOutPredictTest
    cons.testActions, cons.spkOutPredictTest; 
%     vae.testActions, vae.spkOutPredictTest;
    vae.testActions, vae.spkOutPredictTest;};

for i=1:3
[lR, hR] = getRaster(allRasters{i,1}, allRasters{i,2});
plot_lR = getPlotModulation(lR); plot_hR = getPlotModulation(hR);
% s{1} = subplot(3,4,4*(i-1)+3); s{2} = subplot(3,4,4*(i-1)+1);
sl{1} = subplot(4,14,5*(i-1)+[1 2]+28); sl{2} = subplot(4,14,5*(i-1)+[1 2]+42);
plotRasterModulation(squeeze(lR(neuronIdx,:,:)), squeeze(plot_lR(neuronIdx,:,:)), 0.016*(6-fold), foldColor(fold,:), sl)
subplot(sl{1})
text(-20, 0.1, char('d'+i-1), 'FontWeight','bold','FontSize',10,'EdgeColor','none')
% s{1} = subplot(3,4,4*(i-1)+4); s{2} = subplot(3,4,4*(i-1)+2);
sr{1} = subplot(4,14,5*(i-1)+[3 4]+28); sr{2} = subplot(4,14,5*(i-1)+[3 4]+42);
plotRasterModulation(squeeze(hR(neuronIdx,:,:)), squeeze(plot_hR(neuronIdx,:,:)), 0.016*(6-fold), foldColor(fold,:), sr)

end

end

for i=1:3

figure(1)
h = findobj(subplot(4,14,5*(i-1)+[1 2]+42),'Type','line');
stdOverTime = std(cell2mat({h(:).YData}'));
meanOverTime = mean(cell2mat({h(:).YData}'));
sl{2} = subplot(4,14,5*(i-1)+[1 2]+42);
hold off
% fill([-0.5:0.01:0.5, fliplr(-0.5:0.01:0.5)], [meanOverTime-stdOverTime, fliplr(meanOverTime+stdOverTime)] ...
%   , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0);
fill([-0.5:0.01:0, fliplr(-0.5:0.01:0)], [meanOverTime(1:51)-stdOverTime(1:51), fliplr(meanOverTime(1:51)+stdOverTime(1:51))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
hold on
fill([0.1+(0.01:0.01:0.5), fliplr(0.1+(0.01:0.01:0.5))], [meanOverTime(52:end)-stdOverTime(52:end), fliplr(meanOverTime(52:end)+stdOverTime(52:end))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
plot(-0.5:0.01:0, meanOverTime(1:51), 'Color',dataColor{i}, 'LineWidth',1.5)
plot(0.1+(0.01:0.01:0.5), meanOverTime(52:end), 'Color',dataColor{i}, 'LineWidth',1.5)
plot([0 0.1], meanOverTime(51:52), 'Color',dataColor{i}, 'LineWidth',1.5, 'LineStyle',':')
% hold on
% plot(-0.5:0.01:0.5, meanOverTime, 'Color',dataColor{i}, 'LineWidth',1.5)
box off
set(gca, 'TickLength', [0 0])
set(gca, "TickLabelInterpreter", 'latex')

figure(1)
h = findobj(subplot(4,14,5*(i-1)+[3 4]+42),'Type','line');
stdOverTime = std(cell2mat({h(:).YData}'));
meanOverTime = mean(cell2mat({h(:).YData}'));
sr{2} = subplot(4,14,5*(i-1)+[3 4]+42);
hold off
% fill([-0.5:0.01:0.5, fliplr(-0.5:0.01:0.5)], [meanOverTime-stdOverTime, fliplr(meanOverTime+stdOverTime)] ...
%   , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0);
fill([-0.5:0.01:0, fliplr(-0.5:0.01:0)], [meanOverTime(1:51)-stdOverTime(1:51), fliplr(meanOverTime(1:51)+stdOverTime(1:51))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
hold on
fill([0.1+(0.01:0.01:0.5), fliplr(0.1+(0.01:0.01:0.5))], [meanOverTime(52:end)-stdOverTime(52:end), fliplr(meanOverTime(52:end)+stdOverTime(52:end))] ...
  , dataColor{i}, 'FaceAlpha',0.3, 'EdgeAlpha',0)
plot(-0.5:0.01:0, meanOverTime(1:51), 'Color',dataColor{i}, 'LineWidth',1.5)
plot(0.1+(0.01:0.01:0.5), meanOverTime(52:end), 'Color',dataColor{i}, 'LineWidth',1.5)
plot([0 0.1], meanOverTime(51:52), 'Color',dataColor{i}, 'LineWidth',1.5, 'LineStyle',':')
% hold on
% plot(-0.5:0.01:0.5, meanOverTime, 'Color',dataColor{i}, 'LineWidth',1.5)
box off
set(gca, 'TickLength', [0 0])
set(gca, "TickLabelInterpreter", 'latex')

subplot(sl{2}); ylim([0.2 0.45]);
subplot(sr{2}); ylim([0.2 0.45]);

yl = ylim();
% subplot(sl{2}); ylim(yl);
% line([0 0], yl, 'Color', 'k')
% line([0.1 0.1], yl, 'Color', 'k')
% subplot(sr{2}); ylim(yl);
% line([0 0], yl, 'Color', 'k')
% line([0.1 0.1], yl, 'Color', 'k')

subplot(sl{2});
set(gca, 'TickLength', [0 0])
% set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])
if i==1
  text(0.05,1.3*yl(1)-yl(2)*0.3,{'(Low Trials)'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(1,:))
  text(-0.25,1.12*yl(1)-yl(2)*0.12,{'Rest'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(1,:))
  text(0.35,1.12*yl(1)-yl(2)*0.12,{'Press'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(2,:))
end

subplot(sr{2});
set(gca, 'TickLength', [0 0])
set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])
if i==1
  text(-0.25,1.12*yl(1)-yl(2)*0.12,{'Rest'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(1,:))
  text(0.35,1.12*yl(1)-yl(2)*0.12,{'Press'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(3,:))
  text(0.05,1.3*yl(1)-yl(2)*0.3,{'(High trials)'}, 'HorizontalAlignment','center', 'Interpreter','latex', 'FontSize',10, 'Color',actionsColor(3,:))
end

end

for i=1:3

s{1} = subplot(4,14,5*(i-1)+[1 2]+28); s{2} = subplot(4,14,5*(i-1)+[1 2]+42);
s{3} = subplot(4,14,5*(i-1)+[3 4]+28); s{4} = subplot(4,14,5*(i-1)+[3 4]+42);

for j=[1 3]
pos = s{j}.Position;
pos(2) = pos(2)-0.05;
s{j}.Position = pos;
end

for j=1:4
pos = s{j}.Position;
pos(2) = pos(2)-0.04;
s{j}.Position = pos;
end

if i==1
  subplot(s{1})
  text(-52, 0.114, '\bf Rat B Neuron 6', 'Interpreter','latex', 'FontSize',12, HorizontalAlignment='left')
end

end

%%
subplot('Position', [0.57 0.95 0.3 0.05])
for fold=1:5
  plot(fold*20 - (1:5), ones(1,5), '|', 'Color',foldColor(fold,:), 'MarkerSize',8); hold on
  plot(fold*20+0.1 - (1:5), ones(1,5), '|', 'Color',foldColor(fold,:), 'MarkerSize',8);
  plot(fold*20-0.1 - (1:5), ones(1,5), '|', 'Color',foldColor(fold,:), 'MarkerSize',8);
  text(fold*20+1, 0.98, ['Fold ', num2str(fold)], 'interpreter', 'latex', ...
    'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize', 10)
end
hold off
% xlim([0 0])
box off
set(gca, 'YColor', 'white')
set(gca, 'XColor', 'white')
set(gca, 'TickLength', [0 0])
set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])

%% create legend
subplot('Position', [0.5 0.89 0.37 0.05])
x{1} = 25-(2:2:10); 
x{2} = 56-(2:2:10); 
x{3} = 90-(2:2:10); 
lgd = {'Real recordings', 'RL w cons', 'RL w dynamic'};

for i=1:3
  fill([x{i}, fliplr(x{i})], [ones(1,5), 2*ones(1,5)], dataColor{i}, ...
    'FaceAlpha',0.3, 'EdgeAlpha',0); 
  hold on
  plot(x{i}, 1.5*ones(1,5), 'Color',dataColor{i}, 'LineWidth', 1.5)
  text(x{i}(1)+1, 1.48, lgd{i}, 'interpreter', 'latex', ...
    'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize', 10)
end
xlim([10 100])
box off
set(gca, 'YColor', 'white')
set(gca, 'XColor', 'white')
set(gca, 'TickLength', [0 0])
set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])

%%
function plotRasterModulation(R, plot_R, base, color, axes)

subplot(axes{1})
for i=1:12
  x = (base+i*0.001);
  plotSpikes(1:51, R(i,1:51), x, color, 0.8); hold on
  plotSpikes(62:111, R(i,52:end), x, color, 0.8);
end
% hold off
box off
set(gca, 'YColor', 'white')
set(gca, 'XColor', 'white')
set(gca, 'TickLength', [0 0])
set(gca, 'YTickLabel',[])
set(gca, 'XTickLabel',[])
ylim([0.02 0.1])

subplot(axes{2})
plot(-0.5:0.01:0.5, plot_R, 'Color', color, 'LineWidth',1); 
hold on
% hold off
box off
% set(gca, 'YColor', 'white')
% set(gca, 'XColor', 'white')
set(gca, 'TickLength', [0 0])
% set(gca, 'YTickLabel',[])
% set(gca, 'XTickLabel',[])
set(gca, "TickLabelInterpreter", 'latex')
end

%%
% function modulation = getModulation(lR, hR)
% 
% rm = ( squeeze(sum(lR(:,:,1:51), 2)) + squeeze(sum(hR(:,:,1:51), 2)) ) / (size(lR, 2) + size(hR, 2));
% rm = smoothdata(rm, 2, 'gaussian', 25);
% 
% lm = smoothdata(squeeze(sum(lR(:,:,52:end), 2))/size(lR,2), 2, 'gaussian', 25);
% hm = smoothdata(squeeze(sum(hR(:,:,52:end), 2))/size(hR,2), 2, 'gaussian', 25);
% 
% % modulation = [rm nan(1,10) lm nan(1,10) hm];
% modulation = [rm lm hm];
% end
% 
% function plotModulation(meanOverTime, stdOverTime, color)
% 
% segment = [0 51 101 151];
% 
% for i=1:3
%   dataIndex = (segment(i)+1):segment(i+1);
%   plotIndex = dataIndex + 25*(i-1);
%   
%   plot(plotIndex, meanOverTime(dataIndex), 'Color', color, 'LineWidth',1);
%   hold on
%   fill([plotIndex fliplr(plotIndex)], ...
%     [meanOverTime(dataIndex)-stdOverTime(dataIndex), ...
%     fliplr(meanOverTime(dataIndex)+stdOverTime(dataIndex))], ...
%     color, 'faceAlpha', 0.1, 'EdgeAlpha',0)
% end
% 
% end
