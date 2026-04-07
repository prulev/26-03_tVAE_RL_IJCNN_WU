figure(1)
%% all latent
plotIndexes = 1:3e3;
for i=1:opt.latent_dim
    subplot(7,opt.latent_dim,i);
    plot(batchM1_latent(i,plotIndexes), 'k'); hold on
    fill([plotIndexes, fliplr(plotIndexes)], ...
      [ ...
        batchM1_latent(i,plotIndexes)-3*batchM1_latent_std(i,plotIndexes), ...
        fliplr(batchM1_latent(i,plotIndexes)+3*batchM1_latent_std(i,plotIndexes)) ...
      ], ...
      'k', 'faceAlpha', 0.2, 'EdgeAlpha',0)
    
    plot(M1_latent_pre(i,plotIndexes), 'r'); 
%     fill([plotIndexes, fliplr(plotIndexes)], ...
%       [ ...
%         latent_pre(i,plotIndexes)-3*exp(0.5*log_var_pre(i,plotIndexes)), ...
%         fliplr(latent_pre(i,plotIndexes)+3*exp(0.5*log_var_pre(i,plotIndexes))) ...
%       ], ...
%       'r', 'faceAlpha', 0.2, 'EdgeAlpha',0)

    hold off;
end

%% movements
subplot(7,1,2);
motor_perform_temp = motor_perform(plotIndexes);
motor_perform_temp(batchActions(plotIndexes)==0) = 0;
temp = motor_perform_temp;
temp(temp==2) = 0;
temp(temp==1) = 0;
temp(temp==3) = 1;
high = area(temp);
high.FaceColor = 'r';
hold on 
temp = motor_perform_temp;
temp(temp==3) = 0;
temp(temp==1) = 0;
temp(temp==2) = 1;
low = area(temp);
low.FaceColor = 'y';
hold on 
temp = motor_perform_temp;
temp(temp==2) = 0;
temp(temp==3) = 0;
rest = area(temp);
rest.FaceColor = 'b';

temp = batchActions(plotIndexes);
temp(temp==2) = nan;
temp(temp==1) = nan;
temp(temp==0) = nan;
temp(temp==3) = 1.5;
plot(temp, 'r', 'LineWidth', 8);
temp = batchActions(plotIndexes);
temp(temp==3) = nan;
temp(temp==1) = nan;
temp(temp==0) = nan;
temp(temp==2) = 1.5;
plot(temp, 'y', 'LineWidth', 8);
temp = batchActions(plotIndexes);
temp(temp==3) = nan;
temp(temp==2) = nan;
temp(temp==0) = nan;
temp(temp==1) = 1.5;
plot(temp, 'b', 'LineWidth', 8);
hold off
% ylim([0 2])
legend([high low rest], {'high', 'low', 'rest'})
hold on
plot(smoothed_reward(plotIndexes))
hold off
%% loss
subplot(7,2,5); 
yyaxis left; plot(sl_loss_His(1:episode)); ylabel('NLL'); 
yyaxis right; plot(rewardHis(1:episode)); ylabel('reward')

subplot(7,2,6); 
yyaxis left; plot(sl_loss_TestHis(1:episode)); ylabel('NLL'); 
yyaxis right; plot(rewardTestHis(1:episode)); ylabel('reward')

%% weight
subplot(7,1,4); histogram(weights);
% subplot(4,2,8); histogram(weights_std);
drawnow;

%% neural predictions
for i=1:size(data.M1, 1)
  subplot(7,3,i+12)
  plot(pOutput(i, 1:3000), 'r'); hold on
  plot(gaussianSmooth(batchM1_truth(i, 1:3000), 10), 'k'); hold off
end

%% test latent
figure(2)
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
