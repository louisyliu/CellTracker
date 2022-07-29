function trajMat = linktraj(matchedTraj)

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