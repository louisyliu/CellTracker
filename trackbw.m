function traj = trackbw(imgbw, maxDistAllowed, features, featureWeight)
%   TRACKING(imgbw, maxDistAllowed, features, featureWeight) finds the
%   trajectories of binarized particle in [imgbw].  The maximum allowed
%   displacement is specified in [maxDistAllowed] (unit: px; 20 px by
%   default).  Some features can be taken into account in {features}
%   weighting in the list of [featureWeight].
%
%   Available features include 'Area', 'MajorAxisLength'.

if nargin < 3
    features = {};
    featureWeight = [];
end
if nargin == 1
    maxDistAllowed = 20; % px
end

disptitle('Extracting features');
[ccFeatures] = extractfeat(imgbw);
disptitle('Matching trajectories');
matchedTraj = matchtraj(ccFeatures, features, featureWeight, maxDistAllowed);
disptitle('Linking trajectories');
trajOnBorderMat = linktraj(matchedTraj);
disptitle('Filtering traj on border');
trajMat = linkborder(trajOnBorderMat, ccFeatures);
disptitle('Building trajectories');
traj = buildtraj(trajMat, ccFeatures);
disptitle('Done!');

end