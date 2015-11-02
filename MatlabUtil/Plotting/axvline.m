function [ ax  ] = axvline(yVal,str )
%AXVLINE Summary of this function goes here
%   Detailed explanation goes here
    x = yVal .* ones(1,2);
    y = ylim;
    if (iscell(str))
        ax = plot(x,y,str{:});
    else
        ax = plot(x,y,str);
    end
end

