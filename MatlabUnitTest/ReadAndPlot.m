%% This script reads in a single, example data set and plots it.
close all; clear;

[Time,Sep,Force] =...
    ReadRawData('./TestData/X151022-3528356043-Image0040Force.hdf');
% get the labels 
Labels = ReadLabels('./TestData/DetectedLabels.csv');
figure('Visible','Off');
% convert pN from SI units
Force = Force .* 1e12;
% make sep run from 0 up
minV = min(Sep);
Sep = Sep- minV;
% get the label for the surface in nanometers, rel to lowest sep 
mLabel = (Labels(1)- minV) * 1e9;
% convert to nm
Sep = Sep .* 1e9;
[ApproachSep,ApproachForce] = GetPortionToFit( Sep,Force );
% make the plots
subplot(2,1,1)
hold all;
plot(Sep,Force)
plot(ApproachSep,ApproachForce,'r');
xlim([0,500]);
xlabel('Separation [nm]');
ylabel('Force [pN]');
PlotBeautify();
subplot(2,1,2);
hold all;
plot(ApproachSep,ApproachForce,'r');
xlabel('Separation [nm]');
ylabel('Force [pN]');
axvline(mLabel,'r');
PlotBeautify();
SaveCurrentFigure('./4_Output/Figure2_SliceExample')