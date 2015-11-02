function [ ApproachSep,ApproachForce ] = GetApproach( Sep,Force )
%GETAPPROACH Given the full (raw) separation and force, gives the approach
    % first, find where Sep is minimum; this roughly delineates approach
    % and retraction
    [~,minSepIdx] = min(Sep);
    % Next, get the maximum force between the start and the minimum sep.
    % this will correspond to~ the end of the invols/end of approach
    [~,endApproxIdx] = max(Force(1:minSepIdx));
    ApproachSep = Sep(1:endApproxIdx);
    ApproachForce = Force(1:endApproxIdx);
end

