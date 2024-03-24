function [vvsT] = getvvst(traj)
% vvsT = [mean , std];
% vvsT : v changes with time for each traj .


coord = cellfun(@(x) cat(1, x.Centroid), traj, 'UniformOutput', false);

v = cellfun(@getv, coord, 'UniformOutput', false);
vlength = cellfun(@length, v);
vvsT = zeros(max(vlength), 2);
for i = 1:max(vlength)
    idx = i<=vlength;
    data = cellfun(@(x) x(i), v(idx));
    vvsT(i, 1) = mean(data);
    vvsT(i, 2) = std(data);
end
end

function v = getv(coord)
dist = coord(2:end,:)-coord(1:end-1,:);
v = hypot(dist(:,1), dist(:,2));
end