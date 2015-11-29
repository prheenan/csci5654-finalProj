function [ tau,predX,predY ] = FitLogarithmicLP_Exponential( x,y )
%FITPOLYNOMIALLP_EXPONENTIAL : uses an LP to approximate an exponential
% Inputs: 
%  x === the independent data to fit
%  y === the dependent data to fit
% Outputs:
%  tau: an estimate of the time constant
%  predX: x values for to y (may be different than 'x', we recquire y > 0)
%  predY: predictions for the y
    % we cant take log of anything <= 0... 
    mIndex = (y > 0);
    logYtoFit = log(y(mIndex));
    predX = x(mIndex);
    % 1/0: use L1, dont use exponential
    deg =1; % just a linear fit.
    [poly,predLog] = FitNDegree(deg,predX,logYtoFit,1,0);
    % first coefficient is just the linear coeff, second is cnstant 
    % since y ~ A*exp(-x/t)
    % log(y) ~ log(A)+ -x/t
    % looking for t
    tau = -1/poly(1);
    % to get the predictions in non-log space, 
    predY = exp(predLog);
end