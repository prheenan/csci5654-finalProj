close all; clf; clear;
[Time,Sep,Force] =...
    ReadRawData('./TestData/X151022-3528356043-Image0040Force.hdf');
% get the labels 
Labels = ReadLabels('./TestData/DetectedLabels.csv');
% convert pN from SI units
Force = Force .* 1e12;
% make sep run from 0 up
minV = min(Sep);
Sep = Sep- minV;
% get the label for the surface in nanometers, rel to lowest sep 
mLabel = (Labels(1)- minV) * 1e9;
% convert to nm
Sep = Sep .* 1e9;
[ApproachSep,ApproachForce] = GetApproach(Sep,Force);
% get just the last 'n' points
n = ceil(length(Sep)/50);
maxIdx = length(ApproachSep);
start = max(0,maxIdx-n);
ApproachSep = ApproachSep(start:maxIdx);
ApproachForce = ApproachForce(start:maxIdx);
% make the plots
subplot(2,1,1)
plot(Sep,Force)
xlabel('Separation between Tip and Surface [nm]');
ylabel('Force [pN]');
PlotBeautify();
subplot(2,1,2);
hold all;
plot(ApproachSep,ApproachForce);
xlabel('Separation between Tip and Surface [nm]');
ylabel('Force [pN]');
axvline(mLabel,'r');
PlotBeautify();