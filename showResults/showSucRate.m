clear; clc; close all;
addpath matlab_decoding/

%% 
DataNameList = ["data/rat008_1206.mat","data/rat009_0711.mat","data/rat010_0704.mat",...
                "data/rat011_0823.mat","data/rat025_0923.mat","data/rat028_1030.mat"];

Cons = load("results\successRate_Cons.mat");
baseline = load("results\successRate_baseline.mat");

%% SL
testSucRate_tVAE_SL = zeros(6, 5);
testTrialSucRate_tVAE_SL = zeros(6, 5);
for dataIdx = 5:6

DataName = DataNameList(dataIdx);
resultPredix = convertStringsToChars(DataName); resultPredix = resultPredix(6:16);
data = data_setup(DataName); % load data
for i=1:5
    IsGreedy = 0;
    load(['results/',resultPredix,'_Sup_',num2str(i),'.mat']);
    testSucRate_tVAE_SL(dataIdx,i) = testSucRate;
    [success,testSucRate,~] = emulator(spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);
    trialNum = 0;
    successTrialNum = 0;
    for timeIdx=2:length(success)
        if testActions(timeIdx-1)==0 && testActions(timeIdx)==1
            start = timeIdx;
            continue
        elseif timeIdx==length(success) || (testActions(timeIdx)>1 && testActions(timeIdx+1)==0)
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
    if testSucRate_tVAE_SL(dataIdx,i)~=testSucRate
        warning(['testSucRate wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    testTrialSucRate_tVAE_SL(dataIdx, i) = successTrialNum/trialNum;
end

end

%%
testSucRate25 = [baseline.testSucRateSL(5,:); baseline.testSucRateRL(5,:); Cons.testSucRateCons(5,:); testSucRate_tVAE_SL(5,:)];
testSucRate28 = [baseline.testSucRateSL(6,:); baseline.testSucRateRL(6,:); Cons.testSucRateCons(6,:); testSucRate_tVAE_SL(6,:)];
testTrialSucRate25 = [baseline.testTrialSucRateSL(5,:); baseline.testTrialSucRateRL(5,:); Cons.testTrialSucRateCons(5,:); testTrialSucRate_tVAE_SL(5,:)];
testTrialSucRate28 = [baseline.testTrialSucRateSL(6,:); baseline.testTrialSucRateRL(6,:); Cons.testTrialSucRateCons(6,:); testTrialSucRate_tVAE_SL(6,:)];

%% RL
testSucRate_tVAE_RL = zeros(6, 5);
testTrialSucRate_tVAE_RL = zeros(6, 5);
for dataIdx = 5:6

DataName = DataNameList(dataIdx);
resultPredix = convertStringsToChars(DataName); resultPredix = resultPredix(6:16);
data = data_setup(DataName); % load data
for i=1:5
    load(['results/',resultPredix,'_RL_',num2str(i),'.mat'], "testSucRate", "spkOutPredictTest", "testActions", "opt");
    testSucRate_tVAE_RL(dataIdx,i) = testSucRate;
    [success,testSucRate,~] = emulator(spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);
    trialNum = 0;
    successTrialNum = 0;
    for timeIdx=2:length(success)
        if testActions(timeIdx-1)==0 && testActions(timeIdx)==1
            start = timeIdx;
            continue
        elseif timeIdx==length(success) || (testActions(timeIdx)>1 && testActions(timeIdx+1)==0)
            if start == -1
                continue
            end
            stop = timeIdx;
            trialNum = trialNum + 1;
            if sum(success(start:stop)==1)/(sum(success(start:stop)==0)+sum(success(start:stop)==1))>0.7
                successTrialNum = successTrialNum + 1;
            end
            start = -1;
        else
            continue
        end
    end

    if trialNum~=opt.NumberOfTestTrials
        warning(['trialNum wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    if testSucRate_tVAE_RL(dataIdx,i)~=testSucRate
        warning(['testSucRate wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    testTrialSucRate_tVAE_RL(dataIdx, i) = successTrialNum/trialNum;
end

end

%%
testSucRate25 = [testSucRate25; testSucRate_tVAE_RL(5,:)];
testSucRate28 = [testSucRate28; testSucRate_tVAE_RL(6,:)];
testTrialSucRate25 = [testTrialSucRate25; testTrialSucRate_tVAE_RL(5,:)];
testTrialSucRate28 = [testTrialSucRate28; testTrialSucRate_tVAE_RL(6,:)];

%% RL with 5e3 iterations
testSucRate_tVAE_RL = zeros(6, 5);
testTrialSucRate_tVAE_RL = zeros(6, 5);
for dataIdx = 5:6

DataName = DataNameList(dataIdx);
resultPredix = convertStringsToChars(DataName); resultPredix = resultPredix(6:16);
data = data_setup(DataName); % load data
for i=1:5
    load(['results/',resultPredix,'_RL_oldHP_',num2str(i),'.mat'], "testSucRate", "spkOutPredictTest", "testActions", "opt");
    testSucRate_tVAE_RL(dataIdx,i) = testSucRate;
    [success,testSucRate,~] = emulator(spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);
    trialNum = 0;
    successTrialNum = 0;
    for timeIdx=2:length(success)
        if testActions(timeIdx-1)==0 && testActions(timeIdx)==1
            start = timeIdx;
            continue
        elseif timeIdx==length(success) || (testActions(timeIdx)>1 && testActions(timeIdx+1)==0)
            if start == -1
                continue
            end
            stop = timeIdx;
            trialNum = trialNum + 1;
            if sum(success(start:stop)==1)/(sum(success(start:stop)==0)+sum(success(start:stop)==1))>0.7
                successTrialNum = successTrialNum + 1;
            end
            start = -1;
        else
            continue
        end
    end

    if trialNum~=opt.NumberOfTestTrials
        warning(['trialNum wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    if testSucRate_tVAE_RL(dataIdx,i)~=testSucRate
        warning(['testSucRate wrong! Data:', num2str(dataIdx), ' fold ', num2str(i)])
    end
    testTrialSucRate_tVAE_RL(dataIdx, i) = successTrialNum/trialNum;
end

end

%%
testSucRate25 = [testSucRate25; testSucRate_tVAE_RL(5,:)];
testSucRate28 = [testSucRate28; testSucRate_tVAE_RL(6,:)];
testTrialSucRate25 = [testTrialSucRate25; testTrialSucRate_tVAE_RL(5,:)];
testTrialSucRate28 = [testTrialSucRate28; testTrialSucRate_tVAE_RL(6,:)];


%%
figure()
subplot(221)
bar(1:6, mean(testSucRate25, 2))
hold on
plot(1:6, testSucRate25, '*')
hold off
title('success rate')
ylabel('Rat 025')
subplot(222)
bar(1:6, mean(testTrialSucRate25, 2))
hold on
plot(1:6, testTrialSucRate25, '*')
hold off
title('trial success rate')

subplot(223)
bar(1:6, mean(testSucRate28, 2))
hold on
plot(1:6, testSucRate28, '*')
hold off
xticks(1:6)
xticklabels({'SL', 'RL', 'Cons', 'latent SL', 'latent RL', 'latent RL v2'})
ylabel('Rat 028')
subplot(224)
bar(1:6, mean(testTrialSucRate28, 2))
hold on
plot(1:6, testTrialSucRate28, '*')
hold off
xticklabels({'SL', 'RL', 'Cons', 'latent SL', 'latent RL', 'latent RL v2'})

