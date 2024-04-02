function trajMatNotOnBorder = linkborder(trajMat, ccFeatures)

if isempty(trajMat)
    trajMatNotOnBorder = [];
    return
end

borderMat = false(size(trajMat));
nTime = length(ccFeatures);
for t = 1:nTime
    ccFeatures1 = ccFeatures{t};
    cellNo = trajMat(:, t);

    onBorder = [ccFeatures1.OnBorder];
    nCell = length(onBorder);
    onBorder(end+1) = 0;
    cellNo(cellNo==0) = nCell+1;
    borderMat(:, t) = onBorder(cellNo);
end


% separate traj
trajNotOnBorder = [];
for i = 1:size(trajMat, 1)
    trajMat1 = trajMat(i, :);
    frameStart = find(trajMat1, 1, "first");
    frameLast = find(trajMat1, 1, "last");
    onBorder = borderMat(i, frameStart:frameLast);
    trajSeg = trajMat1(frameStart:frameLast);

    if any(~onBorder)
        trajconncomp = regionprops(~onBorder,'PixelIdxList');
        trajSegNo = {trajconncomp.PixelIdxList};
        %         trajfilt = cellfun(@(x) trajSeg(x), trajSegNo, 'uniformoutput', 0);
        trajfilt = cellfun(@(x) padzeros(x, frameStart, trajSeg), trajSegNo, 'UniformOutput', false);
        trajNotOnBorder = [trajNotOnBorder; trajfilt'];
    end
end

trajMatNotOnBorder = cell2mat(trajNotOnBorder);

% trajMatNotOnBorder = cell2mat(cellfun(@padzeros(), trajNotOnBorder', 'UniformOutput', false));




    function xfinal = padzeros(x, frameStart, trajSeg)
        xfinal = zeros(1, nTime, 'uint16');
        segStart = frameStart + x(1) - 1;
        segEnd = frameStart + x(end) - 1;
        if length(x) ~= numel(segStart:segEnd)
            disp('');
        end
        xfinal(segStart:segEnd) = trajSeg(x);
    end

end