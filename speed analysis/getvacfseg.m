function [meanVACF, nVACF] = getvacfseg(traj)
% meanVACF = [mean]; no need std. nVACF = how many segment to calcualte
% meanVACF for each segment rather than each traf.
% hypothesis: cells have NO intrinsic motility difference.
% advantage: more data;  disadvantage: larger std.


coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);
v = cellfun(@(x) x(2:end, :)-x(1:end-1, :), coord, 'UniformOutput', false);

vacfAll = cellfun(@gettrajvacf, v, 'UniformOutput', false);

cellLength = cellfun(@(x) size(x, 1), vacfAll);
meanVACF = zeros(max(cellLength), 1);
nVACF = zeros(max(cellLength), 1);
for i = 1:max(cellLength)
    idx = cellLength >= i;

    vacf = cell2mat(cellfun(@(x) x(i), vacfAll(idx)));
    nVACF(i) = length(vacf);
    meanVACF(i) = mean(vacf);

end

end

function trajvacf = gettrajvacf(v1)
nTime = size(v1, 1);
trajvacf = cell(nTime, 1);
for t = 0:nTime-1
    vacf = v1(t+1:end,:).*v1(1:end-t, :);
    trajvacf{t+1} = sum(vacf, 2);
end
end