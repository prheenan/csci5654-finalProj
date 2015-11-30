clear,clf;
% % read in single file
% [Time,Sep,Force] =...
%     ReadRawData('./TestData/X151022-3528356043-Image0040Force.hdf');
% % hand pick a label
% label = -4.1514413e-06;
% % get tau
% tau = GetDecayConstant(Time,Sep,Force);
% % regress on func(label-c*tau), find c --> how much to weight tau to find label
% % (this just has one tau/label ... will need a vector)
% % choose a penalty function (just assume deadzone now?)
% penaltyFunc = 'deadzone';
% c = Regress([tau],[label],penaltyFunc,opts);
% % look at RSQ, or ... (some metric)
[labels,tauLog,tauPoly] = GetTausAndLabels();
taus = tauLog;

%% Regress Taus
% TRY DIFFERENT MODELS
types = 0:4;%Linf, L1, deadzone of size 0.5
degrees = 1:2;% for now, linear and quadratic fits
dz = 5;%nm

%% LINEAR LEAST SQUARES--"gold standard"
residlsq = zeros(length(labels),length(degrees));

for ii = 1:length(degrees)
    xtemp = [];
    for jj = 0:ii
        xtemp = [taus.^jj, xtemp];
    end
    b = regress(labels,xtemp);
    % Find Model
    ymodel = zeros(length(taus),1);
    for jj = 1:ii
        ymodel = taus.*(b(jj) + ymodel);
    end
    ymodel = ymodel + b(end);
    % Plot Results
    figure
    hold on
    plot(taus,labels,'b.','MarkerSize',25);
    [tausorted,ind] = sort(taus);
    plot(tausorted,ymodel(ind),'r','LineWidth',2);
    % Find Residuals
    residlsq(:,ii) = labels - ymodel;
    resid_totlsq(ii) = sum(abs(residlsq(:,ii)));
end



%% USING LP, DIFFERENT PENALTY FXNS
%Initialize
resids = zeros(length(taus),length(degrees),length(types));
resid_tots = zeros(length(degrees),length(types));

% Run through different fits
for ii = 1:length(degrees)
    for jj = 1:length(types)
        [~,~,resids(:,ii,jj),resid_tots(ii,jj)] = polyregression(taus,labels,degrees(ii),types(jj),dz,1);
    end
end

