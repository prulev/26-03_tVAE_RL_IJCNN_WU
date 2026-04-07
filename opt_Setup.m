function opt = opt_Setup(data)
%% set training options, specially for latent mapping
% 
%%
%% data description
opt.DataIndex = data.DataIndex;
% opt.mPFCchannels = size(data.mPFC,1);
% opt.M1index = data.M1order(1:data.M1num_pre);
% %% hyperparameters for Hawkes process
% opt.decay_parameter = 150;
%% hyperparameters for tVAE
opt.latent_dim = 4;
%% hyperparameters for training
% % opt.trainsize = 0.8;
% % opt.validatesize = 0;
% % opt.testsize = 0.2;         % no validation set, train:test 4:1
opt.foldNum = 5;            % use five-fold cross validation
opt.folds = data.folds;
opt.maxEpisode = 5e3;       % maximum number of iteration
opt.batchSize = 20;         % No of trials per batch, 20 trials should be about 30s
% opt.RelevantSpikes = 5;     % 5 past mPFC spikes should cover about 500ms history
% opt.hiddenUnitNum = 64;   % should be smaller (?)
% % warning(['opt.hiddenUnitNum = ', num2str(opt.hiddenUnitNum), ', which can be considered.'])
% % opt.learningRate = 1.2;
% % warning('Learning Rate are not tuned yet.')
%% hyperparameters for reward design
opt.discountFactor = 0.98;
opt.discountLength = 100; % change this to change the length of assigning reward
opt.historyLength = 100; % keep this 100 to make the data length the same as before
% % if the predicted movements are almost the same one, increase epsilon1
opt.epsilon1 = 1.0;         % coefficient for inner reward
% % opt.epsilon2 = 0;           % Deprecated; coefficient for unexpected reward
% %% hyperparameters for entropy regularization
% opt.Eta = 0.005;
% %% hyperparameters for manifold constraint
% opt.damping = 10;
% opt.lambda_lr = 1.0;
% opt.latent_amplifier_first = 3;
% opt.latent_amplifier_rest = 2;
% %% options for KS test
% timeslot = 10;              % interval of time-bin
% opt.sampleRate = 1000/timeslot; %s ampleRate
% opt.DTCorrelation = 1;      % 1 for DTKS, 0 for prototyped KS
%% initial data loader
opt.DataLoaderCursor = 1;
opt.trainTrials = 0;
opt.testTrials = 0;
opt.NumberOfAllTrials = 0;
opt.NumberOfTrainTrials = 0;
opt.NumberOfTestTrials = 0;

% opt.NumberOfTestTrials = 0;
%% train model
opt.Mode = '';              % train or test
%% log control
opt.verbose = 0;            % control the output logs
% %% re-training
% opt.ReTrainTimes = 16;      % run several times to avoid local minimum
end
