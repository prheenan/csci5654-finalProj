function [ ax ] = axhline(yVal,str)
%AXHLINE: draws a horizontal line at yval with color 'str'
    x = xlim;
    y = ones(1,2) .* yVal;
    if (iscell(str))
        ax = plot(x,y,str{:});
    else
        ax = plot(x,y,str);
    end
end

