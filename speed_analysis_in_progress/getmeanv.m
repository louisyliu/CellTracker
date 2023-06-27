function [meanV, allV] = getmeanv(traj)
% meanV = [mean , std];  allV = mean V in all traj
% v for each traj rather than each segment. 
% hypothesis: cells have intrinsic motility difference. 

coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);

%%
if any(cellfun(@(x) size(x, 1)==1, coord))
    error("@getmeanv does not support v calculation of traj with single point. " ...
        + newline + "Use trajfilter to filter traj length < 2");
end

%%
allV = cellfun(@getallv, coord);
meanV(1) = mean(allV);
meanV(2) = std(allV);
end

function meanvAll = getallv(coord) % coord is an array
    dist = coord(2:end,:)-coord(1:end-1,:);
    v = hypot(dist(:,1), dist(:,2));
    meanvAll = mean(v);
end