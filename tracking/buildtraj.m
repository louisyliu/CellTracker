function trajAll = buildtraj(trajMat, ccFeatures)
%BUILDTRAJ builds traj with complete info. 
%   trajAll = buildtraj(trajMat, ccFeatures) builds traj with complete info
%   in {ccFeatures} containing located frame, centroid, major axis length, area, onborder or
%   not, and mean intensity. 
%
%   {trajAll} is of size 


nTraj = size(trajMat,1);
trajAll = cell(nTraj,1); % traj including those on border

% TraceStruct = struct('Frame',[],'Centroid', [], 'MeanIntensity', [], 'MajorAxisLength', []);
TraceStruct = struct('Frame',[],'Centroid', [], 'MajorAxisLength', []);
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
        % added on 20221121
        fields = fieldnames(spotFeature);
        for iField = 1:length(fields)
            fieldName = fields{iField};
            Trace(t).(fieldName) = spotFeature.(fieldName);
            Trace(t).Area = spotFeature.Area; % spot feature
            Trace(t).Centroid = spotFeature.Centroid;
            Trace(t).OnBorder = spotFeature.OnBorder;
            %         Trace(t).MeanIntensity = spotFeature.MeanIntensity;
            Trace(t).MajorAxisLength = spotFeature.MajorAxisLength;
            Trace(t).Frame = frameNo;
        end
    end
    trajAll{iTraj} = Trace;
end
end