% clear; clc; close all

data = load('data\rat025_0923.mat', 'M1num_pre', 'mPFCnum');
% data = load('data\rat028_1030.mat', 'M1num_pre', 'mPFCnum');

rat = '025';
region = 'M1';
test_fold = 0;
latent_dim = 24;
neuron_num = data.M1num_pre;
% neuron_num = data.mPFCnum;
results = load(['results/tVAE_' rat '_' region '_' num2str(test_fold) '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ]);

%%
ps = pyenv;
if ~ (ps.Status == "Loaded")
%   pyenv("Version", "C:\Users\77057\Documents\PythonVenv\transformervae\Scripts\python.exe")
  pyenv("Version", "D:\Code\PythonVenv\tVAE_py39\Scripts\python.exe")
end
pyfunc = py.importlib.import_module('apis_for_matlab');
py.importlib.reload(pyfunc);
model = pyfunc.get_model(rat, test_fold, latent_dim, region, neuron_num);

%% neural 2 latent
res = pyfunc.neural2latent(model, [zeros(neuron_num, 1) results.truth'], latent_dim);
latent_mu = double(res{1}); latent_mu = latent_mu(1:length(results.truth), :);
latent_std = double(res{2}); latent_std = latent_std(1:length(results.truth), :);

figure(1)
plotIndex = (1:1000) + 2800;
for i=1:latent_dim
  subplot(4,6,i)
  plot(latent_mu(plotIndex,i), 'r')
  hold on
  plot(results.latent_mu(plotIndex,i), 'k')
  hold off
end

%% latent 2 neural
predictions = pyfunc.latent2neural(model, results.latent_mu', neuron_num);
predictions = double(predictions);

figure(2)
plotIndex = (1:1000) + 2800;
for i=1:neuron_num
  subplot(3,3,i)
  plot(predictions(plotIndex,i), 'r')
  hold on
  plot(results.predictions(plotIndex,i), 'k')
  plot(gaussianSmooth(results.truth(plotIndex,i), 10), 'g')
  hold off
end
