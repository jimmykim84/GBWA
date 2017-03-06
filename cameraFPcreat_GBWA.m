% 版权说明：本代码基于Jessica团队的开源成果修改而来：
% http://dde.binghamton.edu/download/camera_fingerprint/
% 请遵守原代码中注明的的版权要求，并请应用原文献。
% 如此代码对您有所帮助，请引用 
% Le-bing Zhang, Fei Peng, Min Long, 'Identifing source camera using guided image estimation and block weighted average’, JVCIR, doi:http://dx.doi.org/10.1016/j.jvcir.2016.12.013
%

clear,clc,
% 生成相机指纹
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileList = dir('用你的图像库位置替换\*.jpg');  
for Fi = 1:25
    imx = strcat('用你的图像库位置替换\',FileList(Fi).name);
    Images(Fi).name = imx;
end
RP = getFingerprint_BWA2016(Images);
RP = rgb2gray1(RP);
Fingerprint = WienerInDFT(RP,std2(RP));
save Sample/Fingerprint_Canon_Ixus55_1024_refGIF.mat Fingerprint;

