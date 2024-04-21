function [meanDrift, allDrift] = getdrift(traj)
% meanDrift = [mean xy ; std];  allDrift = mean Drift velocity for all traj
% drift for each traj rather than each segment. 
% hypothesis: cells have intrinsic motility difference. 

coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);

%%
if any(cellfun(@(x) size(x, 1)==1, coord))
    error("@getmeanv does not support v calculation of traj with single point. " ...
        + newline + "Use trajfilter to filter traj length < 2");
end

%%
allDrift = cellfun(@getalldrift, coord, 'UniformOutput', false);
allDrift = cell2mat(allDrift);
meanDrift(1,:) = mean(allDrift);
meanDrift(2,:) = std(allDrift);
end

function drift = getalldrift(coord) % coord is an array
    dist = coord(end,:)-coord(1,:);
    drift = dist/(size(coord, 1)-1);
end