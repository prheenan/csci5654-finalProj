clf; clear all;
[ labels,tauLog,tauPoly ] = GetTausAndLabels();
% look at where things are zero (debugging errors...)
% tol = 1e-6;
% InputDir = './TestData/';
% files = dir([InputDir '*.hdf']);
% fileNames = {files.name};
% nFiles = numel(files);
% mZeros = (tauLog < tol | tauPoly < tol);
% mIndex = 1:numel(tauLog);
% for idx=mIndex(mZeros)
%     tmpFile = fileNames(idx);
%     tmpPath = [InputDir tmpFile{:}];
%     disp(InputDir)
%     [~,Sep,Force] =...
%      ReadRawData(tmpPath);
%      % minimize the surface location to this separation.
%     % also convert to nm (from meters)
%     minV = min(Sep);
%     % get tau, only lookin near the surface (make  the problem smaller)
%     [SepFit,ForceFit] = GetPortionToFit( Sep,Force );
%     figure
%     hold on;
%     plot(SepFit,ForceFit,'r-')    
%     plot(Sep,Force,'b-');
% end
figure;
hold all; 
plot(tauPoly,labels,'bo')
plot(tauLog,labels,'ro')
xlabel('Prediction')
ylabel('Ground Truth')
legend('Polynomial LP','Logarithmic LP')
%xlim([min(tauLog),max(tauLog)]);
PlotBeautify()