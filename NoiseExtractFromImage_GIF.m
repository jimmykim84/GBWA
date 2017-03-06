% 版权说明：本代码基于Jessica团队的开源成果修改而来：
% http://dde.binghamton.edu/download/camera_fingerprint/
% 请遵守原代码中注明的的版权要求，并请应用原文献。
% 如此代码对您有所帮助，请引用 
% Le-bing Zhang, Fei Peng, Min Long, 'Identifing source camera using guided image estimation and block weighted average’, JVCIR, doi:http://dx.doi.org/10.1016/j.jvcir.2016.12.013
%%%

function Noise = NoiseExtractFromImage_GIF(image) 
% imguidedfilter Matlab 2014自带函数

if ischar(image), X = imread(image); else X = image; clear image, end
[M0,N0,three]=size(X);
X = double(X); 

NoiseVar = 9;
if three~=3,
    X2 = imguidedfilter(X/255,X/255,'NeighborhoodSize',3);
    I3 = X - X2*255;
    Noise = WienerNoise_BWA(I3,NoiseVar); % sigma =3;NoiseVar = sigma^2;
else
    Noise = zeros(size(X));
    for j=1:3
        X2 = imguidedfilter(X(:,:,j)/255,X(:,:,j)/255,'NeighborhoodSize',3);
        I3 = X(:,:,j) - X2*255;
        Noise(:,:,j) = WienerNoise_BWA(I3,NoiseVar);
    end
    Noise = rgb2gray1(Noise);  
end
    Noise = ZeroMeanTotal(Noise);
    Noise = single(Noise);
end
