% 用来确认tVAE用到的dataset和以前一致： 检查通过
clear; close all; clc

% RLPP = load("baseline_results\rat025_0923_RL_3.mat");
% Cons = load("baseline_results\rat025_0923_Cons_3.mat");
% tVAE = load('data\extended_trial_data_025.mat');
% test_fold = 3;

RLPP = load("baseline_results\rat028_1030_RL_4.mat");
Cons = load("baseline_results\rat028_1030_Cons_4.mat");
tVAE = load('data\extended_trial_data_028.mat');
test_fold = 4;

%% check test trials
norm(RLPP.opt.testTrials-Cons.opt.testTrials)
norm(RLPP.opt.testTrials-tVAE.folds{test_fold})

%% compare test trail activities
% find test set indexes
timeIndexes = cell2mat(arrayfun(@(x) find(tVAE.trial_No==x), tVAE.folds{test_fold}, 'UniformOutput', false));
% unique is kind of sort (in baseline Dataloader, we include history, which may introduce overlap; here no overlap)
timeIndexes = unique(timeIndexes);
% only plot time indexes with movement labels (1 2 3) for simplicity 
tVAE_M1 = tVAE.M1_select(:,timeIndexes);
tVAE_actions = tVAE.movements(timeIndexes);
tVAE_plot_index = find(tVAE_actions>0);
for i=1:size(tVAE_M1, 1)
  subplot(3,3,i)
  plot(gaussianSmooth(RLPP.testhM1_truth(i, RLPP.testActions(1:4e3)>0), 10), 'k')
  hold on
  plot(gaussianSmooth(Cons.testM1_truth(i, Cons.testActions(1:4e3)>0), 10), 'r')
  plot(gaussianSmooth(tVAE_M1(i, tVAE_plot_index(1:sum(Cons.testActions(1:4e3)>0))), 10), 'b')

  hold off
end

% 结论是能对上
