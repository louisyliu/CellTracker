function traj = trajfilter(trajAll,filterLength)

trajLength = cellfun(@length, trajAll);
traj = trajAll(trajLength>=filterLength);
end