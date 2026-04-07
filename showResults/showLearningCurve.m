clear; clc; close all
addpath plotUtils\

modelColor = {'k', 'r', 'g', 'b'};

for fileName = ["rat025_0923_", "rat028_1030_"]
  rlTrain = zeros(5, 5e3);
  consTrain = zeros(5, 5e3);
  consTest = zeros(5, 5e3);
  vaeTrain = zeros(5, 1e3);
  vaeTest = zeros(5, 1e3);
  vae_v2Train = zeros(5, 5e3);
  vae_v2Test = zeros(5, 5e3);
  for fold = 1:5
    rl = load(['old_results/' char(fileName), 'RL_', num2str(fold), '.mat'], 'rewardHis');
    rlTrain(fold,:) = rl.rewardHis;
  
    cons = load(['old_results/' char(fileName), 'Cons_', num2str(fold), '.mat'], 'rewardHis', 'rewardTestHis');
    consTrain(fold,:) = cons.rewardHis;
    consTest(fold,:) = cons.rewardTestHis;
  
    vae = load(['results/' char(fileName), 'RL_', num2str(fold), '.mat'], 'rewardHis', 'rewardTestHis');  
    vaeTrain(fold,:) = vae.rewardHis;
    vaeTest(fold,:) = vae.rewardTestHis;

    vae_v2 = load(['results/' char(fileName), 'RL_oldHP_', num2str(fold), '.mat'], 'rewardHis', 'rewardTestHis');  
    vae_v2Train(fold,:) = vae_v2.rewardHis;
    vae_v2Test(fold,:) = vae_v2.rewardTestHis;

  end

  figure()
  subplot(211)
  plot_mean_learning_curve(rlTrain, 'r')
  plot_mean_learning_curve(consTrain, 'g')
  plot_mean_learning_curve(vae_v2Train, 'm')
%   plot_mean_learning_curve(vaeTrain, 'b')
  hold off
  temp = char(fileName);
  title(temp(1:6))
%   xlim([1 1000])

  subplot(212)
%   plot_mean_learning_curve(rlTrain, 'r')
  plot_mean_learning_curve(consTest, 'g')
  plot_mean_learning_curve(vae_v2Test, 'm')
%   plot_mean_learning_curve(vaeTest, 'b')
  hold off
%   xlim([1 1000])
end

%%
function plot_mean_learning_curve(learning_curve, color)

plot(movmean(mean(learning_curve), 5), 'Color', color, 'LineWidth',1)
hold on
fill([1:length(learning_curve) fliplr(1:length(learning_curve))], ...
  [movmean(mean(learning_curve), 5) - movmean(std(learning_curve), 5), ...
  fliplr(movmean(mean(learning_curve), 5) + movmean(std(learning_curve), 5))], ...
  color, 'FaceAlpha',0.3, 'EdgeColor','none')

end
