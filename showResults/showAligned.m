clear; clc; close all
addpath plotUtils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [-30 3 25 13];

modelColor = {'k', 'r', 'g', 'b', 'm'};

timeslot = 10;              % interval of time-bin
opt.sampleRate = 1000/timeslot; %s ampleRate
opt.DTCorrelation = 1;      % 1 for DTKS, 0 for prototyped KS
opt.KS_N = 10;              % number of repeated calculations

%%
% rat = '025';
fileName = 'rat025_0923';
% latent_dim = 4;
test_fold = 2;
region = 'M1';

rl = load(['old_results/' fileName, '_RL_', num2str(test_fold), '.mat']);
cons = load(['old_results/' fileName, '_Cons_', num2str(test_fold), '.mat']);
vae = load(['results/' fileName, '_RL_oldHP_', num2str(test_fold), '.mat']);  

data.movements = rl.testActions;
data.truth_fr = get_truth_fr(rl.testhM1_truth');
data.truth = rl.testhM1_truth';
data.rl_pre = rl.pOutputTest';
data.rl_pre_spk = rl.spkOutPredictTest';
data.cons_pre = cons.pOutputTest';
data.cons_pre_spk = rl.spkOutPredictTest';
data.vae_pre = vae.pOutputTest';
data.vae_pre_spk = vae.spkOutPredictTest';

plotIndex = (1:1600) + 3800;  % TODO: explore for best fit
plotNeuron = 4;
subplot(211)
show_one_neuron(data, plotNeuron, plotIndex)
title(['\textbf{Rat A ' region ' Neuron ', num2str(plotNeuron), '}'], ...
  'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')

legend({'', '', '', 'Real', 'RL w/o Cons', 'RL w Cons', 'RL w dynamic'}, ...
  'Interpreter','latex', 'Orientation','vertical', 'FontSize',13)

[~, DBR] = DBR_avg_Calc(rl.pOutputTest, rl.testhM1_truth, opt);
disp(['RL mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])

[~, DBR] = DBR_avg_Calc(cons.pOutputTest, cons.testM1_truth, opt);
disp(['Cons mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])

[~, DBR] = DBR_avg_Calc(vae.pOutputTest, vae.testM1_truth, opt);
disp(['VAE mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])

%%
% rat = '028';
fileName = 'rat028_1030';
% latent_dim = 4;
test_fold = 2;
region = 'M1';

rl = load(['old_results/' fileName, '_RL_', num2str(test_fold), '.mat']);
cons = load(['old_results/' fileName, '_Cons_', num2str(test_fold), '.mat']);
vae = load(['results/' fileName, '_RL_oldHP_', num2str(test_fold), '.mat']);  

data.movements = rl.testActions;
data.truth_fr = get_truth_fr(rl.testhM1_truth');
data.truth = rl.testhM1_truth';
data.rl_pre = rl.pOutputTest';
data.rl_pre_spk = rl.spkOutPredictTest';
data.cons_pre = cons.pOutputTest';
data.cons_pre_spk = rl.spkOutPredictTest';
data.vae_pre = vae.pOutputTest';
data.vae_pre_spk = vae.spkOutPredictTest';

plotIndex = (1:1600) + 3000;  % TODO: explore for best fit
plotNeuron = 5;
subplot(212)
show_one_neuron(data, plotNeuron, plotIndex)
title(['\textbf{Rat B ' region ' Neuron ', num2str(plotNeuron), '}'], ...
  'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
ylim([0 0.3])

xlabel("time (sec)", 'Interpreter','latex', 'FontSize',14)
ylabel("firing probability", 'Interpreter','latex', 'FontSize',14)

[~, DBR] = DBR_avg_Calc(rl.pOutputTest, rl.testhM1_truth, opt);
disp(['RL mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])

[~, DBR] = DBR_avg_Calc(cons.pOutputTest, cons.testM1_truth, opt);
disp(['Cons mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])

[~, DBR] = DBR_avg_Calc(vae.pOutputTest, vae.testM1_truth, opt);
disp(['VAE mean DBR: ', num2str(mean(DBR)) ' std : ', num2str(std(DBR))])

% plotNeurons = 1:9;
% plotNeurons = 1:7;
% plotNeurons = [3 5]; % 028
% for i=1:length(plotNeurons)
%   subplot(4,3,i)
%   show_one_neuron(data, plotNeurons(i), plotIndex)
%   title(['\textbf{' region ' Neuron ', num2str(plotNeurons(i)), '}'], ...
%     'Interpreter','latex', 'FontSize',15, 'FontWeight','bold')
% end
% legend({'Real', 'RL w/o Cons', 'RL w Cons', 'RL w dynamic'}, ...
%   'Interpreter','latex', 'Orientation','horizontal', 'FontSize',13, ...
%   'Position',[0.3 0.48 0.61 0.03])
% subplot(4,3,1)
% text(-0.2, 1.3, "\textbf{Rat~A}", 'Interpreter','latex', ...
%   'FontSize',15, 'Units','normalized')


%% show 1 neuron
function show_one_neuron(data, i, plotIndex)

% [bestStart, bestEnd] = findBestFit(data.truth_fr(:,i), data.predictions(:,i), data.movements, 3000);
% plotIndex = bestStart:bestEnd;
timeIndex = plotIndex/100;

pos = max([data.truth_fr(plotIndex, i); data.rl_pre(plotIndex, i); ...
  data.cons_pre(plotIndex, i); data.vae_pre(plotIndex, i)]);

area(timeIndex, 1.1*pos*(data.movements(plotIndex)==1), 'FaceColor', 'b', 'FaceAlpha', 0.1, 'EdgeAlpha',0); 
hold on
area(timeIndex, 1.1*pos*(data.movements(plotIndex)==2), 'FaceColor', 'g', 'FaceAlpha', 0.1, 'EdgeAlpha',0);
area(timeIndex, 1.1*pos*(data.movements(plotIndex)==3), 'FaceColor', 'r', 'FaceAlpha', 0.1, 'EdgeAlpha',0);

plot(timeIndex, data.truth_fr(plotIndex, i), 'k', LineWidth=2);
hold on
plot(timeIndex, data.rl_pre(plotIndex, i), 'Color', 'r', LineWidth=1.5);
plot(timeIndex, data.cons_pre(plotIndex, i), 'Color', 'g', LineWidth=1.5);
plot(timeIndex, data.vae_pre(plotIndex, i), 'Color', 'b', LineWidth=1.5);
% yl = ylim();

% plotSpikes(timeIndex, data.truth(plotIndex,i)', pos*1.35, 'k', 6);
% plotSpikes(timeIndex, data.predicted_spikes(plotIndex,i)', pos*1.2, 'm', 6);

hold off
set(gca, 'TickLabelInterpreter', 'latex')
% ylim([yl(1) pos*1.4]);

% xlabel('time (sec)', FontSize=19, Interpreter='latex', FontWeight='bold')
% ylabel('firing probability', FontSize=19, Interpreter='latex', FontWeight='bold')

ax = gca;
ax.XAxis.FontSize = 13;
ax.YAxis.FontSize = 13;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.LineWidth = 1.5;
end
