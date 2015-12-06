tau = [1:10]';
label = [1:10]' + randn(10,1);


%% Regress Taus
% TRY DIFFERENT MODELS
types = 0:2;%Linf, L1, deadzone of size 0.5
degrees = 1:2;% for now, linear and quadratic fits
dz = 1;%nm

%% LINEAR LEAST SQUARES--"gold standard"
residlsq = zeros(length(label),length(degrees));
b = size(length(degrees),max(degrees)+1);
for ii = 1:length(degrees)
    xtemp = [];
    for jj = 0:ii
        xtemp = [tau.^jj, xtemp];
    end
    b(ii,:) = regress(label,xtemp);
    % Find Model
    ymodel = zeros(length(tau),1);
    for jj = ii:-1:1
        ymodel = tau.*(b(jj) + ymodel);
    end
    % Find Residuals
    residlsq(:,ii) = label - ymodel;
    resid_totlsq(ii) = sum(abs(residlsq(:,ii)));
end



%% USING LP, DIFFERENT PENALTY FXNS
%Initialize
resids = zeros(length(tau),length(degrees),length(types));
resid_tots = zeros(length(degrees),length(types));

% Run through different fits
for ii = 1:length(degrees)
    for jj = 1:length(types)
        [~,~,resids(:,ii,jj),resid_tots(ii,jj)] = polyregression(tau,label,degrees(ii),types(jj),dz,1);
    end
end
