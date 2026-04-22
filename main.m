clc;clear;close all;
addpath model/ utils/ matlab_decoding/ training/

% data = data_setup(); % load data
% opt = opt_Setup(data); % set options
% s = rng();

ps = pyenv;
if ~ (ps.Status == "Loaded")
  pyenv("Version", "C:\Environments\python_envs\py311_IJCNN_2603\python.exe")
end
pyfunc = py.importlib.import_module('apis_for_matlab');
py.importlib.reload(pyfunc);

% PolicyGradient_LinearLatentMapping_tVAE(data,opt,predict,s);

DataNameList = ["data/rat008_1206.mat","data/rat009_0711.mat","data/rat010_0704.mat",...
                "data/rat011_0823.mat","data/rat025_0923.mat","data/rat028_1030.mat"];

for dataIdx = 6 % 5:6
  DataName = DataNameList(dataIdx);
  data = data_setup(DataName); % load data
  opt = opt_Setup(data); % set options
  opt.modelName = 'TC10_'; % save TC results to results/TC_...
   
  rng('default');
  for testFold = 5 % 1:opt.foldNum
    opt.testFold = testFold;
    trainFolds = 1:opt.foldNum; trainFolds(testFold) = [];
    opt.trainTrials = cell2mat(opt.folds(trainFolds));
    opt.NumberOfTrainTrials = length(opt.trainTrials);
    opt.testTrials = opt.folds{testFold};
    opt.NumberOfTestTrials = length(opt.testTrials);
    opt.NumberOfAllTrials = opt.NumberOfTrainTrials + opt.NumberOfTestTrials;

    mPFC_model = pyfunc.get_model(data.rat, testFold-1, opt.latent_dim, 'mPFC', size(data.mPFC, 1));
    M1_model   = pyfunc.get_model(data.rat, testFold-1, opt.latent_dim, 'M1', size(data.M1, 1));

%     for i = 1:opt.
    s = rng;
%     SupervisedLearning(data,opt,pyfunc,mPFC_model,M1_model,s);
    PolicyGradient_LinearLatentMapping_tVAE(data,opt,pyfunc,mPFC_model,M1_model,s)

%   opt.Mode = 'train';
%   opt.DataLoaderCursor = 1;
%   [batchInput,batchM1_truth,batchActions,batchTrials,opt] = DataLoader_tVAE(data,opt);
%   res = pyfunc.neural2latent(mPFC_model, batchInput, opt.latent_dim);
%   latent_mu = double(res{1}); latent_mu = latent_mu(1:length(batchInput), :);
% 
%   ref_mPFC_train = load(['latent_models_backup\tVAE_' ...
%     data.rat '_mPFC_' num2str(testFold-1) '_1En1De_' num2str(opt.latent_dim) 'latent_decoder_pos_train_set.mat']);
% 
%   figure()
%   for lIdx = 1:opt.latent_dim
%     subplot(opt.latent_dim, 1, lIdx)
%     plot(latent_mu(101+(1:3e3), lIdx), 'r', 'LineWidth',1.5)
%     hold on
%     plot(ref_mPFC_train.latent_mu(1:3e3, lIdx), 'k', 'LineWidth',1.5)
%     hold off
%   end
% 
%   opt.Mode = 'test';
%   [testInput,testM1_truth,testActions,testTrials,opt] = DataLoader_tVAE(data,opt);
%   res = pyfunc.neural2latent(mPFC_model, testInput, opt.latent_dim);
%   latent_mu = double(res{1}); latent_mu = latent_mu(1:length(testInput), :);
% 
%   ref_mPFC_test = load(['latent_models_backup\tVAE_' ...
%     data.rat '_mPFC_' num2str(testFold-1) '_1En1De_' num2str(opt.latent_dim) 'latent_decoder_pos.mat']);
% 
%   figure()
%   for lIdx = 1:opt.latent_dim
%     subplot(opt.latent_dim, 1, lIdx)
%     plot(latent_mu(101+(1:3e3), lIdx), 'r', 'LineWidth',1.5)
%     hold on
%     plot(ref_mPFC_test.latent_mu(1:3e3, lIdx), 'k', 'LineWidth',1.5)
%     hold off
%   end

%   opt.Mode = 'train';
%   opt.DataLoaderCursor = 1;
%   [batchInput,batchM1_truth,batchActions,batchTrials,opt] = DataLoader_tVAE(data,opt);
%   res = pyfunc.neural2latent(M1_model, batchM1_truth, opt.latent_dim);
%   latent_mu = double(res{1}); latent_mu = latent_mu(1:length(batchM1_truth), :);
% 
%   ref_M1_train = load(['latent_models_backup\tVAE_' ...
%     data.rat '_M1_' num2str(testFold-1) '_1En1De_' num2str(opt.latent_dim) 'latent_decoder_pos_train_set.mat']);
% 
%   figure()
%   for lIdx = 1:opt.latent_dim
%     subplot(opt.latent_dim, 1, lIdx)
%     plot(latent_mu(101+(1:3e3), lIdx), 'r', 'LineWidth',1.5)
%     hold on
%     plot(ref_M1_train.latent_mu(1:3e3, lIdx), 'k', 'LineWidth',1.5)
%     hold off
%   end
% 
%   opt.Mode = 'test';
%   [testInput,testM1_truth,testActions,testTrials,opt] = DataLoader_tVAE(data,opt);
%   res = pyfunc.neural2latent(M1_model, testM1_truth, opt.latent_dim);
%   latent_mu = double(res{1}); latent_mu = latent_mu(1:length(testM1_truth), :);
% 
%   ref_M1_test = load(['latent_models_backup\tVAE_' ...
%     data.rat '_M1_' num2str(testFold-1) '_1En1De_' num2str(opt.latent_dim) 'latent_decoder_pos.mat']);
% 
%   figure()
%   for lIdx = 1:opt.latent_dim
%     subplot(opt.latent_dim, 1, lIdx)
%     plot(latent_mu(101+(1:3e3), lIdx), 'r', 'LineWidth',1.5)
%     hold on
%     plot(ref_M1_test.latent_mu(1:3e3, lIdx), 'k', 'LineWidth',1.5)
%     hold off
%   end



% 
%     disp(['----', opt.DataIndex,' ',Sch,' fold ',num2str(opt.testFold),' Train start----']);
% %     parfor(i = 1:opt.ReTrainTimes,8) % limited memory orz
%         disp(['parfor loop ', num2str(i)])
%         s = rng;
% %         if (constraint==0)
%             PolicyGradient_inRwd_Entropy_Manifold(data,opt,s,inputEnsemble,M1_truth,Actions,Trials);
% %         else
% %             SupervisedLearning(data,opt,s,inputEnsemble,M1_truth,Actions,Trials);
% %         end
% %     end
% 
%     paths = dir(['results/temp/',data.DataIndex,'_',Sch,'_',num2str(opt.testFold),'_','*.mat']);
%     testSuc = zeros(1,length(paths));
%     for i=1:length(paths)
%         load(['results/temp/',paths(i).name],"MaxReward","testSucRate")
%         testSuc(i) = testSucRate;
%     end
%     [bestTestSuc,I] = max(testSuc);
%     source = ['results/temp/',paths(I).name];
%     destination = [source([1:8 14:end-20]), '.mat'];
%     copyfile(source, destination)
%     disp([destination, ' Best testSuc: ', num2str(bestTestSuc)])
% end
  end
end
% 
% %%
% function Sch = getScheduleName(constraint)
% if constraint==0
%     Sch = 'RL';
% else
%     Sch = 'Cons';
% end
% 
% end
