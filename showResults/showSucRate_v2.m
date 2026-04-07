clear; clc; close all;
addpath matlab_decoding/

%% 
DataNameList = ["data/rat008_1206.mat","data/rat009_0711.mat","data/rat010_0704.mat",...
                "data/rat011_0823.mat","data/rat025_0923.mat","data/rat028_1030.mat"];

Cons = load("results\successRate_Cons.mat");
baseline = load("results\successRate_baseline.mat");

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-50 0 44 22];

%% SL
[testSucRate_tVAE_SL, testTrialSucRate_tVAE_SL] = getSucRate(DataNameList, '_Sup_');

% testSucRate25 = [baseline.testSucRateSL(5,:); baseline.testSucRateRL(5,:); Cons.testSucRateCons(5,:); testSucRate_tVAE_SL(5,:)];
% testSucRate28 = [baseline.testSucRateSL(6,:); baseline.testSucRateRL(6,:); Cons.testSucRateCons(6,:); testSucRate_tVAE_SL(6,:)];
% testTrialSucRate25 = [baseline.testTrialSucRateSL(5,:); baseline.testTrialSucRateRL(5,:); Cons.testTrialSucRateCons(5,:); testTrialSucRate_tVAE_SL(5,:)];
% testTrialSucRate28 = [baseline.testTrialSucRateSL(6,:); baseline.testTrialSucRateRL(6,:); Cons.testTrialSucRateCons(6,:); testTrialSucRate_tVAE_SL(6,:)];

testSucRate25 = [baseline.testSucRateSL(5,:); testSucRate_tVAE_SL(5,:); baseline.testSucRateRL(5,:); Cons.testSucRateCons(5,:)];
testSucRate28 = [baseline.testSucRateSL(6,:); testSucRate_tVAE_SL(6,:); baseline.testSucRateRL(6,:); Cons.testSucRateCons(6,:)];
testTrialSucRate25 = [baseline.testTrialSucRateSL(5,:); testTrialSucRate_tVAE_SL(5,:); baseline.testTrialSucRateRL(5,:); Cons.testTrialSucRateCons(5,:)];
testTrialSucRate28 = [baseline.testTrialSucRateSL(6,:); testTrialSucRate_tVAE_SL(6,:); baseline.testTrialSucRateRL(6,:); Cons.testTrialSucRateCons(6,:)];

%% RL
[testSucRate_tVAE_RL, testTrialSucRate_tVAE_RL] = getSucRate(DataNameList, '_RL_oldHP_');

testSucRate25 = [testSucRate25; testSucRate_tVAE_RL(5,:)];
testSucRate28 = [testSucRate28; testSucRate_tVAE_RL(6,:)];
testTrialSucRate25 = [testTrialSucRate25; testTrialSucRate_tVAE_RL(5,:)];
testTrialSucRate28 = [testTrialSucRate28; testTrialSucRate_tVAE_RL(6,:)];

%%
subplot(221)
bar(1:5, mean(testSucRate25, 2), 'FaceAlpha',0.7, 'EdgeColor','flat', 'EdgeAlpha',0.7)
hold on
for i=1:5
  plot(i+[-0.2:0.1:0.2], testSucRate25(i,:), 'o', 'MarkerSize',5, ...
    'MarkerFaceColor','k', 'MarkerEdgeColor','k')
end
hold off
title('\bf{Success Rate}', ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
% xticklabels({'\bf{SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent SL}', '\bf{latent RL}'})
xticklabels({'\bf{SL}', '\bf{latent SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent RL}'})
set(gca, 'TickLabelInterpreter', 'latex')
ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;
ylabel("\textbf{Rat~A}", 'Interpreter','latex','FontSize',15)
text(-0.07, 1.08, "\bf{(a)}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

subplot(222)
bar(1:5, mean(testTrialSucRate25, 2), 'FaceAlpha',0.7, 'EdgeColor','flat', 'EdgeAlpha',0.7)
hold on
for i=1:5
  plot(i+[-0.2:0.1:0.2], testTrialSucRate25(i,:), 'o', 'MarkerSize',5, ...
    'MarkerFaceColor','k', 'MarkerEdgeColor','k')
end
hold off
title('\bf{Trial Success Rate}', ...
    'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
% xticklabels({'\bf{SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent SL}', '\bf{latent RL}'})
xticklabels({'\bf{SL}', '\bf{latent SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent RL}'})
set(gca, 'TickLabelInterpreter', 'latex')
ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;
text(-0.07, 1.08, "\bf{(b)}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

subplot(223)
bar(1:5, mean(testSucRate28, 2), 'FaceAlpha',0.7, 'EdgeColor','flat', 'EdgeAlpha',0.7)
hold on
for i=1:5
  plot(i+[-0.2:0.1:0.2], testSucRate28(i,:), 'o', 'MarkerSize',5, ...
    'MarkerFaceColor','k', 'MarkerEdgeColor','k')
end
hold off
xticks(1:5)
% xticklabels({'\bf{SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent SL}', '\bf{latent RL}'})
xticklabels({'\bf{SL}', '\bf{latent SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent RL}'})
set(gca, 'TickLabelInterpreter', 'latex')
ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;
ylabel("\textbf{Rat~B}", 'Interpreter','latex','FontSize',15)
text(-0.07, 1.08, "\bf{(c)}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

subplot(224)
bar(1:5, mean(testTrialSucRate28, 2), 'FaceAlpha',0.7, 'EdgeColor','flat', 'EdgeAlpha',0.7)
hold on
for i=1:5
  plot(i+[-0.2:0.1:0.2], testTrialSucRate28(i,:), 'o', 'MarkerSize',5, ...
    'MarkerFaceColor','k', 'MarkerEdgeColor','k')
end
hold off
% xticklabels({'\bf{SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent SL}', '\bf{latent RL}'})
xticklabels({'\bf{SL}', '\bf{latent SL}', '\bf{RL}', '\bf{Cons}', '\bf{latent RL}'})
set(gca, 'TickLabelInterpreter', 'latex')
ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;
ylim([0 1])
text(-0.07, 1.08, "\bf{(d)}", 'Interpreter','latex', ...
  'FontSize',15, 'Units','normalized')

%%
function [SucRate, TrialSucRate] = getSucRate(DataNameList, type)
SucRate = zeros(6, 5);
TrialSucRate = zeros(6, 5);
for dataIdx = 5:6

DataName = DataNameList(dataIdx);
resultPredix = convertStringsToChars(DataName); resultPredix = resultPredix(6:16);
data = data_setup(DataName); % load data
for i=1:5
    load(['results/',resultPredix,type,num2str(i),'.mat']);
    SucRate(dataIdx,i) = testSucRate;
    [success,testSucRate,~] = emulator(spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);
    trialNum = 0;
    successTrialNum = 0;
    for timeIdx=2:length(success)
        if testActions(timeIdx-1)==0 && testActions(timeIdx)==1
            start = timeIdx;
            continue
        elseif (timeIdx==length(success) && testActions(timeIdx)>1) || (testActions(timeIdx)>1 && testActions(timeIdx+1)==0)
            stop = timeIdx;
            trialNum = trialNum + 1;
            if sum(success(start:stop)==1)/(sum(success(start:stop)==0)+sum(success(start:stop)==1))>0.7
                successTrialNum = successTrialNum + 1;
            end
        else
            continue
        end
    end

    if trialNum~=opt.NumberOfTestTrials
        warning(['trialNum wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    if SucRate(dataIdx,i)~=testSucRate
        warning(['testSucRate wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    TrialSucRate(dataIdx, i) = successTrialNum/trialNum;
end

end

end