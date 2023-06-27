function trajGapClosed = buildgapclosedtraj(trajLinkedMat, ccFeatures)

nTrajLinked = size(trajLinkedMat,1);
trajGapClosed = cell(nTrajLinked,1);

% TraceStruct = struct('Frame',[],'Centroid', [], 'MeanIntensity', [], 'MajorAxisLength', []);
TraceStruct = struct('Frame',[],'Centroid', [], 'MajorAxisLength', []);
for iTraj = 1:nTrajLinked
    Trace = TraceStruct;
    trajMat1 = trajLinkedMat(iTraj,:);
    trajIdx = find(trajMat1);
    traceLength = numel(trajIdx);
    Trace(traceLength) = TraceStruct; % initialization
    for t = 1:traceLength
        frameNo = trajIdx(t);
        tracefeature = ccFeatures{frameNo};
        

        spotFeature = tracefeature(trajMat1(frameNo));
        Trace(t).Area = spotFeature.Area; % spot feature
        Trace(t).Centroid = spotFeature.Centroid;
%         Trace(t).MeanIntensity = spotFeature.MeanIntensity;
        Trace(t).MajorAxisLength = spotFeature.MajorAxisLength;
        Trace(t).Frame = frameNo;
    end
    trajGapClosed{iTraj} = Trace;
end

end