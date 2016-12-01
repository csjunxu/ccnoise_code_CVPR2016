clear;
TT_Original_image_dir = 'C:\Users\csjunxu\Desktop\CVPR2017\cc_Results\Real_NoisyImage\';
TT_fpath = fullfile(TT_Original_image_dir, '*.png');
% TT_Original_image_dir = 'C:\Users\csjunxu\Desktop\CVPR2017\cc_Results\Real_ccnoise_denoised_part\';
% TT_fpath = fullfile(TT_Original_image_dir, '*real.png');
TT_im_dir  = dir(TT_fpath);
im_num = length(TT_im_dir);
iCovs = cell(im_num,1);
load C.mat;
for i = 1:im_num
    IMin = im2double(imread(fullfile(TT_Original_image_dir, TT_im_dir(i).name)));
    S = regexp(TT_im_dir(i).name, '\.', 'split');
    IMname = S{1};
    fprintf('%s : \n',IMname);
    disp('Calculating noise level...');
    % np = estimate_ccnoise('train/', 'deploy.prototxt', 'demo_iter_100000.caffemodel', img);
    %     if 1<=i<=11
    %         np = estimate_ccnoise('train/', 'deploy.prototxt', '5dmark3_iso3200.caffemodel', IMin);
    %     elseif 12<=i<=17
    %         np = estimate_ccnoise('train/', 'deploy.prototxt', 'd600_iso3200.caffemodel', IMin);
    %     elseif 18<=i<=29
    %         np = estimate_ccnoise('train/', 'deploy.prototxt', 'd800_iso1600.caffemodel', IMin);
    %     elseif 30<=i<=56
    %         np = estimate_ccnoise('train/', 'deploy.prototxt', 'd800_iso3200.caffemodel', IMin);
    %     else
    %         np = estimate_ccnoise('train/', 'deploy.prototxt', 'd800_iso6400.caffemodel', IMin);
    %     end
    %     Covs{i,1} = np;
    %     save C.mat Covs;
    np = Covs{i,1};
    [h,w,ch] = size(np);
    inp = zeros(h,w,ch);
    disp('The covariance matrix of (1, 1)')
    disp([np(1, 1, 1), np(1, 1, 4), np(1, 1, 5);
        np(1, 1, 4), np(1, 1, 2), np(1, 1, 6);
        np(1, 1, 5), np(1, 1, 6), np(1, 1, 3)]);
    for hh = 1:h
        for ww=1:w
            hwnp = [np(hh, ww, 1), np(hh, ww, 4), np(hh, ww, 5);
                np(hh, ww, 4), np(hh, ww, 2), np(hh, ww, 6);
                np(hh, ww, 5), np(hh, ww, 6), np(hh, ww, 3)];
            ihwnp = inv(hwnp);
            inp(hh, ww, :) = [ihwnp(1,1) ihwnp(2,2) ihwnp(3,3) ihwnp(2,1) ihwnp(3,1) ihwnp(3,2)];
        end
    end
    iCovs{i,1} = inp;
    save invC.mat iCovs;
end




% The estimated covariance matrices must be positive definite
%
% icov = zeros(size(np));
% for i = 1:size(np, 1)
%     for j = 1:size(np, 1)
%          c = [np(i, j, 1), np(i, j, 4), np(i, j, 5);
%              np(i, j, 4), np(i, j, 2), np(i, j, 6);
%              np(i, j, 5), np(i, j, 6), np(i, j, 3)];
%          % Sigma^(-1)
%          c = inv(c);
%          % Repair covariance matrix to positive definite
%          [V, D] = eig(c);
%          D = diag(max(diag(D), 10e-4));
%          c = V * D * V';
%          icov(i, j, :) = [c(1), c(5), c(9), c(2), c(3), c(6)];
%     end
% end