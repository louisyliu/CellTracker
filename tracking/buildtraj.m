function trajAll = buildtraj(trajMat, ccFeatures)



nTraj = size(trajMat,1);
trajAll = cell(nTraj,1); % traj including those on border

TraceStruct = struct('Frame',[],'Centroid', [], 'MeanIntensity', [], 'MajorAxisLength', []);
for iTraj = 1:nTraj
    Trace = TraceStruct;
    trajMat1 = trajMat(iTraj,:);
    trajIdx = find(trajMat1);
    traceLength = numel(trajIdx);
    Trace(traceLength) = TraceStruct; % initialization
    for t = 1:traceLength
        frameNo = trajIdx(t);
        tracefeature = ccFeatures{frameNo};
        spotFeature = tracefeature(trajMat1(frameNo));
        Trace(t).Area = spotFeature.Area; % spot feature
        Trace(t).Centroid = spotFeature.Centroid;
        Trace(t).OnBorder = spotFeature.OnBorder;
        %         Trace(t).MeanIntensity = spotFeature.MeanIntensity;
        Trace(t).MajorAxisLength = spotFeature.MajorAxisLength;
        Trace(t).Frame = frameNo;
    end
    trajAll{iTraj} = Trace;
end
end