DataName = DataNameList(dataIdx);
fold = foldSelect(dataIdx);
resultPredix = convertStringsToChars(DataName); resultPredix = resultPredix(6:16);
RL = load(['results/',resultPredix,'_RL_',num2str(fold),'.mat'], 'testActions', 'testhM1_truth','spkOutPredictTest');
RL.testM1_truth = RL.testhM1_truth; RL = rmfield(RL, 'testhM1_truth');
SL = load(['results/',resultPredix,'_Sup_',num2str(fold),'.mat'], 'testActions', 'testhM1_truth', 'spkOutPredict');
SL.testM1_truth = SL.testhM1_truth; SL = rmfield(SL, 'testhM1_truth');

getPlotModulation = @(x) [
  smoothdata(squeeze(sum(x(:,:,1:51), 2))/size(x,2), 2, 'gaussian', 25) ...
  smoothdata(squeeze(sum(x(:,:,52:end), 2))/size(x,2), 2, 'gaussian', 25)
];

[lR,hR] = getRaster(RL.testActions,RL.testM1_truth);
plot_lR = getPlotModulation(lR);
plot_hR = getPlotModulation(hR);
[lRp,hRp] = getRaster(RL.testActions,RL.spkOutPredictTest);
plot_lRp = getPlotModulation(lRp);
plot_hRp = getPlotModulation(hRp);
[lRsp,hRsp] = getRaster(SL.testActions,SL.spkOutPredict);
plot_lRsp = getPlotModulation(lRsp);
plot_hRsp = getPlotModulation(hRsp);
