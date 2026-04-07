function [data,opt,s] = SupervisedLearning(data,opt,pyfunc,mPFC_model,M1_model,s)
%Supervised learning
%   
rng(s);
%% history records
% rewardHis = zeros(1,opt.maxEpisode);
% rewardTestHis = zeros(1,opt.maxEpisode);
% sl_loss_His = zeros(1,opt.maxEpisode);
% sl_loss_TestHis = zeros(1,opt.maxEpisode);
% MaxReward = -Inf;
% MinError = Inf;

%% network weights
% weights     = 2*rand(opt.latent_dim, opt.latent_dim+1)-1;
% weights_std = zeros(opt.latent_dim, opt.latent_dim+1);

%% prepare test data
% opt.Mode = 'test';
% [testInput,testM1_truth,testActions,testTrials,opt] = DataLoader_tVAE(data,opt);

%% Supervised learning with linear model
% least square is enough
% if (opt.verbose<=3)
%     disp(['----', opt.DataIndex,' Sup Train start----']);
% end

% load train data
opt.Mode = 'all';
[trainInput,trainM1_truth,trainActions,~,opt] = DataLoader_tVAE(data,opt);

% mPFC to latent
res = pyfunc.neural2latent(mPFC_model, trainInput, opt.latent_dim);
mPFC_latent = double(res{1}); mPFC_latent = mPFC_latent(1:length(trainInput), :)';

NumOfSamples = length(trainInput);
inputUnit = [mPFC_latent;ones(1,NumOfSamples)];

% M1 to latent TODO: we may need to consider 1-step delay?
res = pyfunc.neural2latent(M1_model, trainM1_truth, opt.latent_dim);
M1_latent = double(res{1}); M1_latent = M1_latent(1:length(trainM1_truth), :)';

% get weights
weights = (inputUnit' \ M1_latent')';

% get M1 on train set
M1_latent_pre = weights * inputUnit;
pOutput = pyfunc.latent2neural(M1_model, M1_latent_pre, size(data.M1, 1));
pOutput = double(pOutput);
spkOutPredict = rand(size(pOutput)) <= pOutput;

[~,sucRate,motor_perform] = emulator( ...
    spkOutPredict,trainActions,data.M1index,data.his,data.modelName);

% evaluate on test
opt.Mode = 'test';
[testInput,testM1_truth,testActions,~,opt] = DataLoader_tVAE(data,opt);

res = pyfunc.neural2latent(mPFC_model, testInput, opt.latent_dim);
mPFC_latent_test = double(res{1}); mPFC_latent_test = mPFC_latent_test(1:length(testInput), :)';

TestSamples = length(testInput);
inputUnitTest = [mPFC_latent_test;ones(1,TestSamples)];

M1_latent_pre_test = weights * inputUnitTest;
pOutputTest = pyfunc.latent2neural(M1_model, M1_latent_pre_test, size(data.M1, 1));
pOutputTest = double(pOutputTest);
spkOutPredictTest = rand(size(pOutputTest)) <= pOutputTest;

[~,testSucRate,motor_perform_test] = emulator( ...
    spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);

clearvars("data", "mPFC_model", "M1_model", "pyfunc", "res");
targetFile = ['results/',opt.DataIndex,'_Sup_',num2str(opt.testFold)];
save(targetFile)

% for episode=1:opt.maxEpisode
%     % get batch data
%     [batchInput,batchM1_truth,batchActions,batchTrials,opt] = DataLoader_tVAE(data,opt);
%     NumOfSamples = length(batchInput);
% 
%     res = pyfunc.neural2latent(mPFC_model, batchInput, opt.latent_dim);
%     mPFC_latent = double(res{1}); mPFC_latent = mPFC_latent(1:length(batchInput), :)';
% 
%     inputUnit = [mPFC_latent;ones(1,NumOfSamples)];
% %   res = pyfunc.neural2latent(M1_model, batchM1_truth, opt.latent_dim);
% %   latent_mu = double(res{1}); latent_mu = latent_mu(1:length(batchM1_truth), :);
% 
% 
%     % forward to get spikes
%     latent_pre     = weights*inputUnit;
% %     log_var_pre = weights_std*inputUnit;
%     [pOutput, hiddenUnit, spkOutPredict] = applynets(inputUnit,...
%         weightFromInputToHidden,weightFromHiddenToOutput,NumOfSamples);
%     
%     % emulator: get predict motor
%     [success,sucRate,motor_perform] = emulator( ...
%         spkOutPredict,batchActions,opt.M1index,data.his,data.modelName);
%     rewardHis(episode) = sucRate;
%     
%     % store history and print log
%     % cross-entropy between M1 predict rate and true spike train
%     crossEntropyHis(episode) = CrossEntropyError(...
%       [1-batchM1_truth;batchM1_truth],[1-pOutput;pOutput],NumOfSamples);
%     if crossEntropyHis(episode)<=MinError
%       MinError = crossEntropyHis(episode);
%       L2Weight = weightFromHiddenToOutput;
%       L1Weight = weightFromInputToHidden;
%       MinErrorEpisode = episode;
% %       BestState = who();
%     end
%     % record weights for best reward
%     if rewardHis(episode)>=MaxReward
%       MaxReward = rewardHis(episode);
%       L2WeightBestReward = weightFromHiddenToOutput;
%       L1WeightBestReward = weightFromInputToHidden;
%       MaxRewardEpisode = episode;
% %       BestRewardState = who();
%     end
%     % print log
%     if (opt.verbose<=0)
%         disp(strcat(...
%           num2str(episode),'/',num2str(opt.maxEpisode),...
%           '...Error',num2str(crossEntropyHis(episode)),...
%           '...Reward',num2str(rewardHis(episode))...
%         ));
%     end
%     % plot results
%     if (opt.verbose<=1 && (episode<=100 || mod(episode,20)==1))
%         plotStatus
%     end
%     
%     % get gradient
%     [WeightDelta1,WeightDelta2] = getgradient_sup(...
%         pOutput,batchM1_truth,hiddenUnit,inputUnit,...
%         weightFromHiddenToOutput,NumOfSamples...
%     );
% 
%     % gradient descent
%     % TODO: magic number
%     lr = 1.1*(1-episode/opt.maxEpisode)+0.1;
%     weightFromHiddenToOutput = weightFromHiddenToOutput + ...
%         lr*(WeightDelta1-0*weightFromHiddenToOutput);
%     weightFromInputToHidden = weightFromInputToHidden + ...
%         lr*(WeightDelta2-0*weightFromInputToHidden);
% end
% 
% %% test model
% opt.Mode = 'test';
% [testInput,testhM1_truth,testActions,opt] = DataLoader( ...
%     inputEnsemble,M1_truth,Actions,Trials,opt);
% TestSamples = length(testInput);
% inputUnitTest = [testInput;ones(1,TestSamples)];
% [pOutputTest, hiddenUnitTest, spkOutPredict] = applynets(inputUnitTest,...
%     L1Weight,L2Weight,TestSamples);
% [~,testSucRate,motor_perform_test] = emulator(spkOutPredict,testActions,opt.M1index,data.his,data.modelName);
% 
% if (opt.verbose<=2)
%     plotTest;
% end
% 
% if (opt.verbose<=3)
%     disp(strcat(...
%       '====',opt.DataIndex,' Sup ', opt.IsGreedyStr,' Test finish...Reward: ',num2str(testSucRate),'===='...
%     ));
% end

% %% save results
% clearvars("data","inputEnsemble","M1_truth","Actions","Trials");
% randstr = ['a':'z' '0':'9'];
% randId = [datestr(datetime,'mmmdd_HHMM'),'_',randstr(randi(length(randstr),1,4))];
% targetFile = ['results/temp/',opt.DataIndex,'_Sup_',num2str(opt.testFold),'_',randId];
% save(targetFile)

end
