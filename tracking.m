function traj = tracking(imgbw)

%% Feature Extraction
distCritical = 30; % px

disptitle('Extracting Features...');

% ccInfo = {'Area', 'Centroid', 'MajorAxisLength', 'MeanIntensity', 'PixelIdxList'};
ccInfo = {'Area', 'Centroid', 'MajorAxisLength',  'PixelIdxList'}; % feature in bw
% features = {'MajorAxisLength', 'MeanIntensity'};
features = {'MajorAxisLength'};
nPenalty = length(features);
featureWeight = [1,1];
time = size(imgbw, 3);
ccFeatures = cell(time, 1);
nCC = zeros(time, 1, 'uint32');
[imgHeight, imgWidth] = size(imgbw,[1 2]);
borderIdxList = [1:imgHeight 1:imgHeight:imgHeight*imgWidth imgHeight:imgHeight:imgHeight*imgWidth imgHeight*imgWidth-imgHeight+1:imgHeight*imgWidth];
for t = 1:time
    bw1 = imgbw(:,:,t);
    %     im1 = img(:,:,t);
    %     ccf = regionprops(bw1, im1, ccInfo);
    ccf = regionprops(bw1, ccInfo);
    pixelIdxList = {ccf.PixelIdxList};
    onBorder = cellfun(@(x) any(ismember(x,borderIdxList)), pixelIdxList,'UniformOutput',false);
    [ccf.OnBorder] = onBorder{:};
    ccFeatures{t} = ccf;
    nCC(t) = length(ccf);
    dispbar(t, time);
end

%% Cost Matrix Calculation

disptitle('Calculating Cost Matrix...')

matchedTraj = cell(time-1, 1);
unmatchedR = matchedTraj;
unmatchedC = matchedTraj;

for t = 1:time-1

    ccFeature1 = ccFeatures{t};
    ccFeature2 = ccFeatures{t+1};
    % distance matrix
    coord1 = cat(1, ccFeature1.Centroid);
    coord2 = cat(1, ccFeature2.Centroid);
    dist = zeros(nCC(t), nCC(t+1));
    for iCell = 1:nCC(t)
        dist(iCell, :) = vecnorm(coord1(iCell,:)-coord2, 2, 2)';
    end
    mask = dist>distCritical;
    dist(mask) = inf;

    % penalty matrix
    penalty = zeros([size(dist) nPenalty]);
    for iFeat = 1:nPenalty
        penalty(:,:,iFeat) = getpenalty(ccFeature1, ccFeature2, features{iFeat}, featureWeight(iFeat));
    end
    penalty(repmat(mask, 1,1,nPenalty)) = 0;
    P = 1+sum(penalty,3);
    cost = (dist.*P).^2;
    costUnmatchd = max(cost(cost~=inf))*1.05;
    [M, uR, uC] = matchpairs(cost, costUnmatchd);
    matchedTraj{t} = M;
    unmatchedR{t} = uR;
    unmatchedC{t} = uC;
    dispbar(t, time-1);
end

%% Link Trajectory
% brutal way
disptitle('Linking Trajectories...');
trajMat = matchedTraj{1};
for i = 1:length(matchedTraj)-1
    start = trajMat(:,i+1);
    M2 = matchedTraj{i+1};
    connect = M2(:,1);
    [LiEnd,LocStart] = ismember(start,connect);
    trajMat(:,i+2) = 0;
    trajMat(LiEnd, i+2) = M2(LocStart(LiEnd), 2);
    [LiEnd,~] = ismember(connect,start);
    trajMat(end+1:end+sum(~LiEnd), i+1:end) = M2(~LiEnd,:);
end

%% Fill Info

% disptitle('Filling Info...');

nTraj = size(trajMat,1);
trajOnBorder = cell(nTraj,1); % traj including those on border

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
    trajOnBorder{iTraj} = Trace;
end

%% Filter the border traj

disptitle('Filtering Trajectories on Borders...');
traj = [];
for i = 1:length(trajOnBorder)
    traj1 = trajOnBorder{i};
    onBorder = [traj1.OnBorder];
    if any(~onBorder)
        trajconncomp = regionprops(~onBorder,'PixelIdxList');
        trajSegNo = {trajconncomp.PixelIdxList};
        trajfilt = cellfun(@(x) traj1(x), trajSegNo, 'uniformoutput', 0);
        traj = [traj trajfilt];
    end
end
end

%%
function penalty = getpenalty(ccProps1, ccProps2, field, pweight)
% only perform 1D array feature.
props1 = [ccProps1.(field)];
props2 = [ccProps2.(field)];
penalty = zeros(length(props1), length(props2));
for k = 1:length(props1)
    penalty(k,:) = 3*pweight*abs(props1(k)-props2)./(props1(k)+props2);
end
end