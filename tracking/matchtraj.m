function matchedTraj = matchtraj(ccFeatures, features, featureWeight, maxDistAllowed)
%MATCHTRAJ matches traj in consecutive frame.
%   MATCHTRAJ creates cost matrix depending on dist and features to obtain
%   the minimized total cost by solving linear assignment problem.
%
%   [matchedTraj] is a cell array of size T-1, where T is the total number
%   of time steps. 
%   Each cell in [matchedTraj] stores the info of particle at time t, 
%   indexed in Column 1, linked to the corresponding particle at time t+1,
%   indexed in Column 2. The index of a particle at time t in [matchedTraj]
%   matches index of the corresponding particle in the [ccFeatures] array
%   at the same time step. 
%
%   E.g., matchedTraj = [1 2; 2 3] means 
%               t = ti    |    t = ti+1
%         #         1    -->     2      
%         #         2    -->     3 
%
%   Available choices of {features} are 'Area' and 'MajorAxisLength'.

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

    if isempty(coord2)
        % disp(['Error: No traj is detected at T =' num2str(t+1) '.']);
        t = t + 1;
        continue;
    end

    nCC1 = size(coord1, 1);
    nCC2 = size(coord2, 1);
    dist = zeros(nCC1, nCC2); % dist matrix : row t col t+1
    for iCell = 1:nCC1
        dist(iCell, :) = vecnorm(coord1(iCell,:)-coord2, 2, 2)';
    end
   
    mask = dist > maxDistAllowed;
    dist(mask) = inf;
    
    % newly added
    if ~any(dist(~mask))
        dist(~mask) = 1;
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