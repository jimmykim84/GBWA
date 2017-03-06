% 版权说明：本代码基于Jessica团队的开源成果修改而来：
% http://dde.binghamton.edu/download/camera_fingerprint/
% 请遵守原代码中注明的的版权要求，并请应用原文献。
% 如此代码对您有所帮助，请引用 
% Le-bing Zhang, Fei Peng, Min Long, 'Identifing source camera using guided image estimation and block weighted average’, JVCIR, doi:http://dx.doi.org/10.1016/j.jvcir.2016.12.013
%

function RP = getFingerprint_BWA2016(Images) 
database_size = length(Images);  % Number of the images  
M0 = 512; 
sigma = 3;
     
t=0; 
for i=1:database_size
    SeeProgress(i),
    im = Images(i).name;
    X = double(imread(im)); 
    [Mn,Nn,three]=size(X); 
    X = X((floor(Mn/2)-(M0/2)+1:floor(Mn/2)+(M0/2)),(floor(Nn/2)-(M0/2)+1:floor(Nn/2)+(M0/2)),:); 
    % 只裁剪出中心 M0*M0 区域 
   
    %%%   Initialize 
    if t==0
        [M,N,three]=size(X);
        height = M/2; 
        width = N/2;       
        max_row = floor(M/height); % 整幅图像分成多少块
        max_col = floor(N/width);
        segRPsum = cell(max_row,max_col,three);
        segNN = cell(max_row,max_col,three);
        segIm = cell(max_row,max_col,three);
 
        for j = 1:3
            for row = 1:max_row
                for col = 1:max_col
                    segRPsum{row,col,j}=zeros(height,width,'single');
                    segNN{row,col,j}=0;
                    segIm{row,col,j}=zeros(height,width,'single');
                    segImNoiseVar(row,col,j)=0;
                end
            end
        end
        % Initialize sum
        for j=1:3  
            RPsum{j}=zeros(M,N,'single');           
        end
    else    
    end
    t=t+1;    
    for j=1:3
        %%% GIF滤波代替小波滤波
        X2 = imguidedfilter(X(:,:,j)/255,X(:,:,j)/255,'NeighborhoodSize',3);
        I3 = X(:,:,j) - X2 * 255;
        ImNoise = single(WienerNoise_BWA(I3,sigma^2)); % 得到单幅的SPN 
        %%% 分块加权
        for row = 1:max_row
            for col = 1:max_col
                segIm(row,col,j)= {ImNoise((row-1)*height+1:row*height,(col-1)*width+1:col*width)};
                segImNoiseVar(row,col,j) = var(segIm{row,col,j}(:));
                if var(segIm{row,col,j}(:)) == 0
                   segNN{row,col,j} = segNN{row,col,j} +0;
                else
                    segNN{row,col,j} = segNN{row,col,j} + 1/segImNoiseVar(row,col,j);
                end
                if isnan(segIm{row,col,j}/segImNoiseVar(row,col,j))
                    segRPsum{row,col,j} =  segRPsum{row,col,j}+zeros(height,width,'single');
                elseif isinf( segIm{row,col,j}/segImNoiseVar(row,col,j))
                    segRPsum{row,col,j} =  segRPsum{row,col,j}+zeros(height,width,'single');
                else
                    segRPsum{row,col,j} = segRPsum{row,col,j}+ segIm{row,col,j}/segImNoiseVar(row,col,j);
                end
            end
        end
    end
end
clear ImNoise Inten X I3  X2 %segIm segImNoiseVar

%%% 重建组合
for j =1:3
    comboIm = zeros(M,N);
    for row=1:max_row
        for col=1:max_col
            blocks{row,col,j} = segRPsum{row,col,j}./ segNN{row,col,j};
            comboIm((row-1)*height+1:row*height,(col-1)*width+1:col*width)=blocks{row,col,j};
        end
    end
    RPsum{j} = comboIm;
end
clear blocks comboIm segRPsum segNN

RP = cat(3,RPsum{1},RPsum{2},RPsum{3});
% Remove linear pattern and keep its parameters
[RP2,LP] = ZeroMeanTotal(RP);
RP = single(RP);                   


