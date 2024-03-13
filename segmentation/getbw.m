function img = getbw(img, bwPara)
%GETBW binarizes fluorescent movie for single-cell tracking.
%   BW = GETBW(IMG, BWPARA) first applies bandpass filter with the same
%   algorithm with bandpass filter in imageJ.  The filtered image is further
%   filtered by a Gaussian filter and finally thresholded with adaptive
%   binarization.

if bwPara.invert
    img = imcomplement(img);
end

if bwPara.isbp
    [img, ~] = bandpassfilt(img, bwPara.bpmin, bwPara.bpmax);
end
if bwPara.gaussSigma ~= 0
    img = imgaussfilt(img, bwPara.gaussSigma);
end
if bwPara.binarize
    img = imbinarize(img, 'adaptive', 'ForegroundPolarity','bright', 'Sensitivity',bwPara.sensitivity);
    img = bwareaopen(img, bwPara.areaopenSize);
end

end