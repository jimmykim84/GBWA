% 用导向滤波+分块加权来提取源相机检测中所需指纹
% 版权说明：本代码基于Jessica团队的开源成果修改而来：
% http://dde.binghamton.edu/download/camera_fingerprint/
% 请遵守原代码中注明的的版权要求，并请应用原文献。
% 如此代码对您有所帮助，请引用 
% Le-bing Zhang, Fei Peng, Min Long, 'Identifing source camera using guided image estimation and block weighted average’, JVCIR, doi:http://dx.doi.org/10.1016/j.jvcir.2016.12.013

% 
clc,clear,
% 用NCC度量相片指纹和相机指纹间的相关性
load Sample/Fingerprint_Canon_Ixus55_1024_refGIF.mat;
Fingerprint_Canon_Ixus55 = Fingerprint;

[Mf,Nf] = size(Fingerprint);

%%%%%%%%%%%%%%%%%%%%%%%%%
Flist = dir('Sample\*.jpg');
for i = 1:4
    i,
%%%
imx = ['Sample\',Flist(i).name];
Ix = imread(imx);
[M,N,tree] = size(Ix);
Ix = Ix((floor(M/2)-(Mf/2)+1:floor(M/2)+(Mf/2)),(floor(N/2)-(Nf/2)+1:floor(N/2)+(Nf/2)),:);
 %%%
 Noisex = NoiseExtractFromImage_GIF(Ix);
 Noisex = WienerInDFT(Noisex,std2(Noisex));
 %%%
 C(i) = COR(Noisex,Fingerprint_Canon_Ixus55);
end

