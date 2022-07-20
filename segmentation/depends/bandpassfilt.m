function [finalImg, filter] = bandpassfilt(varargin)
%BANDPASSFILT Performs bandpass filtering.
%   finalImg = BANDPASSFILT(originImg, filterSmall, filterLarge)
%   filters the originImg in the frequency domain using the
%   bandpass Gaussian fitler, which filters the small structure
%   up to the diameter of filterSmall, and the larger structure
%   beyond the diameter of filterLarge.
%
%   filterSmallDia = 3 and filterLargeDia = 40 by default.
%   finalImg is of the same size and class as the originImg.

switch nargin 
    case 1
        originImg = varargin{1};
        filterSmallDia = 3;
        filterLargeDia = 40;
        saturateImg = 0;
    case 3
        originImg = varargin{1};
        filterSmallDia = varargin{2};
        filterLargeDia = varargin{3};
        saturateImg = 0;
    case 4
        originImg = varargin{1};
        filterSmallDia = varargin{2};
        filterLargeDia = varargin{3};
        saturateImg = varargin{4};
    otherwise
        error('Unavilable number of input')
end

% Tile mirrored image to power of 2 size. First determine
% smallest power 2 >= 2 * image width/height. The factor of
% 1.5 to avoid wrap-around effects of Fourier Transform.
[originImg, revertClass] = tofloat(originImg);
PQ = paddedsize(size(originImg), 'PWR2');
[M,N] = size(originImg);
enlargeSize = PQ(1);

% Calculate the inverse of the 1/e frequencies for large and
% small structures. 
filterLarge = 2*filterLargeDia/enlargeSize;
filterSmall = 2*filterSmallDia/enlargeSize;

% Put image into power 2 size image
enlargeImg = padarray(originImg,[floor((enlargeSize-M)/2),floor((enlargeSize-N)/2)],'symmetric');

% Transform forward
F = fft2(enlargeImg);

% Filter small and large structure.
scaleLarge = filterLarge^2;
scaleSmall = filterSmall^2;
[U, V] = dftuv(size(F,1), size(F,2));
D = hypot(U,V);
factLarge = exp(-D.^2*scaleLarge);
factSmall = exp(-D.^2*scaleSmall);
filter = (1 - factLarge).*factSmall;

% Crop to original size and do scaling. 
finalImg = ifft2(F.*filter);
finalImg = finalImg(floor((enlargeSize-M)/2)+1:floor((enlargeSize-M)/2)+M, floor((enlargeSize-N)/2)+1:floor((enlargeSize-N)/2)+N);
finalImg = mat2gray(finalImg);

if saturateImg
    finalImg = imadjust(finalImg);
end
finalImg = revertClass(finalImg);
end
