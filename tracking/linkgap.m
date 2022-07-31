function trajLinkedMat = linkgap(trajMat, linkedGapMat)

trajLinkedMat = trajMat;
nGapLinked = size(linkedGapMat,1);
firstTraj = linkedGapMat(:,1);

for iGap = 1:nGapLinked
    iTraj = linkedGapMat(iGap,:);
    iTrajTrim = iTraj(iTraj~=0); % Trim the trailing zeros
    trajLinkedMat(firstTraj(iGap),:) = sum(trajMat(iTrajTrim,:));
end
% delete the repetitive traj
iTrajRedundant = linkedGapMat(nGapLinked+1:end);
iTrajRedundantwo0 = iTrajRedundant(iTrajRedundant~=0);
trajLinkedMat(iTrajRedundantwo0,:) = [];

end