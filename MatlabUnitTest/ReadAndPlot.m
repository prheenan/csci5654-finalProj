close all; clf;
[Time,Sep,Force] =...
    ReadRawData('./TestData/X151022-3528356043-Image0040Force.hdf');
% get the labels 
Labels = ReadLabels('./TestData/DetectedLabels.csv');
% convert to nm and pN from SI units
Sep = Sep .* 1e9;
Force = Force .* 1e12;
% make sep run from 0 up
%Sep = Sep- min(Sep);
% plot the N points around the min, 'zooming in'
n = ceil(length(Force)/40);
[~,minIdx] = max(Force);
% make the plots
subplot(2,1,1)
plot(Sep,Force)
xlabel('Separation between Tip and Surface [nm]');
ylabel('Force [pN]');
PlotBeautify();
subplot(2,1,2);
hold all;
lowIdx = minIdx-n;
highIdx = minIdx;
plot(Sep(lowIdx:highIdx),Force(lowIdx:highIdx))
xlabel('Separation between Tip and Surface [nm]');
ylabel('Force [pN]');
axvline(Labels(1)*1e9,'r');
PlotBeautify();