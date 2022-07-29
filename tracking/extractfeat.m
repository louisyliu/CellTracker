function [ccFeatures, nCC] = extractfeat(imgbw)
%EXTRACTFEAT extracts features of binarized images.
%   [ccFeatures, nCC] = EXTRACTFEAT(imgbw) extracts and stores features
%   struct array [Area, Centroid, MajorAxisLength, PixelIdxList] in cell
%   array {ccFeatures}.
%
%   {ccFeatures} is of size N x 1, where N is the total frame number.  The
%   struct in each cell is of size M x 1, where M is the recognized
%   particle number in the frame. 
%   [nCC] is of size N x 1, recording the recognized particle number in the
%   frame (i.e., M).

% ccInfo = {'Area', 'Centroid', 'MajorAxisLength', 'MeanIntensity', 'PixelIdxList'};
ccInfo = {'Area', 'Centroid', 'MajorAxisLength',  'PixelIdxList'}; % feature in bw
time = size(imgbw, 3);
ccFeatures = cell(time, 1);
nCC = zeros(time, 1, 'uint32');
[imgHeight, imgWidth] = size(imgbw,[1 2]);
borderIdxList = [1:imgHeight 1:imgHeight:imgHeight*imgWidth imgHeight:imgHeight:imgHeight*imgWidth imgHeight*imgWidth-imgHeight+1:imgHeight*imgWidth];

for t = 1:time
    bw1 = imgbw(:,:,t);
    %     im1 = img(:,:,t);
    %     ccf = regionprops(bw1, im1, ccInfo);
    ccf = regionprops(bw1, ccInfo);
    pixelIdxList = {ccf.PixelIdxList};
    onBorder = cellfun(@(x) any(ismember(x,borderIdxList)), pixelIdxList,'UniformOutput',false);
    [ccf.OnBorder] = onBorder{:};
    ccFeatures{t} = ccf;
    nCC(t) = length(ccf);
    dispbar(t, time);
end
