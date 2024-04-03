function [traj] = trackbw(imgbw, maxDistAllowed, maxAreaChangedAllowed, features, featureWeight, performGapClosing, maxGapAllowed, maxTimeGap)
% TRACKBW Tracks the trajectories of binarized particles in an image sequence.
%   TRACKBW finds the trajectories of binarized particles in the input image
%   sequence [imgbw]. It performs feature extraction, trajectory matching, linking,
%   filtering, and gap closing (if specified) to construct the final trajectories.
%
%   Inputs:
%   - imgbw: A binary image sequence representing the particles to be tracked.
%   - maxDistAllowed: Maximum allowed displacement (in pixels) between consecutive
%                     frames for trajectory matching. Default is 20 pixels.
%   - maxAreaChangedAllowed: Maximum allowed relative area change between consecutive
%                     frames for trajectory matching. Set to a positive value to
%                     enable area change filtering. Default is -1, which
%                     disables this feature.  
%   - features: A cell array of strings specifying the features to be considered
%               for trajectory matching and gap closing. Available features include
%               'Area' and 'MajorAxisLength'. Default is an empty cell array {}.
%   - featureWeight: A vector of weights corresponding to each feature in the
%                    'features' array. Default is an empty vector [].
%   - performGapClosing: A logical flag indicating whether to perform gap closing
%                        after trajectory linking. Default is false.
%   - maxGapAllowed: Maximum allowed distance (in pixels) for gap closing. Default
%                    is 10 pixels.
%   - maxTimeGap: Maximum allowed time gap (in frames) for gap closing. Default is
%                 2 frames.
%
%   Output:
%   - traj: A cell array of trajectories, where each cell represents a trajectory
%           and contains a struct with fields 'Centroid' (particle centroid coordinates)
%           and 'Frame' (corresponding frame number).


if nargin < 8
    maxTimeGap = 2; % frame
end
if nargin < 7
    maxGapAllowed = 10; % px
end
if nargin < 6
    performGapClosing = false;
end
if nargin < 4
    features = {};
    featureWeight = [];
end
if nargin < 3
    maxAreaChangedAllowed = -1;
end
if nargin == 1
    maxDistAllowed = 20; % px
end

if  performGapClosing && maxGapAllowed > maxDistAllowed
    error('maxGapAllowed must be smaller than maxDistAllowed');
end

disptitle('Extracting features');
[ccFeatures] = extractfeat(imgbw);
disptitle('Matching trajectories');
matchedTraj = matchtraj(ccFeatures, features, featureWeight, maxDistAllowed, maxAreaChangedAllowed);
disptitle('Linking trajectories');
trajOnBorderMat = linktraj(matchedTraj);
disptitle('Filtering traj on border');
trajMat = linkborder(trajOnBorderMat, ccFeatures);
disptitle('Building trajectories');
traj = buildtraj(trajMat, ccFeatures);

if performGapClosing && ~isempty(traj)
    disptitle('Closing gap');
    matchedGap = matchgap(traj, features, featureWeight, maxGapAllowed, maxTimeGap);
    linkedGapMat = combinegap(matchedGap);
    trajLinkedMat = linkgap(trajMat, linkedGapMat);
    traj = buildtraj(trajLinkedMat, ccFeatures);
end
disptitle('Done!');

end