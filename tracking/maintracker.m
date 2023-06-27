% divide tracking function 

features = {};
featureWeight = [];
maxDistAllowed = 20; % px

[ccFeatures] = extractfeat(imgbw);
matchedTraj = matchtraj(ccFeatures);
trajOnBorderMat = linktraj(matchedTraj);
trajMat = linkborder(trajOnBorderMat, ccFeatures);
traj = buildtraj(trajMat, ccFeatures);
% traj = filtertrajonborder(trajAll);

%%
a = trajmovie(traj, imgbw);

%% gap closing
matchedGap = matchgap(traj);
linkedGapMat = combinegap(matchedGap);
trajLinkedMat = linkgap(trajMat, linkedGapMat);
trajGapClosed = buildtraj(trajLinkedMat, ccFeatures);

%%
b = trajmovie(trajGapClosed(5), imgbw);
implay(b)
