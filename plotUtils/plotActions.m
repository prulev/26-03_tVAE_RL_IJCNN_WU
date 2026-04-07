function plotActions(index, actions, color, xRange)
temp = selectOneAction(actions, 1);
plot(index, temp, 'Color', color(1,:), 'LineWidth', 12);
hold on;
temp = selectOneAction(actions, 2);
plot(index, temp, 'Color', color(2,:), 'LineWidth', 12);
temp = selectOneAction(actions, 3);
plot(index, temp, 'Color', color(3,:), 'LineWidth', 12);
hold off
ylim([0.8 1.2])
xlim(xRange)
box off
set(gca, 'YColor', 'none')
set(gca, 'XColor', 'none')
set(gca, 'TickLength', [0 0])
end

function x = selectOneAction(actions, a)
x = 1*(actions==a); % pick out one actions
% change 012 into 111 to line up (If not, 012 can not be seen)
singleIdxes = strfind(x, [0 1 0]);
for i=1:length(singleIdxes)
    x(singleIdxes(i):(singleIdxes(i)+2)) = [1 1 1];
end
% do not plot 0 values
x(x==0)=nan;
end