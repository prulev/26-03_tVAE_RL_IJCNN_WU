function plotSpikes(index, spikes, pos, color, lineWidth)
x = pos*lineUp(1*spikes);
plot(index, x, 'Color',color, 'LineWidth', lineWidth);
% x = spikes*pos;
% for i=1:length(x)
%   plot([index(i)-0.4 index(i)+0.4], [x(i) x(i)], 'Color',color, 'LineWidth', lineWidth);
% end

% x = spikes*pos;
% x(x==0) = nan;
% plot(index, x, "|", "Color",color, "MarkerSize",0.8)
end

function x = lineUp(x)
% change 010 into 111 to line up (If not, 010 can not be seen)
singleIdxes = strfind(x, [0 1 0]);
for i=1:length(singleIdxes)
    x(singleIdxes(i):(singleIdxes(i)+2)) = [1 1 1];
end
% do not plot 0 values
x(x==0)=nan;
end
