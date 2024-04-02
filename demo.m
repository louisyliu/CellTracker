%% Cell Tracker

%% Load image
filename = 'G:\fluorescentCells.nd2';
img = nd2read(filename,1:100); % can't read tif for updated nd2sdkmatlab.

%% Binarize image
% use image binarizer; load \sample\img.mat
% export the image using 'Generate bw'
bwgui(img);

% or export the binarization parameters using 'Generate Para' and uncomment code below
% for batch processing
% bw = bwfun(@(x) getbw(x, bwPara), img);

%% Track particles 
% load sample\bw.mat
[traj] = trackbw(bw);
trajFiltered = trajfilter(traj, 50);

%% Visualize trajectories
movie = trajmovie(trajFiltered, bw);
implay(movie);