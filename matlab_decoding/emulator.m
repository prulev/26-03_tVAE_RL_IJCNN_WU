function [success,rate,motor_perform,ensemble,y] = emulator(spikes,motor_expect,indexes,his,modelName)
if size(motor_expect, 1) ~= 1
  motor_expect = motor_expect';
end
if size(spikes, 1) > size(spikes, 2)
  spikes = spikes';
end
%% rearrange M1 order
[~,I] = sort(indexes);
spikes = spikes(I,:);
%% get M1 spike ensemble
M1num = size(spikes,1);
ensemble = zeros((his+1)*M1num,length(spikes));
for i=0:his
    ensemble(i*M1num+1:(i+1)*M1num,:) = [zeros(M1num,i) spikes(:,1:(end-i))];
end
%% feedforward to get behavior
% use a variable instead of hard coding of decoding model name
y = eval([modelName, '(ensemble)']);
motor_perform = vec2ind(y);
%% get reward
% success = double(motor_perform==motor_expect);
% rate = sum(success(motor_expect>0))/length(success(motor_expect>0)); % only consider 3 movements
success = double(motor_perform==motor_expect);
success(motor_expect==0) = nan; % only consider 3 movements
rate = sum(success(~isnan(success)))/length(success(~isnan(success)));
end
