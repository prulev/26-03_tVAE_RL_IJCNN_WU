function cliped_mse = cliped_MSE(target, target_std, predict, a)

diff = abs(predict - target) - a*target_std;

diff(diff<0) = 0;

cliped_mse = mean(diff.^2);

end
