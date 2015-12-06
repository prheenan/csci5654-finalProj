function [ tau,pred ] = FitNonLinearExponential( x,y )
%%FitNonLinearExponential : uses an LP to approximate an exponential
%% Inputs: 
%%  x === the independent data to fit
%%  y === the dependent data to fit
%% Outputs:
%%  tau: an estimate of the time constant
%%  pred: the predicted y values, given tau

% fits Exp(-x/tau) to y
    mFunc = fittype( @(tau,x) exp(-x/tau));
    % fit needs columns
    if (isrow(x))
       x = x';
    end
    if (isrow(y))
       y = y'; 
    end
    maxX = max(x);
    fo = fitoptions('Method','NonlinearLeastSquares',...
                    'StartPoint',[maxX],'Lower',[0],...
                    'Upper',[maxX],'TolX',1e-2);
    f = fit(x,y,mFunc,fo);
    tau = f.tau;
    pred = mFunc(tau,x);
end

