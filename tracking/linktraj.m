function trajMat = linktraj(matchedTraj)
%LINKTRAJ links traj segments at each time. 
%   trajMat = LINKTRAJ(matchedTraj) links traj segments at each time to a
%   complet traj.  
% 
%   [trajMat] is of size N x T, where N is the traj number and T is the
%   total time.   

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