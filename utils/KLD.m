function kld = KLD(mu, log_var, mu_target, log_var_target)
%KLD KL-divergence

kld = -0.5 * mean( ...
  1 + log_var - log_var_target - exp(log_var) ./ exp(log_var_target) - (mu - mu_target).^2 ./ exp(log_var_target), ...
  "all"...
  );

end

