function [meanMSD] = getmsd(traj)
% meanMSD = [mean]; no need std.  nMSD = how many traj to calcualte
% msd for each traj rather than each segment. 
% hypothesis: cells have intrinsic motility difference. 

coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);

allMSD = cellfun(@gettrajmsd, coord, 'UniformOutput', false);

cellLength = cellfun(@length, allMSD);
meanMSD = zeros(max(cellLength)+1, 1);
nMSD = zeros(max(cellLength)+1, 1);
for i = 1:max(cellLength)
    idx = cellLength >= i;
    nMSD(i+1) = sum(idx);
    meanMSD(i+1) = mean(cellfun(@(x) x(i), allMSD(idx)));
end
end

function trajmsd = gettrajmsd(coord1)
nTime = size(coord1, 1);
trajmsd = zeros(nTime-1, 1);
for t = 1:nTime-1
     dist = coord1(t+1:end,:)-coord1(1:end-t, :);
     trajmsd(t) = mean(sum(dist.^2, 2));
end
end