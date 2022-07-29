function penalty = getpenalty(ccProps1, ccProps2, feat, pweight)
%GETPENALTY obtains penalty matrix considering the weight of penalty.
%   Penalty p is defined as 
%                   p = 3*weight*|f1-f2|/(f1+f2),
%   where f1, f2 are the feature (or properties) of particle 1 and 2,
%   repectively. 
%   Only perform 1D array feature.

props1 = [ccProps1.(feat)];
props2 = [ccProps2.(feat)];
penalty = zeros(length(props1), length(props2));
for k = 1:length(props1)
    penalty(k,:) = 3*pweight*abs(props1(k)-props2)./(props1(k)+props2);
end
end