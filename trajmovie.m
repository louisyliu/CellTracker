function trajImg = trajmovie(traj, img, varargin)
%TRAJMOVIE creates trajectory movie.
% trajImg = TRAJMOVIE(traj, img, trajNo) create the movie of trajectory of
% index TrajNo. Plot all the trajectories by default.

trajNo = 1:length(traj);
examineMode = false;
if nargin > 2
    if ~isempty(varargin{1})
        trajNo = varargin{1};
    end
end
if nargin > 3
    examineMode = varargin{2};
end

trajTemp = traj(trajNo);
trajFrame = cellfun(@(x) [x.Frame], trajTemp, 'UniformOutput',0)';
frameDuration = cell2mat(cellfun(@(x) [x(1) x(end)], trajFrame, 'UniformOutput',0));
time = min(frameDuration(:,1)):max(frameDuration(:,2));

% reshape(trajImg, [size(img,1:2) 1 size(img)])]
trajImg = im2uint8((permute(repmat(img(:,:,time), [1 1 1 3]),[1 2 4 3])));
nTraj = length(trajNo);
color = im2uint8(linspecer(nTraj));
color = color(randperm(nTraj),:); % shuffle the color

% for iTraj = 1:nTraj
%     coord = cat(1, trajTemp{iTraj}.Centroid);
%     frame = trajFrame{iTraj};
% %     pixelFilled = findpixelbtpoints(coord);
%     for t = 2:length(frame)
%         pixelFilled = findpixelbtpoints(coord(1:t,:));
%         for iPixel = 1:size(pixelFilled,1)
%             trajImg(pixelFilled(iPixel,2),pixelFilled(iPixel,1),:,t) = color(iTraj,:);
%             %             if examineMode
%             %                 position = coord(t,:);
%             %                 boxColor = color(iTraj,:);
%             %                 textStr = num2str(trajNo(iTraj));
%             %                 trajImg(:,:,:,t) = insertText(trajImg(:,:,:,t), position,textStr,'BoxColor',boxColor,TextColor='white',FontSize=24);
%             %             end
%         end
%     end
%     dispbar(iTraj, nTraj);
% end

% --------- updated algorithm
for iTraj = 1:nTraj
    coord = cat(1, trajTemp{iTraj}.Centroid);
    frame = trajFrame{iTraj};
    pixelFilledCell = findpixelbtpoints(coord);
    for t = 2:length(frame)
        pixelFilled = pixelFilledCell{t-1};
        for iPixel = 1:size(pixelFilled,1)
            trajImg(pixelFilled(iPixel,2),pixelFilled(iPixel,1),:,t) = color(iTraj,:);
            %             if examineMode
            %                 position = coord(t,:);
            %                 boxColor = color(iTraj,:);
            %                 textStr = num2str(trajNo(iTraj));
            %                 trajImg(:,:,:,t) = insertText(trajImg(:,:,:,t), position,textStr,'BoxColor',boxColor,TextColor='white',FontSize=24);
            %             end
        end
    end
    dispbar(iTraj, nTraj);
end


% ----------------------------


if examineMode
    for t = 1:length(time)
        tCurrent = time(t);
        containT = cellfun(@(x) any(x==tCurrent), trajFrame);
        trajOrder = find(containT);
        trajTNo = trajNo(containT);
        trajT = trajTemp(containT);
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
        trajImg(:,:,:,t) = insertText(trajImg(:,:,:,t),position,textStr,'BoxColor',boxColor,TextColor='white',FontSize=24 );
        dispbar(t, length(time));
    end

end
