% 绘图：展示test set上neural reconstruction的结果
close all; clc; clear;
addpath plotUtils\ utils\

f = figure(1);
f.Color = 'w';
f.Units = 'centimeters';
f.Position = [0 0 12 20];

timeslot = 10;              % interval of time-bin
opt.sampleRate = 1000/timeslot; %s ampleRate
opt.DTCorrelation = 1;      % 1 for DTKS, 0 for prototyped KS
opt.KS_N = 10;              % number of repeated calculations

%%
rat = '025';
latent_dim = 4;
test_fold = 2;

region = 'mPFC';

meanDBR = zeros(2, 5);
for test_fold = 1:5

test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);

[~, DBR] = DBR_avg_Calc(test_data.truth_fr', test_data.truth', opt);  
meanDBR(1, test_fold) = mean(DBR);
[~, DBR] = DBR_avg_Calc(test_data.predictions', test_data.truth', opt);
meanDBR(2, test_fold) = mean(DBR);

end

disp(['Smoothed ' region ' mean DBR: ', num2str(mean(meanDBR(1,:))) ' std : ', num2str(std(meanDBR(1,:)))])
disp(['VAE ' region ' mean DBR: ', num2str(mean(meanDBR(2,:))) ' std : ', num2str(std(meanDBR(2,:)))])

%%
region = 'M1';

meanDBR = zeros(2, 5);
for test_fold = 1:5

test_data = load(['latent_models_backup/tVAE_' rat '_' region '_' num2str(test_fold-1) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);
test_data.predicted_spikes = double(test_data.predicted_spikes);
test_data.truth_fr = get_truth_fr(test_data.truth);

[~, DBR] = DBR_avg_Calc(test_data.truth_fr', test_data.truth', opt);  
meanDBR(1, test_fold) = mean(DBR);
[~, DBR] = DBR_avg_Calc(test_data.predictions', test_data.truth', opt);
meanDBR(2, test_fold) = mean(DBR);

end

disp(['Smoothed ' region ' mean DBR: ', num2str(mean(meanDBR(1,:))) ' std : ', num2str(std(meanDBR(1,:)))])
disp(['VAE ' region ' mean DBR: ', num2str(mean(meanDBR(2,:))) ' std : ', num2str(std(meanDBR(2,:)))])
