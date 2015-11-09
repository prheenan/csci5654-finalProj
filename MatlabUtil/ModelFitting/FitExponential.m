function [ tau,pred ] = FitExponential( x,y )
% fits Exp(-x/tau) to y
    mFunc = fittype( @(tau,x) exp(-x/tau));
    % fit needs columns
    if (isrow(x))
       x = x';
    end
    if (isrow(y))
       y = y'; 
    end
    f = fit(x,y,mFunc,'StartPoint',max(x));
    tau = f.tau;
    pred = mFunc(tau,x);
end

