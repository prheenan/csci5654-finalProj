function [  ] = SaveCurrentFigure( name )
%SAVECURRENTFIGURE: Saves the current figure with name 'name'
    width = 15;
    height = 15;
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, width, height], ...
        'PaperUnits', 'Inches', 'PaperSize', [width, height]);
    print([name '.png'],'-dpng');

end

