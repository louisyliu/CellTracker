% Cell Tracker

%% Load image
filename = 'G:\exp_script\GitProject\sample\ofandsinglecelltracking_highdensity\20Xsinglecelltracking30ms20fps10s.nd2';
img = nd2read(filename,1:10); % can't read tif for updated nd2sdkmatlab.

%% Binarize image
% use image binarizer
% export the image using 'Generate bw'
% bwgui1(img);

% or export the binarization parameters using 'Generate Para' and commented code below
bw = bwfun(@(x) getbw(x, bwPara), img);

%% Track particles
traj = tracking(bw);
% trajFiltered = trajfilter(traj, 10);

%% Visualize trajectories
movie = trajmovie(trajFiltered, bw);
implay(movie);
