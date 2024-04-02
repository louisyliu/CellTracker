function matchedGap = matchgap(traj, features, featureWeight, maxGapAllowed, maxTimeGap)
% MATCHGAP Matches the gaps between trajectories based on distance and time criteria.
%   MATCHGAP filters the trajectory gaps based on a maximum allowed distance and
%   a maximum time interval. It matches the end of one trajectory to the start of
%   another trajectory if the gap between them satisfies the specified criteria.
%
%   Inputs:
%   - traj: A cell array of trajectories, where each cell represents a trajectory
%           and contains a struct with fields 'Centroid' and 'Frame'.
%   - features: A cell array of strings specifying the features to be considered
%               for gap matching. Default is an empty cell array.
%   - featureWeight: A vector of weights corresponding to each feature in the
%                    'features' array. Default is an empty vector.
%   - maxGapAllowed: Maximum allowed distance (in pixels) between the end of one
%                    trajectory and the start of another trajectory for gap matching.
%                    Default is 10 pixels.
%   - maxTimeGap: Maximum allowed time interval (in frames) between the end of one
%                 trajectory and the start of another trajectory for gap matching.
%                 Default is 2 frames.
%
%   Output:
%   - matchedGap: An N x 2 matrix, where N is the number of trajectory gaps that
%                 meet the requirements for gap closing. Each row of 'matchedGap'
%                 represents a pair of matched trajectories, with the first column
%                 indicating the index of the trajectory ending and the second
%                 column indicating the index of the trajectory starting.
%
%   'matchedGap' will be an N x 2 matrix, where N is the
%   number of matched trajectory gaps. Each row represents a pair of matched
%   trajectories, with the first column indicating the index of the trajectory
%   ending and the second column indicating the index of the trajectory starting.
%
%   The 'matchedGap' output can be interpreted as follows:
%       matchedGap = [1 10; 12 13] means
%       traj end | traj start
%       traj # 1 --> 10
%       traj # 12 --> 13
%
%   Note: If there are no trajectory gaps that satisfy the specified criteria,
%         'matchedGap' will be an empty matrix.

if nargin < 5
    maxTimeGap = 2; % frame
end
if nargin < 4
    maxGapAllowed = 10; % px
end
if nargin < 2
    features = {};
    featureWeight = [];
end

nFeatures = length(features);
nTraj = length(traj);
distGap = zeros(nTraj);
frameGap = distGap;

trajStart = cellfun(@(x) x(1), traj);
trajEnd = cellfun(@(x) x(end), traj);
coordStart = cat(1, trajStart.Centroid);
coordEnd = cat(1, trajEnd.Centroid);
frameStart = cat(1, trajStart.Frame);
frameEnd = cat(1, trajEnd.Frame);

for iTraj = 1:nTraj
    distGap(iTraj, :) = vecnorm(coordEnd(iTraj,:)-coordStart, 2, 2)';
    frameGap(:, iTraj) = frameStart(iTraj)-frameEnd;
end
mask = distGap>maxGapAllowed | frameGap>maxTimeGap | frameGap<=0;
distGap(mask) = inf;

% prevent error by the stationary points
if ~any(distGap(~mask))
    distGap(~mask) = 1;
end

if all(distGap(~mask) == inf)
    matchedGap = [];
    return
end

% penalty matrix
penalty = zeros([size(distGap) nFeatures]);
for iFeat = 1:nFeatures
    penalty(:,:,iFeat) = getpenalty(trajStart,trajEnd, features{iFeat}, featureWeight(iFeat));
end

penalty(repmat(mask, 1, 1, nFeatures)) = 0;
P = 1+sum(penalty,3);
cost = (distGap.*P).^2; % get cost matrix
costUnmatchd = max(cost(cost~=inf))*1.05;
matchedGap = matchpairs(cost, costUnmatchd);
end