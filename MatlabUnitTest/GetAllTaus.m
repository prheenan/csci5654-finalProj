% Function with no arguments that determines all the
% tau (decay constants) for each model based on the available 
% data in "TestData"
clf; clear all;
[ labels,tauLog,tauPoly,tauExp ] = GetTausAndLabels();
figure('Visible','Off');
hold all; 
plot(tauPoly,labels,'bo');
plot(tauLog,labels,'rx');
plot(tauExp,labels,'gv');
xlabel('Decay Constant \tau [nm]')
ylabel('Surface Location Label [nm]')
legend('Polynomial LP','Logarithmic LP','Non-Linear Model')
%xlim([min(tauLog),max(tauLog)]);
PlotBeautify()
SaveCurrentFigure('./4_Output/TauCompare')