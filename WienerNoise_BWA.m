function [tc, coefVar]=WienerNoise_BWA(coef,NoiseVar)
%Input: 
%   coef:          Wavelet detailed coefficient at certain level
%   NoiseVar:      Variance of the additive noise
%Output:
%   tc:            Extracted noise coefficient

% Estimate the variance of original noise-free image for each wavelet
tc = coef.^2;
coefVar = Threshold(filter2(ones(3,3)/(3*3), tc), NoiseVar);
% Wiener filter like attenuation
tc = coef.*NoiseVar./(coefVar+NoiseVar);