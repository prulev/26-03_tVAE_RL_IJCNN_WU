function y=DBR_calc(x1,x2,opt)
opt.DTCorrelation = 1;
xAxis = [];
KSSorted = [];
for ks_trail = 1:opt.KS_N
[ Z, U, xAxis(ks_trail,:), KSSorted(ks_trail,:), KSValue_GLM(ks_trail) ] = computeKSStats( x2', x1'* opt.sampleRate, opt );
end
xAxis = mean(xAxis);
KSSorted = mean(KSSorted);
KSValue_GLM = mean(KSValue_GLM);
y = KSValue_GLM/1.36*sqrt(sum(x2 == 1));
% figure;
% plot(xAxis, KSSorted, 'linewidth', 2); hold on;
% plot(((1:sum(x2 == 1)))/sum(x2 == 1), (1:sum(x2 == 1))/sum(x2 == 1),'r', 'linewidth', 2);
% plot((1:sum(x2 == 1))/sum(x2 == 1), (1:sum(x2 == 1))/sum(x2 == 1)+1.36/sqrt(sum(x2 == 1)),'r--', 'linewidth', 2);
% plot((1:sum(x2 == 1))/sum(x2 == 1), (1:sum(x2 == 1))/sum(x2 == 1)-1.36/sqrt(sum(x2 == 1)),'r--', 'linewidth', 2);
% axis([0 1 0 1]);
end