function [ ax ] = axhline(yVal,str)
%AXHLINE Summary of this function goes here
%   Detailed explanation goes here
    x = xlim;
    y = ones(1,2) .* yVal;
    if (iscell(str))
        ax = plot(x,y,str{:});
    else
        ax = plot(x,y,str);
    end
end

