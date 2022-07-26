function trajImg = trajmovie(traj, trajImg, varargin)
%TRAJMOVIE creates trajectory movie.
% trajImg = TRAJMOVIE(traj, img, isExamineMode) create the movie of
% all trajectory. 

trajNo = 1:length(traj);
examineMode = false;
if nargin > 2
    examineMode = varargin{1};
end

trajFrame = cellfun(@(x) [x.Frame], traj, 'UniformOutput',0)';
frameDuration = cell2mat(cellfun(@(x) [x(1); x(end)], trajFrame, 'UniformOutput',0));
time = min(frameDuration(1,:)):max(frameDuration(2,:));

trajImg = im2uint8((permute(repmat(trajImg(:,:,time), [1 1 1 3]),[1 2 4 3])));
nTraj = length(trajNo);
color = im2uint8(linspecer(nTraj));
color = color(randperm(nTraj),:); % shuffle the color
trajLength = round(length(time)/5); % default traj length is 20% of length of movie. 

for iTraj = 1:nTraj
    coord = cat(1, traj{iTraj}.Centroid);
    frame = trajFrame{iTraj};
    pixelFilledCell = findpixelbtpoints(coord)';
    tRange = 2:length(frame);
    tStart = tRange - trajLength;
    tStart(tStart < 1) = 1;
    for t = tRange
        pixelFilled = cell2mat(pixelFilledCell(tStart(t-1):t-1));
        for iPixel = 1:size(pixelFilled,1)
            trajImg(pixelFilled(iPixel,2),pixelFilled(iPixel,1),:,frame(t)) = color(iTraj,:);
        end
    end
    dispbar(iTraj, nTraj);
end


if examineMode
    for t = 1:length(time)
        tCurrent = time(t);
        containT = cellfun(@(x) any(x==tCurrent), trajFrame);
        trajOrder = find(containT);
        trajTNo = trajNo(containT);
        trajT = traj(containT);
        tNo= cellfun(@(x) find(x==tCurrent), trajFrame(containT));
        nTrajT = length(trajT);
        position = zeros(nTrajT, 2);
        boxColor = zeros(nTrajT,3);
        textStr = cell(nTrajT,1);
        for iTraj = 1:nTrajT
            position(iTraj,:) = trajT{iTraj}(tNo(iTraj)).Centroid;
            boxColor(iTraj,:) = color(trajOrder(iTraj),:);
            textStr{iTraj} = num2str(trajTNo(iTraj));
        end
        trajImg(:,:,:,t) = insertText(trajImg(:,:,:,t),position,textStr,'BoxColor',boxColor,TextColor='white', FontSize=24);
        dispbar(t, length(time));
    end
end
