function [meanV, allV] = getmeanvseg(traj)
% meanV = [mean , std];  allV = mean V in all segment
% v for each segment rather than each traj. 
% hypothesis: cells have NO intrinsic motility difference. 
% advantage: more data;  disadvantage: larger std.

coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);

%%
if any(cellfun(@(x) size(x, 1)==1, coord))
    error("@getmeanv does not support v calculation of traj with single point. " ...
        + newline + "Use trajfilter to filter traj length < 2");
end

%%
allV = cell2mat(cellfun(@getallv, coord, 'UniformOutput', false));
meanV(1) = mean(allV);
meanV(2) = std(allV);
end

function v = getallv(coord) % coord is an array
    dist = coord(2:end,:)-coord(1:end-1,:);
    v = hypot(dist(:,1), dist(:,2));
end