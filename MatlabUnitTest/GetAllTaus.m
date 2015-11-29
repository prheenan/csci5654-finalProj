clf; clear all;
[ labels,tauLog,tauPoly ] = GetTausAndLabels();
figure;
hold all; 
plot(tauPoly,labels,'bo')
plot(tauLog,labels,'ro')
xlabel('Prediction')
ylabel('Ground Truth')
legend('Polynomial LP','Logarithmic LP')
xlim([min(tauLog),max(tauLog)]);
PlotBeautify()