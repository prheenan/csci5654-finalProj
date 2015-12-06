function [ optSol ] = L1NormRegr( A,b )
%% Function: [optSol] = L1NormRegr (Sep,Force)
%% Inputs: 
%%    (A,b) === matrix A and vector b from Ax<= b
%% Outputs:
%%   The optimal solution to the  regression problem 
    % 1 means use L1, not LInf
     optSol = NormRegression( A,b,1 );
end
