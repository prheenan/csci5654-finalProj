% Plot Example Penalty Function

x = -2:0.1:2;

% L1
yL1 = abs(x);

figure
plot(x,yL1,'LineWidth',2)
hold on
plot([0],[0],'r.','MarkerSize',25)
ylim([-0.25 4])
grid on

% DZ
yDZ = zeros(size(x));
yDZ(abs(x)>1) = abs(x(abs(x)>1))-1;

figure
plot(x,yDZ,'LineWidth',2)
hold on
plot([-1,1],[0,0],'r.','MarkerSize',25)
ylim([-0.25 4])
grid on

% Asymm
yAsym = zeros(size(x));
yAsym(x<0) = abs(x(x<0)*2);
yAsym(x>=0) = abs(x(x>=0));

figure
plot(x,yAsym,'LineWidth',2)
hold on
plot([0],[0],'r.','MarkerSize',25)
ylim([-0.25 4])
grid on

% Quad:-3-seg
y3seg = zeros(size(x));
y3seg(abs(x) < 0.5) = abs(x(abs(x)<0.5))*0.5;
y3seg(((abs(x) >= 0.5) & (abs(x) < 1))) = abs(x((abs(x) >= 0.5) & (abs(x) < 1)))-0.25;
y3seg(abs(x) >= 1) = abs(x(abs(x) >= 1))*3 - 2.25;

figure
plot(x,y3seg,'LineWidth',2)
hold on
plot([0,-0.5,0.5,1,-1],[0,0.25,0.25,0.75,0.75],'r.','MarkerSize',25)
plot(x,x.^2,'m:','LineWidth',2)
ylim([-0.25 4])
grid on

% Linf
yinf = max(x)*ones(size(x));
figure
plot(x,yinf,'LineWidth',2)
hold on
plot([-2,2],[2,2],'r.','MarkerSize',25)
ylim([-0.25 4])
grid on