function [  ] = PlotBeautify(  )
%PLOTBEAUTIFU Summary of this function goes here
%   Detailed explanation goes here
    ax = gca; % current axes
    tickFont = 20;
    labelFont = 23;
    titleFont = 28;
    set(ax,'TickDir','in');
    set(ax,'TickLength',[0.03 0.03]);
    set(ax,'FontSize',tickFont);
    % current x,y,title (labels!)
    xAx = get(ax,'XLabel');
    yAx = get(ax,'YLabel');
    titleAx = get(ax,'Title');
    set(xAx,'FontSize',labelFont);
    set(yAx,'FontSize',labelFont)
    set(titleAx,'FontSize',titleFont)

end

