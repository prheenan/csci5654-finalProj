clear,clf;
% read in single file
[Time,Sep,Force] =...
    ReadRawData('./TestData/X151022-3528356043-Image0040Force.hdf');
% hand pick a label
label = -4.1514413e-06;
% get tau
tau = GetDecayConstant(Time,Sep,Force);
% regress on func(label-c*tau), find c --> how much to weight tau to find label
% (this just has one tau/label ... will need a vector)
% choose a penalty function (just assume deadzone now?)
penaltyFunc = 'deadzone';
c = Regress([tau],[label],penaltyFunc,opts);
% look at RSQ, or ... (some metric)