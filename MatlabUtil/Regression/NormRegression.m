function [ optSol ] = NormRegression( A,b,UseL1 )
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
    % get the best solution
    x = linprog(obj,fullA,b);
    optSol = x(1:n);
end
