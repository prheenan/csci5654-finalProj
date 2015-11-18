function [coeff,fval] = polyregression(x,y,n,type,dz,plot_)
% Chad Healy
% 11 NOV 2015
% 
% Inputs:
%   x - independent variable, vector (m x 1)
%   y - dependent variable, vector (m x 1)
%   n - degree of polynomial, whole number >= 0
%   type - penalty function type:
%           0 - L-infinity norm
%           1 - L1 norm
%           2 - Deadzone
%           3 - 
%           4 - 
%   dz - deadzone, positive number, only applicable to type = 2
%   plot_ - plot the results or not. 0 = NO, 1 = YES

%% Check Inputs
if nargin == 5
    % Default: Do Not Plot
    plot_ = 0;
elseif nargin == 3
    type = 0;
    plot_ = 0;
    dz = 0;
    warning('Unspecified Norm Type, Choosing Default: L-infinity.')
elseif nargin <= 2
    error('Not enough inputs.')
elseif type == 2 && nargin == 4 
    warning('Deadzone not specified. Default value of 1 chosen.')
    dz = 1;
end
    
% Check that only one independent variable, for now...
if size(x) > 1
   error('Only written for one independent variable.') 
end

% Check if only one dependent variable
if size(y) > 1
   error('Only one dependent variable allowed.') 
end

% Check if x,y in column format. If yes, change format.
if size(x,1) == 1
    x = x';
end
if size(y,1) == 1
    y = y';
end

% Check that vector lengths are the same
if length(x) ~= length(y)
    error('Vectors must be the same length.')
end

% Check that polynomial is >= 0
if n<0 || mod(n,1) ~= 0
    error('Polynomial (n) must be a whole number greater than or equal to 0.')
end

% Check if type is specified
if ~any(type==[0,1,2])
    error('Please choose an existing norm type.')
end

%% Strings for Plotting
penaltytype = {'L-inf','L1','Deadzone'};


%% Build Matrix
% If L-infinity
if type == 0 
    A = [-1*ones(size(x));-1*ones(size(x))];
    c = [zeros(1,n+1),1]';
    b = [-1*y;y];
    for ii = 0:n
        A = [[-x.^ii;x.^ii], A];
    end
    
% If L-1
elseif type == 1 
    A = [-1*eye(length(x));-1*eye(length(x))];
    c = [zeros(1,n+1),ones(1,length(x))]';
    b = [-1*y;y]';
    for ii = 0:n
        A = [[-x.^ii;x.^ii], A];
    end
    
% If Deadzone
elseif type == 2 
    Z = zeros(length(x),length(x)*2);
    for ii = 1:length(x)
        Z(ii,2*ii-1) = 1;
        Z(ii,2*ii) = 1;
    end
    A = [-1*Z;
         -1*Z];
    for ii = 0:n
        A = [[-x.^ii;x.^ii], A];
    end
     
    % Constraints on z's
    Zcon = zeros(length(x),size(A,2));
    for ii = 1:length(x);
        Zcon(ii,n+1+2*ii-1) = 1;
    end
    % Update A
    A = [A; Zcon];

    bZcon = dz*ones(length(x),1);
    b = [-1*y;y];
    b = [b;bZcon];
    %For some reason, it is not recognizing the positivity
    % constraint on the z2 variable, so I'm adding this...
    Zcon2 = zeros(length(x),size(A,2));
    for ii = 1:length(x);
        Zcon2(ii,n+1+2*ii) = -1;
    end
    A = [A;Zcon2];
    b = [b;zeros(length(x),1)];
    % Build Cost Vector
    c = zeros(size(A,2),1);
    c(n+3:2:end) = 1;
end
    
%% Solve Minimization Problem
[coeff,fval] = linprog(c,A,b);

%% Plot Results
if plot_
    xplot = min(x):(max(x) - min(x))/200:max(x);
    yplot = zeros(1,length(xplot));
    for ii = 1:n
        yplot = xplot.*(yplot + coeff(ii));
    end
    yplot = yplot + coeff(n+1);
    
    figure
    hold on
    if type == 2
        ciplot(y-dz,y+dz,x,'b',0.25)
    end
    p(1) = plot(x,y,'b.','MarkerSize',25);
    p(2) = plot(xplot,yplot,'r','LineWidth',2);
    legend(p,'Data','Model Fit')
    title(['Polynomial Degree: ',num2str(n),' Fit Using ',penaltytype{type+1},' Penalty'])
end
