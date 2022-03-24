%% Loading image
addpath(('E:\exp_script\GitProject\nd2sdk'));
addpath(genpath('E:\exp_script\GitProject\imageJfilter'))
% % filename = 'E:\exp_script\GitProject\sample\ofandsinglecelltracking_highdensity\20Xsinglecelltracking30ms20fps10s.nd2';
filename = 'E:\exp_script\GitProject\sample\ofandsinglecelltracking_highdensity\20Xsinglecelltracking30ms20fps10s.nd2';
img = nd2read(filename,1:100);
% ima = img(500:1500, 500:1500,:);
% imshow(im,[])

%% Binarization
imgbw = false(size(img));
nImg = size(img,3);
ppm = ParforProgressbar(nImg,'showWorkerProgress', true);
parfor i= 1:nImg
    im1 = img(:,:,i);
    [finalImg, ~] = bandpassfilt(im1,0,6);
    bw = imbinarize(imgaussfilt(finalImg,1),'adaptive');
    bw = bwareaopen(bw, 8);
    %     imshow(bw2);
    imgbw(:,:,i) = bw;
    ppm.increment();
%     dispbar(i, nImg);
end