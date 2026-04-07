function smoothedSignal = gaussianSmooth(signal,kernelSize)
%Smooth the signal with gaussian kernel
%   INPUT:
%       signal          - signal to be smoothed
%       kernelSize      - gaussian kernel size. Length of 1 sigma
%   OUTPUT:
%       smoothedSignal  - smoothed signal

% % Warning for upgrade the code
% warning('This functions should be deprecated. Carefully check the comments.')
% % Suggestions: 
% %       use `smoothdata(signal, 'gaussian', 5*kernelSize+1)`.
% %       This only has minor differences at the tail of ditributions (5-sigma(new) vs 6-sigma(old))
% % Reason: 
% %       This function cannot treat the first and last elements well. The 
% %       input signal will be padded with zeros before and after the signal, 
% %       which is not desired in most cases.
% 
% % Get Gaussian kernel
% kernel=normpdf(linspace(-3,3,6*kernelSize+1),0,1); % take values from 3 sigma region
% kernel = kernel/sum(kernel);
% % smooth
% smoothedSignal = conv(signal, kernel, 'same');

smoothedSignal = smoothdata(signal, 'gaussian', 5*kernelSize+1);
end
