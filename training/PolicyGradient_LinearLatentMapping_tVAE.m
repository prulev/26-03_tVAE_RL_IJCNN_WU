function [data,opt,s] = PolicyGradient_LinearLatentMapping_tVAE(data,opt,pyfunc,mPFC_model,M1_model,s)
%PolicyGradient for linear latent mapping, inner reward, entropy regularization, manifold constraint
%   
rng(s);

%% history records
rewardHis = zeros(1,opt.maxEpisode);
rewardTestHis = zeros(1,opt.maxEpisode);
sl_loss_His = zeros(1,opt.maxEpisode);
sl_loss_TestHis = zeros(1,opt.maxEpisode);

MaxReward = -Inf;
% MinError = Inf;

%% input zero-mean
% inputMean = mean(data.mPFC_latent,2);

%% network weights
% weights     = 2*rand(opt.latent_dim, opt.latent_dim+1)-1;
weights = zeros(opt.latent_dim, opt.latent_dim+1);
% load("results\rat025_0923_Sup_1.mat", 'weights')
% weights_std = zeros(opt.latent_dim, opt.latent_dim+1);

%% prepare test data
opt.Mode = 'test';
[testInput,testM1_truth,testActions,~,opt] = DataLoader_tVAE(data,opt);

res = pyfunc.neural2latent(mPFC_model, testInput, opt.latent_dim);
mPFC_latent_test = double(res{1}); mPFC_latent_test = mPFC_latent_test(1:length(testInput), :)';
if any(isnan(mPFC_latent_test(:)))
  warning('mPFC_latent_test has Nan')
end

TestSamples = length(testInput);
inputUnitTest = [mPFC_latent_test;ones(1,TestSamples)];

res = pyfunc.neural2latent(M1_model, testM1_truth, opt.latent_dim);
M1_latent_test = double(res{1}); M1_latent_test = M1_latent_test(1:length(testM1_truth), :)';
M1_latent_std_test = double(res{2}); M1_latent_std_test = M1_latent_std_test(1:length(testM1_truth), :)';

if any(isnan(M1_latent_test(:))) || any(isnan(M1_latent_std_test(:)))
  warning('M1_latent_test or M1_latent_std_test has Nan')
end

%% Train NN with RL under manifold constraint
if (opt.verbose<=3)
    disp(['----', opt.DataIndex,' RL for latent mapping ','  start----']);
end

opt.Mode = 'train';
for episode=1:opt.maxEpisode
    % get batch data
    [inputUnit,batchM1_truth,batchActions,~,opt] = DataLoader_tVAE(data,opt);

    % mPFC to latent
    res = pyfunc.neural2latent(mPFC_model, inputUnit, opt.latent_dim);
    mPFC_latent = double(res{1}); mPFC_latent = mPFC_latent(1:length(inputUnit), :)';
    if isnan(mPFC_latent(1,end))
      mPFC_latent(:,end) = 0;     % 不知道为什么，但是输出的最后一段偶尔会有NaN(可能是最后一段segment有点儿问题？)
    end
    NumOfSamples = length(inputUnit);
    inputUnit = [mPFC_latent;ones(1,NumOfSamples)];
    % M1 to latent
    res = pyfunc.neural2latent(M1_model, batchM1_truth, opt.latent_dim);
    batchM1_latent = double(res{1}); batchM1_latent = batchM1_latent(1:length(batchM1_truth), :)';
    batchM1_latent_std = double(res{2}); batchM1_latent_std = batchM1_latent_std(1:length(batchM1_truth), :)';
    if isnan(batchM1_latent(1,end))
      batchM1_latent(:,end) = 0;     % 不知道为什么，但是输出的最后一段偶尔会有NaN(可能是最后一段segment有点儿问题？)
    end
    if isnan(batchM1_latent_std(1,end))
      batchM1_latent_std(:,end) = 1; % 不知道为什么，但是输出的最后一段偶尔会有NaN(可能是最后一段segment有点儿问题？)
    end

    % forward to get spikes
%     std = exp(-episode / 100) * 1.5 + 0.5;% (opt.maxEpisode - episode) / opt.maxEpisode * 2;
%     noise = reshape(repmat(randn(opt.latent_dim, ceil(NumOfSamples/50))*std, 50, 1), opt.latent_dim, []);

    M1_latent_pre = weights * inputUnit;
%     M1_latent_used = M1_latent_pre + noise(:, NumOfSamples);
%     pOutput = double(pyfunc.latent2neural(M1_model, M1_latent_used, size(data.M1, 1)))';
%     res = pyfunc.latent2neural_with_grad(M1_model, M1_latent_pre, size(data.M1, 1), batchM1_truth);
    res = pyfunc.latent2neural_with_grad(M1_model, M1_latent_pre, size(data.M1, 1));
    pOutput = double(res{1})';    grad = double(res{2});    spkOutPredict = double(res{3});
%     if isnan(pOutput(1,end))
%       pOutput(:,end) = 0.5;     % 不知道为什么，但是pOutput的最后一段偶尔会有NaN(可能是最后一段segment有点儿问题？)
%     end
%     spkOutPredict = rand(size(pOutput)) <= pOutput;

    M1_latent_pre_test = weights * inputUnitTest;
    pOutputTest = double(pyfunc.latent2neural(M1_model, M1_latent_pre_test, size(data.M1, 1)))';
    if isnan(pOutputTest(1,end))
      pOutputTest(:,end) = 0.5; % 不知道为什么，但是输出的最后一段偶尔会有NaN(可能是最后一段segment有点儿问题？)
    end
    spkOutPredictTest = rand(size(pOutputTest)) <= pOutputTest;

    % emulator: get predict motor
    [success,sucRate,motor_perform] = emulator( ...
        spkOutPredict,batchActions,data.M1index,data.his,data.modelName);
    rewardHis(episode) = sucRate;
    [~,testSucRate,motor_perform_test] = emulator( ...
        spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);
    rewardTestHis(episode) = testSucRate;
    
    % inner reward for less likely appear motor
    % TODO: Consider:"bonus reward", r=r+k*sqrt(\tau)
    n_motor1 = sum(motor_perform==1)+1;
    n_motor2 = sum(motor_perform==2)+1;
    n_motor3 = sum(motor_perform==3)+1;
    n_max = max([n_motor1, n_motor2, n_motor3]);
    innerReward = (motor_perform==1).*(n_max/n_motor1-1)+ ...
                  (motor_perform==2).*(n_max/n_motor2-1)+ ...
                  (motor_perform==3).*(n_max/n_motor3-1);
    
    % discounted return
    reward = success + opt.epsilon1*(1-episode/opt.maxEpisode)*innerReward;
    temp = reward; temp(isnan(reward)) = 0;

    smoothed_reward = conv(temp, opt.discountFactor.^((opt.discountLength-1):-1:0)/opt.discountLength);
    smoothed_reward = smoothed_reward(end-length(reward)+1:end);
    smoothed_reward(~isnan(reward)) = normalize(smoothed_reward(~isnan(reward))')';
    smoothed_reward(isnan(reward)) = 0;
    
    % store history and print log
    % NLL between M1 predict rate and true spike train
    sl_loss_His(episode) = CrossEntropyError(...
      [1-batchM1_truth;batchM1_truth],[1-pOutput;pOutput],NumOfSamples);
    sl_loss_TestHis(episode) = CrossEntropyError(...
      [1-testM1_truth;testM1_truth],[1-pOutputTest;pOutputTest],TestSamples);

    % record weights for best reward
    if episode > 1e2 && mean(rewardHis((episode-9):episode))>=MaxReward
      MaxReward = mean(rewardHis((episode-9):episode));
      MaxTestReward = rewardTestHis(episode);
      WeightBestReward = weights;
      MaxRewardEpisode = episode;
      % TODO: save variables for plot
    end
    % print log
    if (opt.verbose<=0)
        disp(strcat(...
          num2str(episode),'/',num2str(opt.maxEpisode),...
          '...Error',num2str(sl_loss_His(episode)),...
          '...Reward',num2str(rewardHis(episode)),...
          '...Test Error',num2str(sl_loss_TestHis(episode)),...
          '...Test Reward',num2str(rewardTestHis(episode)) ...
        ));
    end
    % plot results
    if (opt.verbose<=1 && (episode<=20 || mod(episode,20)==1))
        plotStatus
    end
    
    % get delta
%     delta = smoothed_reward .* (M1_latent_used-M1_latent_pre);
%     delta = grad;
    delta = smoothed_reward .* grad;
    % get gradient
    weightDelta = delta*inputUnit'; % / NumOfSamples;

    % gradient descent (Adam with weight decay maybe?)
    % TODO: magic number
%     lr = 3; 
    lr = 10*(1-episode/opt.maxEpisode)+10;
    weights = weights + lr*(-weightDelta-0.0*weights);

    if any(isnan(weights(:)))
      warning('!!!')
    end

end

%% test model
latent_test_pre     = WeightBestReward*inputUnitTest;
M1_latent_pre_test = latent_test_pre; % in test we do not explore
pOutputTest = double(pyfunc.latent2neural(M1_model, M1_latent_pre_test, size(data.M1, 1)))';
if isnan(pOutputTest(1,end))
  pOutputTest(:,end) = 0.5; % 不知道为什么，但是输出的最后一段偶尔会有NaN(可能是最后一段segment有点儿问题？)
end
spkOutPredictTest = rand(size(pOutputTest)) <= pOutputTest;
[~,testSucRate,motor_perform_test] = emulator( ...
    spkOutPredictTest,testActions,data.M1index,data.his,data.modelName);

if (opt.verbose<=2)
  plotStatus;
  plotTest;
end

if (opt.verbose<=3)
    disp(strcat(...
      '====',opt.DataIndex,' RL Test finish...Reward: ',num2str(testSucRate),'===='...
    ));
end

%% save results
clearvars("data", "mPFC_model", "M1_model", "pyfunc", "res");
% randstr = ['a':'z' '0':'9'];
% randId = [datestr(datetime,'mmmdd_HHMM'),'_',randstr(randi(length(randstr),1,4))];
% targetFile = ['results/temp/',opt.DataIndex,'_RL_',num2str(opt.testFold),'_',randId];
targetFile = ['results/',opt.modelName, opt.DataIndex,'_RL_oldHP_',num2str(opt.testFold)];
save(targetFile)

end
