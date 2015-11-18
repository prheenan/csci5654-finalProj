function [ tau,pred,tauDist ] = FitPolynomialLP_Exponential( x,y,deg )
%FITPOLYNOMIALLP_EXPONENTIAL : uses an LP to approximate an exponential
% Inputs: 
%  x === the independent data to fit
%  y === the dependent data to fit
%  deg === the degree of the polynomial to approximat
% Outputs:
%  tau: an estimate of the time constant
%  pred: the predicted y values, given tau
%  tauDist: the distribution of taus

    % 1,1: use L1, use Exponential fit
    [tauDist,pred] = FitNDegree(deg,x,y,1,1);
    % lowest order (fist ele, non constant) is closest, due to high-frequency noise
    tau = tauDist(2);
end

