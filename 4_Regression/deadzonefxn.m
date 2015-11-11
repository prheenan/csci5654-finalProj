%% Deadzone Penalty Function
% Chad Healy
% 
% 08 NOV 2015
% 
%
% To adapt to another dataset, change x and y and deadzone
% whose default is set at 1.
%
% Note: Some adjusting will have to be made for a polynomial or
%       other type of model

% Sample Dataset
x = [3,4,5,6,8,10,12]';
y = [16,12,9.6,7.9,6,4.7,4]';
deadzone = 5;

% Sample Penalty Function
% if abs(Ax-b) > 1, penalty = abs(Ax-b)
% else if abs(Ax-b) <=1, penatly = 0
% 
% replace each t variable with a sum of each segment
% t = z1 + z2 + z3
% loss function = -1*z1 + 0*z2 + 1*z3
% this actually drops to just z1 and z2,
% where 0 <= z1 < 1
% and z2 >= 0 ... 

% matrix for z's to replace t's
Z = zeros(length(x),length(x)*2);
for ii = 1:length(x)
    Z(ii,2*ii-1) = 1;
    Z(ii,2*ii) = 1;
end




% L-inf norm: 
% Initialize Matrices/Vectors
% Ainf = [-x,x;
%         -1*ones(size(x)),1*ones(size(x));
%         -1*eye(length(x)),-1*eye(length(x))]';
A = [-x -1*ones(size(x)),-1*Z;
      x,ones(size(x)),-1*Z];

% Constraints on z's
Zcon = zeros(length(x),size(A,2));
for ii = 1:length(x);
    Zcon(ii,2+2*ii-1) = 1;
end
% Update A
A = [A; Zcon];

bZcon = deadzone*ones(length(x),1);
b = [-1*y;y];
b = [b;bZcon];

%For some reason, it is not recognizing the positivity
% constraint on the z2 variable, so I'm adding this...
Zcon2 = zeros(length(x),size(A,2));
for ii = 1:length(x);
    Zcon2(ii,2+2*ii) = -1;
end
A = [A;Zcon2];
b = [b;zeros(length(x),1)];

% Build Cost Vector
c = zeros(size(A,2),1);
c(4:2:end) = 1;

[X_DZ,FVAL_DZ] = linprog(c,A,b);
x_dz = x;
y_dz = X_DZ(1)*x_dz + X_DZ(2);

figure
hold on
h(1) = plot(x,y,'b.','MarkerSize',25);
ciplot(y-deadzone,y+deadzone,x,'b',0.25)
h(2) = plot(x_dz,y_dz,'r','LineWidth',2);
