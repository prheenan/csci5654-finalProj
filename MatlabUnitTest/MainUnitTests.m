%% This script generates a series of plots in the './TestCache/' Folder
warning('off','MATLAB:legend:IgnoringExtraEntries');
disp('Creating an example exponential plot in ./4_Output/');
SingleExpFit;
disp('Reading in all data and getting decay constants in ./4_Output/');
GetAllTaus;