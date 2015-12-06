function [ Sep,Force ] = GetPortionToFit( Sep,Force )
%% Function: [Sep,Force] = GetPortionToFit (Sep,Force)
%% Inputs: 
%%    (Sep,Force) === the original Separation (meter) and Force (Newton) data
%% Outputs:
%%    Sep, Force === The portion of the curve to fit (ie: exponentially decaying region )
%Given Sep and Force, gets just the portion near the
%surface we want to fit and returns the new sep and force
% get the label for the surface in nanometers, rel to lowest sep 
    % convert to nm
    [ApproachSep,ApproachForce] = GetApproach(Sep,Force);
    % get just the last 'n' points
    n = length(Sep);
    % get the median force on the approach
    medianForce = median(ApproachForce);
    % figure out where we are less than the median
    whereLT = ApproachForce < medianForce;
    % when does this first happen?
    allIdx = 1:n;
    medianIdx = allIdx(whereLT);
    % add a 'buffer' after the median
    start = medianIdx(end) - ceil(n/200);
    maxIdx = length(ApproachSep);
    Sep = ApproachSep(start:maxIdx);
    Force = ApproachForce(start:maxIdx);
end

