% 初步比较在decoder加positional encoding的效果，发现加了之后latent就和绝对位置无关了，符合预期
% 后续不建议直接用这个脚本
clear; clc; % close all
%%
% results = load('results\tVAE_025_M1_0_1En1De_24latent_explore.mat');
results = load('results\tVAE_025_M1_0_1En1De_24latent_decoder_pos.mat');
% results_pos = load('results\tVAE_025_M1_0_1En1De_24latent_decoder_pos.mat');

%%
data = load('data\rat025_0923.mat', 'M1num_pre', 'mPFCnum');
rat = '025';
region = 'M1';
test_fold = 0;
latent_dim = 24;
neuron_num = data.M1num_pre;

ps = pyenv;
if ~ (ps.Status == "Loaded")
%   pyenv("Version", "C:\Users\77057\Documents\PythonVenv\transformervae\Scripts\python.exe")
  pyenv("Version", "D:\Code\PythonVenv\tVAE_py39\Scripts\python.exe")
end
pyfunc = py.importlib.import_module('apis_for_matlab');
py.importlib.reload(pyfunc);
model = pyfunc.get_model(rat, test_fold, latent_dim, region, neuron_num);

%%
res = pyfunc.neural2latent(model, [zeros(neuron_num, 1) results.truth'], latent_dim);
latent_mu = double(res{1}); latent_mu = latent_mu(1:length(results.truth), :);
figure(1)
plotIndex = (1:1600) + 2800;
for i=1:latent_dim
  subplot(4,6,i)
  plot(latent_mu(plotIndex,i), 'r')
  hold on
  plot(results.latent_mu(plotIndex,i), 'k')
  hold off
end

%%
figure()
[~, ~, ~, ~, explained] = pca(results.latent_mu);
explained_no_pos = [0 cumsum(explained)'/100];

[~, ~, ~, ~, explained] = pca(results_pos.latent_mu);
explained_pos = [0 cumsum(explained)'/100];

results.truth_fr = get_truth_fr(results.truth);
[~, ~, ~, ~, explained] = pca(results.truth_fr);
explained_neural = [0 cumsum(explained)'/100];

plot(explained_neural, 'k')
hold on 
plot(explained_pos, 'r')
plot(explained_no_pos, 'b')
hold off
legend({'neural', 'with pos', 'no pos'})

%%
data = load('data\rat025_0923.mat');
% results = results_pos;
train_loss = results.train_loss_all(end,2)
val_loss = results.val_loss_all(end,2)

results.truth_fr = get_truth_fr(results.truth);
val_cc = mean(arrayfun(@(i) corr(results.predictions(:,i), results.truth_fr(:,i)), 1:size(results.truth, 2)))

[~,val_behavioral,~] = emulator( ...
  results.predictions,results.movements,data.M1order(1:data.M1num_pre),data.his,data.modelName)

