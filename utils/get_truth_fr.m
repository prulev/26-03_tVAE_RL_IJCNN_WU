%% smooth true spikes to get firing rate
function truth_fr = get_truth_fr(truth)

truth_fr = zeros(size(truth));

for i=1:size(truth, 2)

  truth_fr(:,i) = gaussianSmooth(truth(:,i), 10);

end

end