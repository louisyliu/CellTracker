function matchedGap = matchgap(traj, features, featureWeight, maxGapAllowed, maxTimeGap)
%MATCHGAP matches the traj gap. 
%   MATCHGAP fiters the traj gap of distance larger than [maxGapAllowed],
%   of time interval larger than [maxTimeDiff].   
%
%   [matchedGap] is of size N x 2, where N is the traj that meets the
%   requirement for gap closing.  
%
%   E.g., matchedGap = [1 10; 12 13] means 
%               traj end   |    traj start
%        traj #      1    -->     10      
%        traj #     12    -->     13 


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