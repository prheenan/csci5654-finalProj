function [ ax  ] = axvline(yVal,str )
%AXVLINE: Draws a vertical line at 'yVal' with color 'str'
    x = yVal .* ones(1,2);
    y = ylim;
    if (iscell(str))
        ax = plot(x,y,str{:});
    else
        ax = plot(x,y,str);
    end
end

