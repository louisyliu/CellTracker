function linkedGapMat = combinegap(matchedGap)
% COMBINEGAP Links the possible consecutive gaps for the same trajectory.
%   COMBINEGAP integrates the gap information and links the gaps that belong
%   to the same trajectory. It takes the matched gap information and constructs
%   a matrix that represents the linked gaps.
%
%   For example, [matchedGap] shows [10, 20; 20, 30] suggesting
%        traj#10 -> #20, and traj#20 -> #30.
%   [linkedGapMat] outputs [10, 20 ,30]. traj#10 -> #20 -> #30.

if isempty(matchedGap)
    linkedGapMat = [];
    return
end

nGap = size(matchedGap,1);
linkedGapMat = matchedGap;
segStart = matchedGap(:,1);
iStartUsed = false(nGap,1);
iStartLogical = true(nGap,1);

while any(iStartLogical)
    segEnd = linkedGapMat(:,end);
    [iStartLogical,iEnd] = ismember(segStart,segEnd); % size of output is the same as segStart. segEnd is of the same size as linkedTraj.
    linkedGapMat(:, end+1) = 0;
    iEndwo0 = iEnd(iStartLogical);
    linkedGapMat(iEndwo0,end) = matchedGap(iStartLogical,2);
    iStartUsed  = iStartUsed | iStartLogical;
end

linkedGapMat(iStartUsed,:) = [];
linkedGapMat(:,end) = [];

end