function [ coeffs,predicted] =FitNDegree( N,x,y,UseL1,UseExp )
% given x and y data, uses linprog to fit a polyomial of degree N,
% using 'L1' or 'LInfinity' Dpending on if L1 is set...
% if 'UseExp' is true, also adds in the factors for the exponential... 
    n = numel(x);
    myOnes = ones(n,1);
    if (isrow(x))
       x = x'; 
    end
    % start with at least a zero-degree polynomial
    A = myOnes;
    for i=1:N
        if (UseExp)
            % for an exponential model, we have a term like
            % 1/n! out front, and also -1 if odd.
            % just want to return the factor we care about
           prefactor = (1/factorial(i));
           if (mod(i,2) ~= 0)
               prefactor = prefactor * -1;               
           end
        else
           prefactor = 1;
        end
        A = [ prefactor .* (x.^(i)), A ];
    end
    % switch based on L1/LInfx
    if (UseL1)
        coeffs = L1NormRegr(A,y);
    else
        coeffs = LInfNormRegr(A,y);        
    end
    predicted = A * coeffs ;
    if (UseExp)
       % then convert the coefficients into their tau representation 
       % first, reverse, so that index 1 is constant, index 2 is linear,
       % etc
       coeffs = fliplr(coeffs');
       % next, multiply each element by its inverse power
       for i=2:(N+1)
          coeffs(i) = (1/coeffs(i))^(1/(i-1));
       end
    end
end

