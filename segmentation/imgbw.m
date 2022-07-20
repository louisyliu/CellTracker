function bw = imgbw(img, varargin)
%BWIMG binarizes fluorescent movie for single-cell tracking.
%   BW = BWIMG(IMG, ISPARALLEL) first applies bandpass filter with the same
%   algorithm with bandpass filter in imageJ.  The filtered image is further
%   filtered by a Gaussian filter and finally thresholded with adaptive
%   binarization.  

[bpimg, ~] = bandpassfilt(img, 0, 6);
bw = imbinarize(imgaussfilt(bpimg, 1), 'adaptive');
bw = bwareaopen(bw, 8);
end