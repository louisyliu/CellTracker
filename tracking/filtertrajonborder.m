function trajNotOnBorder = filtertrajonborder(trajAll)
%FILTERTRAJONBORDER separates the traj on border. 
%   filtertrajonborder(trajAll) separates the traj on border into several
%   segments. 

trajNotOnBorder = [];
for i = 1:length(trajAll)
    traj1 = trajAll{i};
    onBorder = [traj1.OnBorder];
    if any(~onBorder)
        trajconncomp = regionprops(~onBorder,'PixelIdxList');
        trajSegNo = {trajconncomp.PixelIdxList};
        trajfilt = cellfun(@(x) traj1(x), trajSegNo, 'uniformoutput', 0);
        trajNotOnBorder = [trajNotOnBorder trajfilt];
    end
end
end