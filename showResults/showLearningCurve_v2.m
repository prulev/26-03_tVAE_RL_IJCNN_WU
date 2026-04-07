clear; clc; close all
addpath plotUtils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-30 3 25 13];

%%
i = 0;
for fileName = ["rat025_0923_", "rat028_1030_"]
  i = i+1;
  rlTrain = zeros(5, 5e3);
  consTrain = zeros(5, 5e3);
%   consTest = zeros(5, 5e3);
  vaeTrain = zeros(5, 5e3);
%   vaeTest = zeros(5, 1e3);
%   vae_v2Train = zeros(5, 5e3);
%   vae_v2Test = zeros(5, 5e3);
  for fold = 1:5
    rl = load(['old_results/' char(fileName), 'RL_', num2str(fold), '.mat'], 'rewardHis');
    rlTrain(fold,:) = rl.rewardHis;
  
    cons = load(['old_results/' char(fileName), 'Cons_', num2str(fold), '.mat'], 'rewardHis', 'rewardTestHis');
    consTrain(fold,:) = cons.rewardHis;
%     consTest(fold,:) = cons.rewardTestHis;
  
%     vae = load(['results/' char(fileName), 'RL_', num2str(fold), '.mat'], 'rewardHis', 'rewardTestHis');  
%     vaeTrain(fold,:) = vae.rewardHis;
%     vaeTest(fold,:) = vae.rewardTestHis;

    vae = load(['results/' char(fileName), 'RL_oldHP_', num2str(fold), '.mat'], 'rewardHis', 'rewardTestHis');  
    vaeTrain(fold,:) = vae.rewardHis;
%     vae_v2Test(fold,:) = vae_v2.rewardTestHis;

  end

  subplot(2,1,i)
  plot_mean_learning_curve(rlTrain, 'r')
  plot_mean_learning_curve(consTrain, 'g')
  plot_mean_learning_curve(vaeTrain, 'b')
  hold off
  temp = char(fileName);
  title(['\bf{Rat ' char('A'-1+i) '}'], ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')

  ylim([0 1])
  ylabel("\bf{batch success rate}", 'Interpreter','latex', 'FontSize',14)
  if i==2
    xlabel("\bf{Iteration}", 'Interpreter','latex', 'FontSize',14)
  end

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;


end

%%
subplot(211)
hold on;
x = [3700 4000]; 
dataColor = {'r', 'g', 'b'};
lgd = {'\bf{RL w/o cons}', '\bf{RL w cons}', '\bf{RL w dynamic}'};

for i=1:3
  fill([x, fliplr(x)], 0.15+[0.4 0.4 0.5 0.5]-i*0.13, dataColor{i}, ...
    'FaceAlpha',0.3, 'EdgeAlpha', 0); 
  plot(x, 0.15+(0.45-i*0.13)*[1 1], 'Color',dataColor{i}, 'LineWidth', 1.5)
  text(4080, 0.15+0.45-i*0.13, lgd{i}, 'interpreter', 'latex', ...
    'HorizontalAlignment','left', 'VerticalAlignment','middle', 'FontSize', 10)
end
hold off

%%
function plot_mean_learning_curve(learning_curve, color)

plot(movmean(mean(learning_curve), 10), 'Color', color, 'LineWidth',2)
hold on
fill([1:length(learning_curve) fliplr(1:length(learning_curve))], ...
  [movmean(mean(learning_curve), 10) - movmean(std(learning_curve), 10), ...
  fliplr(movmean(mean(learning_curve), 10) + movmean(std(learning_curve), 10))], ...
  color, 'FaceAlpha',0.3, 'EdgeColor','none')

end
