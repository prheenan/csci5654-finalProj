function [ Labels ] = ...
    ReadLabels( FilePath )
%READLabels Reads in an csv file with surface labels, in meters
%   FilePath: Path to the file
    skiprows = 0; 
    skipcols = 0;
    Labels = csvread(FilePath,skiprows,skipcols);
end

