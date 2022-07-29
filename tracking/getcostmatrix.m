function cost = getcostmatrix(ccFeatures, nCC, features, featureWeight, maxDistAllowed)


if nargin <= 4
    maxDistAllowed = 20; % px
end
if nargin == 2
    features = {};
    featureWeight = [];
end

nFeatures = length(features);

time = length(ccFeatures);

matchedTraj = cell(time-1, 1);
unmatchedR = matchedTraj;
unmatchedC = matchedTraj;

for t = 1:time-1

    ccFeature1 = ccFeatures{t};
    ccFeature2 = ccFeatures{t+1};
    % distance matrix
    coord1 = cat(1, ccFeature1.Centroid);
    coord2 = cat(1, ccFeature2.Centroid);
    dist = zeros(nCC(t), nCC(t+1));
    for iCell = 1:nCC(t)
        dist(iCell, :) = vecnorm(coord1(iCell,:)-coord2, 2, 2)';
    end
    mask = dist > maxDistAllowed;
    dist(mask) = inf;

    % penalty matrix
    penalty = zeros([size(dist) nFeatures]);
    for iFeat = 1:nFeatures
        penalty(:,:,iFeat) = getpenalty(ccFeature1, ccFeature2, features{iFeat}, featureWeight(iFeat));
    end
    penalty(repmat(mask, 1,1,nFeatures)) = 0;
    P = 1+sum(penalty,3);
    cost = (dist.*P).^2;
    costUnmatchd = max(cost(cost~=inf))*1.05;
    [M, uR, uC] = matchpairs(cost, costUnmatchd);
    matchedTraj{t} = M;
    unmatchedR{t} = uR;
    unmatchedC{t} = uC;
    dispbar(t, time-1);
end