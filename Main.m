%% Main Function

%% Initialize
clear,clf;
homeDir = cd;
cd('./MatlabUtil')
AddAll()
cd(homeDir)
% Run all the unit tests related to getting decay constants
MainUnitTests;
disp('Generating regression models and taus.');
%% Read in Data
% Reads in Data and Model using both a logarithmic fit
% and polynomial fit
[labels,tauLog,tauPoly] = GetTausAndLabels();
taus = tauLog;

%% Regress Surface Location vs. Decay Constant for Model
% Initialize Parameters
types = 0:4;%Linf, L1, deadzone of size 0.5
degrees = 1:2;% for now, linear and quadratic fits
dz = 5;%nm, Deadzone
tauTypes = 2; % Log and Polynomial

for mm = 1:tauTypes;
    if mm == 1
        taus = tauLog;
    elseif mm == 2
        taus = tauPoly;
    end
    
    %% LINEAR LEAST SQUARES--"gold standard"
    if exist('regress')
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
            figure('Visible','Off')
            hold on
            plot(taus,labels,'b.','MarkerSize',25);
            [tausorted,ind] = sort(taus);
            plot(tausorted,ymodel(ind),'r','LineWidth',2);
            % Find Residuals
            residlsq(:,ii) = labels - ymodel;
            disp('Residuals: Least Squares for each degree of fit')
            resid_totlsq(ii) = sum(abs(residlsq(:,ii)))
        end
    end

    %% USING LP, DIFFERENT PENALTY FXNS
    %Initialize
    resids = zeros(length(taus),length(degrees),length(types));
    resid_tots = zeros(length(degrees),length(types));
    residsq_tots = zeros(length(degrees),length(types));

    % Run through different fits
    for ii = 1:length(degrees)
        for jj = 1:length(types)
            [~,~,resids(:,ii,jj),resid_tots(ii,jj),residsq_tots(ii,jj)] = polyregression(taus,labels,degrees(ii),types(jj),dz,1,mm-1);
        end
    end
    disp('Finished Generating all plots; See ./4_Output');
    disp('Residuals, Rows = degree of fit, Col = Penalty Fxn')
    resid_tots
end