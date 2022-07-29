% divide tracking function 

features = {};
featureWeight = [];
maxDistAllowed = 20; % px

[ccFeatures, nCC] = extractfeat(imgbw);
cost = getcostmatrix(ccFeatures, nCC );
trajMat = linktraj(matchedTraj);
trajAll = buildtraj(trajMat, ccFeatures);
traj = filtertrajonborder(trajAll);

%%
a = trajmovie(traj, imgbw);