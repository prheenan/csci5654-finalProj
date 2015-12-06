function [ optSol ] = NormRegression( A,b,UseL1 )
%% Function: [optSol] = NormRegression (Sep,Force)
%% Inputs: 
%%    (A,b) === matrix A and vector b from Ax<= b
%%    (UseL1) === 1/0: if we should or shouldnt use the L1 solution
%% Outputs:
%%   The optimal solution to the  regression problem
% See: class book, page 171, chapter 12.3
% for L1:
% minimite sum(t_i), where i runs over the conditions ('m')
% (+A)*x - t <= b
% (-A)*x - t <= -b
% for Linf, same, except only one t 
% get A and b into a form we like
    m = numel(b);
    % number of columns is decisions variables
    n = size(A,2);
    % add in the extra rows we need for +A/-A
    fullA = [-A ; A];
    if (UseL1)
        % add in the extra matrix for -t
        conditionMat = eye(m);
        conditionMat = [-conditionMat; -conditionMat];
        %objective only non zero for t's
        obj = zeros(1,n+m);
        obj(n+1:end) = 1;
    else
        conditionMat = -1 * ones(2*m,1);
        %objective only non zero for t's
        obj = zeros(n+1,1);
        obj(n+1) = 1;
    end
    fullA = [fullA,conditionMat];
    % b becomes [-b,b]'
    b = [-b,b]';
    % get the best solution using simplex, silent...
    nVars = size(fullA,2);
    optionsLP = optimoptions('linprog','Algorithm','dual-simplex',...
        'Display','off','MaxIter',100*nVars,'TolFun',1e-6,'TolCon',1e-3);
    x0 = zeros(n+m,1);
    % specific to surface detection: every variable has a lower bound of 0
    % by construction.
    x = linprog(obj,fullA,b,[],[],[],[],x0,optionsLP);
    nX = numel(x);
    if (nX < n)
       error('LinProg failed!');
    end
    optSol = x(1:n);
end
