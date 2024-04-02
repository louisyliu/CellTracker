function trajMat = linktraj(matchedTraj)
% LINKTRAJ Links trajectory segments at each time step to form complete
% trajectories. LINKTRAJ takes the matched trajectory segments at each time step
% and links them together to form complete trajectories. It constructs a matrix
% representation of the linked trajectories, where each row represents a unique
% trajectory and each column represents a time step.
%
%   - trajMat: An N x T matrix representing the linked trajectories, where N is the
%              total number of unique trajectories and T is the total number of time
%              steps. Each row of 'trajMat' represents a complete trajectory, with the
%              elements indicating the index of the trajectory segment at each time step.
%              Zero values indicate the absence of a trajectory segment at a particular
%              time step.

nTraj = length(matchedTraj)-1;
trajMat = [];
for i = 1:nTraj
    if ~isempty(matchedTraj{i})
        trajMat = matchedTraj{i};
        break
    end
end

if isempty(trajMat)
    return
end

for i = 1:length(matchedTraj)-1

    start = trajMat(:,i+1);
    M2 = matchedTraj{i+1};
    if isempty(M2)
        trajMat(:,i+2) = 0;
        dispbar(i, nTraj);
        continue;
    end
    connect = M2(:,1);
    [LiEnd,LocStart] = ismember(start,connect);
    trajMat(:,i+2) = 0;
    trajMat(LiEnd, i+2) = M2(LocStart(LiEnd), 2);
    [LiEnd,~] = ismember(connect,start);
    trajMat(end+1:end+sum(~LiEnd), i+1:end) = M2(~LiEnd,:);
    dispbar(i, nTraj);
end