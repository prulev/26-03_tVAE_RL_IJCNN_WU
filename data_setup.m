function data = data_setup(DataName)
%% set data
rat = char(DataName);
data.rat = rat(9:11);

oldData = load(DataName, ...
    "mPFC","mPFCchannelName","mPFCnum",...
    "M1","M1channelName","M1num","M1order","M1num_pre",...
    "segment","trialNo","his","modelName","DataIndex");
newData = load(['data/extended_trial_data_' data.rat '.mat'], ...
  'M1_select', 'mPFC', 'folds', 'trial_No', 'mPFC_deleted', ...
  'movements');

% data.mPFC = data.mPFC';
% data.M1 = data.M1';

% data.rat = rat;

% data.mPFC(mPFC_deleted, :) = [];

data.DataIndex = oldData.DataIndex;
data.his = oldData.his;
data.modelName = oldData.modelName;
data.M1index =  oldData.M1order(1:oldData.M1num_pre);
data.folds = newData.folds;


data.Trials = oldData.trialNo;
data.extended_Trials = newData.trial_No;
% data.M1 = newData.M1_select;
data.M1 = oldData.M1(:,data.M1index)';
% data.M1 = newData.mPFC;
data.mPFC = oldData.mPFC';
if isfield(newData, 'mPFC_deleted')
  data.mPFC(newData.mPFC_deleted,:) = [];
end
% data.movements = newData.movements;
data.movements = oldData.segment;



% %% load train data
% mPFC_train = load('mPFC_evaluate_on_train.mat'); 
% % mPFC_train.latent_mu = mPFC_train.latent_mu(:,[1 3 2]);
% data.mPFC_latent = mPFC_train.latent_mu';
% 
% M1_train = load('M1_evaluate_on_train.mat'); 
% % M1_train.latent_mu = M1_train.latent_mu(:,[1 3 2]);  M1_train.latent_std = M1_train.latent_std(:,[1 3 2]); 
% data.M1_latent = M1_train.latent_mu';
% data.M1_latent_std = M1_train.latent_std';
% data.spikes = M1_train.truth';
% 
% data.Actions = M1_train.movements';
% data.Trials = M1_train.trials';
% 
% %% load test data
% mPFC = load('transformerVAE_RealData_1Encoder1Decoder_latent3_mPFC.mat'); 
% % mPFC.latent_mu = mPFC.latent_mu(:,[1 3 2]);
% data.mPFC_latent_test = mPFC.latent_mu';
% 
% M1 = load('transformerVAE_RealData_1Encoder1Decoder_latent3_M1.mat'); 
% % M1.latent_mu = M1.latent_mu(:,[1 3 2]); M1.latent_std = M1.latent_std(:,[1 3 2]); 
% data.M1_latent_test = M1.latent_mu';
% data.M1_latent_std_test = M1.latent_std';
% data.spikes_test = M1.truth';
% 
% data.testActions = M1.movements';
% 
% %% else
% data.mPFC_latent_dim = size(mPFC.latent_mu, 2);
% data.M1_latent_dim   = size(M1.latent_mu, 2);
% data.M1num = size(data.spikes, 1);
% 
% original_data = load("data\rat025_0923.mat", 'M1num_pre', 'M1order',"his","modelName");
% data.M1num_pre = original_data.M1num_pre;
% data.M1order = original_data.M1order;
% data.his = original_data.his;
% data.modelName = original_data.modelName;

end
