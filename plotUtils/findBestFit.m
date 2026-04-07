%% find best fit
function [bestStart, bestEnd] = findBestFit(data, fitResult, movements, T)
    % 计算误差平方和
    errorSq = (data - fitResult).^2;
    
    % 初始化最小误差平方和为无穷大
    minErrorSqSum = inf;
    bestStart = 0;
    bestEnd = 0;
    
    % 遍历所有可能的子串
    for i = 1:500:length(data) - T + 1
        % 计算当前子串的误差平方和
        currentErrorSqSum = sum(errorSq(i:i+T-1));

        % 如果单双杆不平均则放弃
        if sum(movements(i:i+T-1)==2) / sum(movements(i:i+T-1)==3) < 0.5 || ...
          sum(movements(i:i+T-1)==2) / sum(movements(i:i+T-1)==3) > 1.5
          continue;
        end

        % 如果当前子串的误差平方和小于最小误差平方和，则更新最小误差平方和和最佳子串的开始和结束索引
        if currentErrorSqSum < minErrorSqSum
            minErrorSqSum = currentErrorSqSum;
            bestStart = i;
            bestEnd = i + T - 1;
        end
    end
end