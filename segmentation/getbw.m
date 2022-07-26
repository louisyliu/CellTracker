function bw = getbw(img, varargin)
%GETBW binarizes fluorescent movie for single-cell tracking.
%   BW = GETBW(IMG, BWPARA) first applies bandpass filter with the same
%   algorithm with bandpass filter in imageJ.  The filtered image is further
%   filtered by a Gaussian filter and finally thresholded with adaptive
%   binarization.

if nargin == 1
    [bwPara.areaopenSize, bwPara.bpmin, bwPara.bpmax, bwPara.gaussSigma] = deal(8, 0, 6, 1.5);
elseif nargin == 2
    bwPara = varargin{1};
else
    error('Number of input arguments is out of range.');
end
[bpimg, ~] = bandpassfilt(img, bwPara.bpmin, bwPara.bpmax);
bw = imbinarize(imgaussfilt(bpimg, bwPara.gaussSigma), 'adaptive');
bw = bwareaopen(bw, bwPara.areaopenSize);
end