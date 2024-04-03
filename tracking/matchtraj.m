function matchedTraj = matchtraj(ccFeatures, features, featureWeight, maxDistAllowed, areaChangedThreshold)
%MATCHTRAJ Matches trajectories in consecutive frames.
%   MATCHTRAJ creates cost matrix depending on distance and features to obtain
%   the minimized total cost by solving the linear assignment problem.  It
%   matches trajectories in consecutive frames based on the provided 
%   features and distance criteria.
%
%   Inputs:
%   - ccFeatures: A cell array of size T, where T is the total number of time
%                 steps. Each cell contains a structure with connected component
%                 features for a specific time step.
%   - features: A cell array of strings specifying the features to be considered
%               for trajectory matching. Available choices are 'Area' and
%               'MajorAxisLength'. Default is an empty cell array.
%   - featureWeight: A vector of weights corresponding to each feature in the
%                    'features' array. Default is an empty vector.
%   - maxDistAllowed: Maximum allowed distance (in pixels) between trajectories
%                     in consecutive frames for matching. Default is 20 pixels.
%
%   Output:
%   - matchedTraj: A cell array of size T-1, where each cell stores the info of
%                  particles at time t, indexed in Column 1, linked to the
%                  corresponding particles at time t+1, indexed in Column 2.
%                  The index of a particle at time t in 'matchedTraj' matches the
%                  index of the corresponding particle in the 'ccFeatures' array
%                  at the same time step.
%
%   The 'matchedTraj' output can be interpreted as follows:
%       matchedTraj = [1 2; 2 3] means
%       t = ti | t = ti+1
%       # 1 --> 2
%       # 2 --> 3
%
%   Note: If no trajectories are detected at a specific time step, an warning message 
%         will be displayed, and the function will continue to the next time step.

if nargin < 4
    maxDistAllowed = 20; % px
end
if nargin == 1
    features = {};
    featureWeight = [];
end

nFeatures = length(features);

time = length(ccFeatures);

matchedTraj = cell(time-1, 1);
% unmatchedR = matchedTraj;
% unmatchedC = matchedTraj;

t = 0;
while t < time-1
    t = t + 1;
    ccFeature1 = ccFeatures{t};
    ccFeature2 = ccFeatures{t+1};
    % distance matrix
    coord1 = cat(1, ccFeature1.Centroid);
    coord2 = cat(1, ccFeature2.Centroid);
    
    if isempty(coord1)
        warning(['No object is found at T = ' num2str(t) '.']);
        continue;
    end

    if isempty(coord2)
        warning(['No object is found at T = ' num2str(t+1) '.']);
        t = t + 1;
        continue;
    end

    nCC1 = size(coord1, 1);
    nCC2 = size(coord2, 1);
    dist = zeros(nCC1, nCC2); % dist matrix : row t col t+1
    
    mask = false(size(dist));

    if areaChangedThreshold ~= -1
        areaChanged = dist;
        % area matrix
        area1 = cat(1, ccFeature1.Area);
        area2 = cat(1, ccFeature2.Area);
        for iCell = 1:nCC1
            areaChanged(iCell, :) = abs((area1(iCell,:)-area2)./area1(iCell,:)');
        end
        mask = areaChanged > areaChangedThreshold;
    end

    for iCell = 1:nCC1
        dist(iCell, :) = vecnorm(coord1(iCell,:)-coord2, 2, 2)';
    end
   
    mask = mask | dist > maxDistAllowed;
    dist(mask) = inf;
    

    % newly added
    if ~any(dist(~mask))
        dist(~mask) = 1;
    end

    if all(dist(~mask) == inf)
        continue 
    end

    % penalty matrix
    penalty = zeros([size(dist) nFeatures]);
    for iFeat = 1:nFeatures
        penalty(:,:,iFeat) = getpenalty(ccFeature1, ccFeature2, features{iFeat}, featureWeight(iFeat));
    end
    penalty(repmat(mask, 1,1,nFeatures)) = 0;
    P = 1+sum(penalty,3);
    cost = (dist.*P).^2; % cost matrix
    costUnmatchd = max(cost(cost~=inf))*1.05;
    matchedTraj{t} = matchpairs(cost, costUnmatchd);
end