function [meanVACF, nVACF] = getvacf(traj)
% meanVACF = [mean]; nVACF = how many traj to calcualte
% meanVACF for each traj rather than each segment. 
% hypothesis: cells have intrinsic motility difference. 

coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);
v = cellfun(@(x) x(2:end, :)-x(1:end-1, :), coord, 'UniformOutput', false);

vacfAll = cellfun(@gettrajvacf, v, 'UniformOutput', false);

cellLength = cellfun(@length, vacfAll);
meanVACF = zeros(max(cellLength), 1);
nVACF = zeros(max(cellLength), 1);
for i = 1:max(cellLength)
    idx = cellLength >= i;
    nVACF(i) = sum(idx);
    meanVACF(i) = mean(cellfun(@(x) x(i), vacfAll(idx)));
end

end

function trajvacf = gettrajvacf(v1)
nTime = size(v1, 1);
trajvacf = zeros(nTime, 1);
for t = 0:nTime-1
     vacf = v1(t+1:end,:).*v1(1:end-t, :);
     trajvacf(t+1) = mean(sum(vacf, 2));
end
end