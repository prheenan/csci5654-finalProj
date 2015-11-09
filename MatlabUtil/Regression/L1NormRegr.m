function [ optSol ] = L1NormRegr( A,b )
    % 1 means use L1, not LInf
     optSol = NormRegression( A,b,1 );
end
