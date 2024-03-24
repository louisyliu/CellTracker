function [meanMSD, nMSD] = getmsdseg(traj)
% meanMSD = [mean]; no need std.  nMSD = how many segment to calcualte
% msd for each segment rather than each traf. 
% hypothesis: cells have NO intrinsic motility difference.
% advantage: more data;  disadvantage: larger std.


coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);

allMSD = cellfun(@gettrajmsd, coord, 'UniformOutput', false);

cellLength = cellfun(@length, allMSD);
meanMSD = zeros(max(cellLength)+1, 1);
nMSD = zeros(max(cellLength)+1, 1);
for i = 1:max(cellLength)
    idx = cellLength >= i;

    msd = cell2mat(cellfun(@(x) x(i), allMSD(idx)));
    nMSD(i+1) = length(msd);
    meanMSD(i+1) = mean(msd);
end

end

function trajmsd = gettrajmsd(coord1)
nTime = size(coord1, 1);
trajmsd = cell(nTime-1, 1);
for t = 1:nTime-1
    dist = coord1(t+1:end,:)-coord1(1:end-t, :);
    trajmsd{t} = sum(dist.^2, 2);
end
end