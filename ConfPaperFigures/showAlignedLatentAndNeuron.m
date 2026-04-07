% 绘图：看latent factor align之后的trajectory, neural, movements
close all; clc; clear;
addpath utils\ plotUtils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-20 0 12 30];

actionsColor = [0 0.4470 0.7410; 0.9290 0.6940 0.1250; 0.6350 0.0780 0.1840];

%% calculate DBR
timeslot = 10;              % interval of time-bin
opt.sampleRate = 1000/timeslot; %s ampleRate
opt.DTCorrelation = 1;      % 1 for DTKS, 0 for prototyped KS
opt.KS_N = 10;              % number of repeated calculations

fileName = 'rat025_0923';

meanDBR = zeros(3, 5);
for test_fold=1:5

  [data, rl, cons, vae] = loadData(fileName, test_fold);
  
  [~, DBR] = DBR_avg_Calc(rl.pre', data.truth', opt);
  meanDBR(1, test_fold) = mean(DBR);
  
  [~, DBR] = DBR_avg_Calc(cons.pre', data.truth', opt);
  meanDBR(2, test_fold) = mean(DBR);
  
  [~, DBR] = DBR_avg_Calc(vae.pre', data.truth', opt);
  meanDBR(3, test_fold) = mean(DBR);

end

disp(['RL mean DBR: ', num2str(mean(meanDBR(1,:))) ' std : ', num2str(std(meanDBR(1,:)))])
disp(['Cons mean DBR: ', num2str(mean(meanDBR(2,:))) ' std : ', num2str(std(meanDBR(2,:)))])
disp(['VAE mean DBR: ', num2str(mean(meanDBR(3,:))) ' std : ', num2str(std(meanDBR(3,:)))])

%% load data
fileName = 'rat025_0923';
test_fold = 2;
region = 'M1';

[data, rl, cons, vae] = loadData(fileName, test_fold);
dataIndex = findBestTrials(data, vae, [4 6]);
dataIndex = dataIndex(1:2000);
plotIndex = 0.01:0.01:20;
bestStart = 0;
% bestStart = findBestFit(data, vae, [4 6]);
% plotIndex = bestStart + (1:2000);

%% show latent
i= 1;
subplot('Position', [0.1300    0.83    0.7750    0.117]);
plot1Latent(plotIndex, dataIndex, vae, i)
ylim([-5 5])

% xlabel("\bf{time (sec)}", 'Interpreter','latex', 'FontSize',12)
ylabel("\bf{latent}", 'Interpreter','latex', 'FontSize',12)

% title(['\textbf{Rat~A~M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',10, 'FontWeight','bold')
title(['\textbf{M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',12, 'FontWeight','bold')

legend(["M1 Latent dynamics", "", "Aligned by RL"], ...
  'AutoUpdate','off', 'Box','on', 'Interpreter','latex', 'FontSize',10, ...
  'Orientation','horizontal', ...
  'Position',[0.26 0.97 0.65 0.017]);
text(-0.085, 1.05, "\textbf{(a)}", 'Interpreter','latex', ...
  'FontSize',12, 'Units','normalized', 'HorizontalAlignment','right')


i = 4;
subplot('Position', [0.1300    0.68    0.7750    0.117]);
plot1Latent(plotIndex, dataIndex, vae, i)
ylim([-3 2])

% xlabel("\bf{time (sec)}", 'Interpreter','latex', 'FontSize',12)
ylabel("\bf{latent}", 'Interpreter','latex', 'FontSize',12)

% title(['\textbf{Rat~A~M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',10, 'FontWeight','bold')
title(['\textbf{M1~latent~dimension~' num2str(i) '}'], 'Interpreter','latex', 'FontSize',12, 'FontWeight','bold')

% legend(["M1 Latent dynamics", "", "Aligned by RL"], ...
%   'AutoUpdate','off', 'Box','on', 'Interpreter','latex', 'FontSize',10, ...
%   'Orientation','horizontal', ...
%   'Position',[0.26 0.97 0.65 0.02]);
text(-0.085, 1.05, "\textbf{(b)}", 'Interpreter','latex', ...
  'FontSize',12, 'Units','normalized', 'HorizontalAlignment','right')

%% show Neuron
plotNeuron = 4;
subplot('Position', [0.1300    0.42    0.7750    0.117]);
show1neuron(data, rl, cons, vae, plotNeuron, plotIndex, dataIndex)
% title(['\textbf{Rat A ' region ' Neuron ', num2str(plotNeuron), '}'], ...
%   'Interpreter','latex', 'FontSize',10, 'FontWeight','bold')
t = title(['\textbf{' region ' Neuron ', num2str(plotNeuron), '}'], ...
  'Interpreter','latex', 'FontSize',12, 'FontWeight','bold');
legend({'Recordings', 'Vanilla RL', 'RL (Spat. Cons.)', 'RL (tVAE)'}, ...
  'Interpreter','latex', 'Orientation','horizontal', 'FontSize',10, ...
  'Position',[0.32 0.61 0.6 0.032], 'NumColumns',2)
ylabel("\bf{firing probabilities}", 'Interpreter','latex', 'FontSize',12)
text(-0.085, 1.5, "\textbf{(c)}", 'Interpreter','latex', ...
  'FontSize',12, 'Units','normalized', 'HorizontalAlignment','right')
t.Position(2) = 1.4;

axes('Position', [0.1320    0.535    0.7750    0.05])
show1neuronSpikes(data, rl, cons, vae, plotNeuron, plotIndex, dataIndex)

%%
plotNeuron = 6;
subplot('Position', [0.13    0.22    0.7750    0.117]);
show1neuron(data, rl, cons, vae, plotNeuron, plotIndex, dataIndex)
% title(['\textbf{Rat A ' region ' Neuron ', num2str(plotNeuron), '}'], ...
%   'Interpreter','latex', 'FontSize',10, 'FontWeight','bold')
t = title(['\textbf{' region ' Neuron ', num2str(plotNeuron), '}'], ...
  'Interpreter','latex', 'FontSize',12, 'FontWeight','bold');
% legend({'Recordings', 'Vanilla RL', 'RL (Spat. Cons.)', 'RL (tVAE)'}, ...
%   'Interpreter','latex', 'Orientation','horizontal', 'FontSize',9, ...
%   'Position',[0.32 0.69 0.6 0.04], 'NumColumns',2)
ylabel("\bf{firing probabilities}", 'Interpreter','latex', 'FontSize',12)
text(-0.085, 1.5, "\textbf{(d)}", 'Interpreter','latex', ...
  'FontSize',12, 'Units','normalized', 'HorizontalAlignment','right')
t.Position(2) = 1.4;

axes('Position', [0.1320    0.335    0.7750    0.05])
show1neuronSpikes(data, rl, cons, vae, plotNeuron, plotIndex, dataIndex)

xl = xlim();

%% show Movements
% s = subplot(423);
subplot('Position', [0.13    0.05    0.7750    0.1]);
plotActionsWithPos(plotIndex, data.movements(dataIndex), actionsColor, xl, 4)
text(bestStart/100+0.5, 4.6, "Correct movements", 'Interpreter','latex', ...
  'FontSize',10, 'Units','data', 'HorizontalAlignment','left')
ylim([0.5 4.5])

hold on
movements = rl.movements;
movements(data.movements==0) = 0;
plotActionsWithPos(plotIndex, movements(dataIndex), actionsColor, xl, 2.6)
text(bestStart/100+0.5, 3.2, "Vanilla RL", 'Interpreter','latex', ...
  'FontSize',10, 'Units','data', 'HorizontalAlignment','left')
ylim([0.5 4.5])

hold on
movements = cons.movements;
movements(data.movements==0) = 0;
plotActionsWithPos(plotIndex, movements(dataIndex), actionsColor, xl, 1.2)
text(bestStart/100+0.5, 1.8, "RL (Spat. Cons.)", 'Interpreter','latex', ...
  'FontSize',10, 'Units','data', 'HorizontalAlignment','left')
ylim([0.5 4.5])

hold on
movements = vae.movements;
movements(data.movements==0) = 0;
plotActionsWithPos(plotIndex, movements(dataIndex), actionsColor, xl, -0.2)
text(bestStart/100+0.5, 0.4, "RL (tVAE)", 'Interpreter','latex', ...
  'FontSize',10, 'Units','data', 'HorizontalAlignment','left')

text(bestStart/100-1.8, 2, "\bf{Movements}", 'Interpreter','latex', ...
  'FontSize',12, 'Units','data', 'HorizontalAlignment','center', 'Rotation',90)
% ylabel("\bf{Movements}", 'Interpreter','latex', 'FontSize',12)

ylim([-0.5 4.5])

leg = legend({'Rest', 'Press Low', 'Press High'}, ...
    'interpreter','latex','Orientation','horizontal', ...
    'Position',[0.35,0.165,0.55,0.022],'Box','on','FontSize',10);
leg.ItemTokenSize(1) = 15;

text(-0.085, 1.15, "\textbf{(e)}", 'Interpreter','latex', ...
  'FontSize',12, 'Units','normalized', 'HorizontalAlignment','right')

set(gca, 'LineWidth', 1.5); 
% ax.LineWidth = 1.5;

subplot('Position', [0.13    0.04    0.7750    0.01]);
plot(plotIndex, zeros(1,length(plotIndex)), 'k');
set(gca, 'YTickLabel', []); 
set(gca, 'YColor', 'none');
ylim([0,1])
box off
xlabel('Time (s)','FontSize',10,'units','normalized','interpreter','latex', 'Color','k');

ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.LineWidth = 1.5;
ax.TickLabelInterpreter = 'latex';

%%
function [data, rl, cons, vae] = loadData(fileName, test_fold)
temp = load(['old_results/' fileName, '_RL_', num2str(test_fold), '.mat']);
data.movements = temp.testActions;
data.truth_fr = get_truth_fr(temp.testhM1_truth');
data.truth = temp.testhM1_truth';
dataLength = length(data.movements);

rl.pre       = temp.pOutputTest';
rl.spk       = temp.spkOutPredictTest';
rl.movements = temp.motor_perform_test;

temp = load(['old_results/' fileName, '_Cons_', num2str(test_fold), '.mat']);
cons.pre       = temp.pOutputTest';
cons.spk       = temp.spkOutPredictTest';
cons.movements = temp.motor_perform_test;

if norm(data.movements - temp.testActions)~=0 || norm(data.truth - temp.testM1_truth')~=0
  error('Not the same data')
end

temp = load(['results/' fileName, '_RL_oldHP_', num2str(test_fold), '.mat']);  
vae.pre       = temp.pOutputTest(:,1:dataLength)';
vae.spk       = temp.spkOutPredictTest(:,1:dataLength)';
vae.movements = temp.motor_perform_test(1:dataLength);
vae.latent_mu = temp.M1_latent_test(:,1:dataLength);
vae.latent_std = temp.M1_latent_std_test(:,1:dataLength);
vae.latent_pre = temp.M1_latent_pre_test(:,1:dataLength);

if norm(data.movements - temp.testActions(1:dataLength))~=0 || ...
    norm(data.truth - temp.testM1_truth(:,1:dataLength)')~=0
  error('Not the same data')
end

end


function bestStart = findBestFit(data, model_data, neuronIdx)

maxMetric = -Inf;
bestStart = 1;
for start = 0:500:(length(data.truth_fr)-2200)

%   movements = data.movements(start + (1:2000));
%   model_movements = model_data.movements(start + (1:2000));
%   success = (movements == model_movements);
%   metric = sum(success(movements>0)>0)/length(success(movements>0));

  fr = data.truth_fr(start + (1:2000), neuronIdx);
  pre = model_data.pre(start + (1:2000), neuronIdx);
  metric = -mse(fr, pre);

  if metric>maxMetric
    maxMetric = metric;
    bestStart = start;
  end

end

end


function indexes = findBestTrials(data, model_data, neuronIdx)

%% find best low
metric = -Inf(60, 1);
trialIndexes_low = cell(60, 1);
trialNo = 0;
for i = 2:length(data.movements)-1

  if data.movements(i) == 1 && data.movements(i-1) == 0 
    trialNo = trialNo +1;
    trialIndexes_low{trialNo} = [trialIndexes_low{trialNo} (i-99):(i+50)];
    pressStart = 0;
  end

  if data.movements(i) == 2 && data.movements(i-1) == 0
    pressStart = i;
  end

  if data.movements(i) == 2 && data.movements(i+1) == 0
    trialIndexes_low{trialNo} = [trialIndexes_low{trialNo} pressStart-99:i];
    trialIndexes_low{trialNo} = unique(trialIndexes_low{trialNo});
    trialIndexes_low{trialNo}(trialIndexes_low{trialNo}<=0) = [];

    fr = data.truth_fr(trialIndexes_low{trialNo}, neuronIdx);
    pre = model_data.pre(trialIndexes_low{trialNo}, neuronIdx);
    metric(trialNo) = -mse(fr, pre);
  end

end

[~, best_low] = maxk(metric, 3);

%% find best high
metric = -Inf(60, 1);
trialIndexes_high = cell(60, 1);
trialNo = 0;
for i = 2:length(data.movements)-1

  if data.movements(i) == 1 && data.movements(i-1) == 0 
    trialNo = trialNo +1;
    trialIndexes_high{trialNo} = [trialIndexes_high{trialNo} (i-99):(i+50)];
    pressStart = 0;
  end

  if data.movements(i) == 3 && data.movements(i-1) == 0
    pressStart = i;
  end

  if data.movements(i) == 3 && data.movements(i+1) == 0
    trialIndexes_high{trialNo} = [trialIndexes_high{trialNo} pressStart-99:i];
    trialIndexes_high{trialNo} = unique(trialIndexes_high{trialNo});
    trialIndexes_high{trialNo}(trialIndexes_high{trialNo}<=0) = [];

    fr = data.truth_fr(trialIndexes_low{trialNo}, neuronIdx);
    pre = model_data.pre(trialIndexes_low{trialNo}, neuronIdx);
    metric(trialNo) = -mse(fr, pre);
  end

end

[~, best_high] = maxk(metric, 4);
% indexes = [trialIndexes_high{best_high(1)} trialIndexes_high{best_high(2)} trialIndexes_low{best_low(1)} ...
%   trialIndexes_high{best_high(3)} trialIndexes_low{best_low(2)} trialIndexes_high{best_high(4)}];
indexes = [cell2mat(trialIndexes_high(best_high)') cell2mat(trialIndexes_low(best_low)')];
indexes = unique(indexes);

end


function plot1Latent(plotIndex, dataIndex, vae, i)

N_std = 3;

plot(plotIndex, vae.latent_mu(i, dataIndex), 'k', 'LineWidth',1.5)
hold on
fill([plotIndex fliplr(plotIndex)], ...
  [vae.latent_mu(i, dataIndex)-N_std*vae.latent_std(i, dataIndex) ...
  fliplr(vae.latent_mu(i, dataIndex)+N_std*vae.latent_std(i, dataIndex))], ...
  'k', 'EdgeColor','none', 'FaceAlpha',0.3)
plot(plotIndex, vae.latent_pre(i, dataIndex), 'r', 'LineWidth',1.5)
hold off

ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.LineWidth = 1.5;
ax.TickLabelInterpreter = 'latex';

end


function show1neuronSpikes(data, rl, cons, vae, i, timeIndex, dataIndex)

plotSpikes(timeIndex, data.truth(dataIndex,i)', 1.4, 'k', 6);
hold on
plotSpikes(timeIndex, rl.spk(dataIndex,i)', 1.3, 'g', 6);
plotSpikes(timeIndex, cons.spk(dataIndex,i)', 1.2, 'b', 6);
plotSpikes(timeIndex, vae.spk(dataIndex,i)', 1.1, 'r', 6);

hold off
ylim([1 1.45]);
box off

set(gca, 'YColor', 'none')
set(gca, 'XColor', 'none')
set(gca, 'TickLength', [0 0])
end


function show1neuron(data, rl, cons, vae, i, timeIndex, dataIndex)

plot(timeIndex, data.truth_fr(dataIndex, i), 'k', LineWidth=2);
hold on
plot(timeIndex, rl.pre(dataIndex, i), 'Color', 'g', LineWidth=1);
plot(timeIndex, cons.pre(dataIndex, i), 'Color', 'b', LineWidth=1);
plot(timeIndex, vae.pre(dataIndex, i), 'Color', 'r', LineWidth=2);

hold off
box off

ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.LineWidth = 1.5;
ax.TickLabelInterpreter = 'latex';
end
