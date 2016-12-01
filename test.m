clear;
TT_Original_image_dir = 'C:\Users\csjunxu\Desktop\CVPR2017\cc_Results\Real_NoisyImage\';
TT_fpath = fullfile(TT_Original_image_dir, '*.png');
% TT_Original_image_dir = 'C:\Users\csjunxu\Desktop\CVPR2017\cc_Results\Real_ccnoise_denoised_part\';
% TT_fpath = fullfile(TT_Original_image_dir, '*real.png');
TT_im_dir  = dir(TT_fpath);
im_num = length(TT_im_dir);
load ccnoise-master/invC.mat
for i = 1:im_num
    IMin = im2double(imread(fullfile(TT_Original_image_dir, TT_im_dir(i).name)));
    S = regexp(TT_im_dir(i).name, '\.', 'split');
    IMname = S{1};
    fprintf('%s : \n',IMname);
    Options.kernelratio     = 3;
    Options.windowratio  = 21;
    Options.verbose         = true;
    Options.filterstrength = 0.1;
    Options.nThreads       = 8;
    Options.blocksize       = 128;
    Options.icov               = iCovs{i,1};
    IMout=NLMF(IMin,Options);
    imwrite(IMout, ['CCNoise_' IMname '.png']);       
%     figure,
%     subplot(1,2,1),imshow(IMin); title('Noisy image')
%     subplot(1,2,2),imshow(IMout); title('NL-means image');
end