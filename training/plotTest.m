%% test latent
figure(3)
plotIndexes = 1:4e3;
for i=1:opt.latent_dim
    subplot(6,2,i);
    plot(M1_latent_test(i,plotIndexes), 'k'); hold on
    fill([plotIndexes, fliplr(plotIndexes)], ...
      [ ...
        M1_latent_test(i,plotIndexes)-3*M1_latent_std_test(i,plotIndexes), ...
        fliplr(M1_latent_test(i,plotIndexes)+3*M1_latent_std_test(i,plotIndexes)) ...
      ], ...
      'k', 'faceAlpha', 0.2, 'EdgeAlpha',0)
    
    plot(M1_latent_pre_test(i,plotIndexes), 'r'); 
%     fill([plotIndexes, fliplr(plotIndexes)], ...
%       [ ...
%         latent_pre(i,plotIndexes)-3*exp(0.5*log_var_pre(i,plotIndexes)), ...
%         fliplr(latent_pre(i,plotIndexes)+3*exp(0.5*log_var_pre(i,plotIndexes))) ...
%       ], ...
%       'r', 'faceAlpha', 0.2, 'EdgeAlpha',0)

    hold off;
end

%% test movements
subplot(6,1,3);
motor_perform_temp = motor_perform_test(plotIndexes);
motor_perform_temp(testActions(plotIndexes)==0) = nan;
temp = motor_perform_temp;
temp(temp==2) = nan;
temp(temp==1) = nan;
temp(temp==3) = 0.5;
high = plot(temp, 'r', 'LineWidth', 8);
hold on 
temp = motor_perform_temp;
temp(temp==3) = nan;
temp(temp==1) = nan;
temp(temp==2) = 0.5;
low = plot(temp, 'y', 'LineWidth', 8);
hold on 
temp = motor_perform_temp;
temp(temp==2) = nan;
temp(temp==3) = nan;
temp(temp==1) = 0.5;
rest = plot(temp, 'b', 'LineWidth', 8);

temp = testActions(plotIndexes);
temp(temp==2) = nan;
temp(temp==1) = nan;
temp(temp==0) = nan;
temp(temp==3) = 1.5;
plot(temp, 'r', 'LineWidth', 8);
temp = testActions(plotIndexes) ;
temp(temp==3) = nan;
temp(temp==1) = nan;
temp(temp==0) = nan;
temp(temp==2) = 1.5;
plot(temp, 'y', 'LineWidth', 8);
temp = testActions(plotIndexes);
temp(temp==3) = nan;
temp(temp==2) = nan;
temp(temp==0) = nan;
temp(temp==1) = 1.5;
plot(temp, 'b', 'LineWidth', 8);
hold off
ylim([0 2])
legend([high low rest], {'high', 'low', 'rest'}, "Orientation","horizontal")

clearvars temp

%% test neural activity
for i=1:size(data.M1, 1)
  subplot(6,3,i+9)
  plot(pOutputTest(i, 1001:4000), 'r'); hold on
  plot(gaussianSmooth(testM1_truth(i, 1001:4000), 10), 'k'); hold off
end
