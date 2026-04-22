% 绘图：看latent factor是否只与其中几个neuron相关
close all; clc; clear;
addpath plotUtils\ utils\

%%
rat = '028';
region = 'mPFC';
latent_dim = 4;

test_fold = 4;

data = load(['results/tVAE_' rat '_' region '_' num2str(test_fold) ...
  '_1En1De_' num2str(latent_dim) 'latent_decoder_pos.mat' ], ...
  'latent_mu', 'truth', 'movements', 'predictions');
data.truth_fr = get_truth_fr(data.truth);

% figure("Name", [rat ' ' region ' fold: ' num2str(test_fold)])
% plotIndex = (1:2000) + 3000;  % TODO: explore for best fit
% for nIdx=1:size(test_data.truth_fr, 2)
%   if strcmp(region, 'M1')
%     subplot(3,3,nIdx)
%   else
%     subplot(4,4,nIdx)
%   end
% 
%   show_one_neuron(test_data.truth_fr, test_data.predictions, test_data.latent_mu, test_data.movements, nIdx, 4, plotIndex)
% end

cc_matrix = zeros(5, size(data.truth_fr, 2));
for nIdx=1:size(data.truth_fr, 2)

  cc_matrix(1, nIdx) = corr(data.predictions(:,nIdx), data.truth_fr(:,nIdx));
  for lIdx = 1:latent_dim
    cc_matrix(lIdx+1, nIdx) = corr(data.predictions(:,nIdx), data.latent_mu(:,lIdx));
  end

end

figure()
subplot(211)
bar(abs(cc_matrix)')
xlabel('neuron index')
ylabel('absolute CC values')
legend({'prediction vs truth', 'prediction vs latent 1', ...
  'prediction vs latent 2', 'prediction vs latent 3', 'prediction vs latent 4'})

subplot(212)
bar(abs(cc_matrix))
xlabel('latent index')
ylabel('absolute CC values')

%% show 1 neuron
function show_one_neuron(truth, predictions, latent, movements, nIdx, lIdx, plotIndex)

timeIndex = plotIndex/100;
plot_truth = zscore(truth(:,nIdx));
plot_predictions = zscore(predictions(:,nIdx));
plot_latent = gaussianSmooth(zscore(latent(:,lIdx)), 5);
cc = corr(plot_predictions, plot_latent);
if cc < 0
  plot_predictions = - plot_predictions;
  plot_truth = - plot_truth;
  cc = corr(plot_predictions, plot_latent);
end

pos = 1;

area(timeIndex, 1.1*pos*(movements(plotIndex)==1), 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeAlpha',0); 
hold on
area(timeIndex, 1.1*pos*(movements(plotIndex)==2), 'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeAlpha',0);
area(timeIndex, 1.1*pos*(movements(plotIndex)==3), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeAlpha',0);

plot(timeIndex, plot_truth(plotIndex), 'k', LineWidth=1.5);
plot(timeIndex, plot_predictions(plotIndex), 'c', LineWidth=1.5);
plot(timeIndex, plot_latent(plotIndex), 'Color', 'm', LineWidth=1.5); 
hold off
set(gca, 'TickLabelInterpreter', 'latex')
title(['Neuron ', num2str(nIdx), ' with Latent ', num2str(lIdx), ' cc: ', num2str(cc)])
end
% 
% function normalized_vector = normalize_vector(vector)
%     min_val = min(vector);
%     max_val = max(vector);
%     normalized_vector = (vector - min_val) / (max_val - min_val);
% end
