function [ Sep,Force ] = GetPortionToFit( Sep,Force )
%GETPORTIONTOFIT Given Sep and Force, gets just the portion near the
%surface we want to fit and returns the new sep and force
% get the label for the surface in nanometers, rel to lowest sep 
    % convert to nm
    [ApproachSep,ApproachForce] = GetApproach(Sep,Force);
    % get just the last 'n' points
    n = ceil(length(Sep)/100);
    maxIdx = length(ApproachSep);
    start = max(0,maxIdx-n);
    Sep = ApproachSep(start:maxIdx);
    Force = ApproachForce(start:maxIdx);
end

