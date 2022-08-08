function trajGapClosed = closegap(traj, trajMat)


matchedGap = matchgap(traj);
linkedGapMat = combinegap(matchedGap);
trajLinkedMat = linkgap(trajMat, linkedGapMat);
trajGapClosed = buildtraj(trajLinkedMat, ccFeatures);
end