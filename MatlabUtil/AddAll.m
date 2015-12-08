% a simple script to add all the paths we could ever want.

mDir = cd;
addpath(genpath(mDir))
addpath(genpath([mDir '/../']))
savepath
