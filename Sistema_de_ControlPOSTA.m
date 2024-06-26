%% Section 1
syms theta phi psi

Rx = [1         0                0    ;
      0         cos(phi)    -sin(phi) ;
      0         sin(phi)     cos(phi) ];
  
Ry = [cos(theta)    0       sin(theta);
      0             1           0     ;
     -sin(theta)    0       cos(theta)];
  
Rz = [cos(psi)   -sin(psi)      0     ;
      sin(psi)    cos(psi)      0     ;
        0           0           1    ];
 
R = Rz*Ry*Rz
%%
% Graficando con las ecuaciones
clear all, close all, clc

X0 = [0 0 0 0 0 0 0 0 0 0 0 0];
tspan = [0:0.001:6];
K  = 0;
[t, y] = ode45(@(t,X)nonlinear_function(X, X0, K, 0),tspan ,X0);
mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
for i=1:12   
    subplot (4,3,i);
    plot (t,y(:,i));
    title (mystr(i), 'interpreter' , 'latex');
    axis 'auto y';
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculando la matriz con la ecuaciones
clear all, close all, clc
syms b1 b2 b3 b4 Ixx Iyy Izz ut ux uy U1 U2 U3 U4 a1 a2 a3 m g l X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12
b1 = l/Ixx;
b2 = l/Iyy;
b3 = l/Izz;

ut = cos(X1)*cos(X3);
ux = cos(X1)*sin(X3)*cos(X5) + sin(X1)*sin(X5);
uy = cos(X1)*sin(X3)*sin(X5) - sin(X1)*cos(X5);

a1 = (Iyy - Izz)/Ixx;
a2 = (Izz - Ixx)/Iyy;
a3 = (Ixx- Iyy)/Izz;

f(1) = X2;
f(2) = X4*X6*a1 + b1*U2;
f(3) = X4;
f(4) = X2*X6*a2+b2*U3;
f(5) = X6;
f(6) = X2*X4*a3+b3*U4;
f(7) = X8;
f(8) = -g + ut*(1/m)*U1;
f(9) = X10;
f(10) = ux*(1/m)*U1;
f(11) = X12;
f(12) = uy*(1/m)*U1;

A = sym (zeros (12,12));
B = sym (zeros (12,4));

for i=1:12
   A(i,:) = gradient (f(i), [X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12]).';
end 
for i=1:12
   B(i,:) = gradient (f(i), [U1 U2 U3 U4]).';
end 
   
% m = 0.506;
% g = 9.8;
% l = 0.235;
% Ixx = 8.12e-5;
% Iyy = 8.12e-5;
% Izz = 6.12e-5;
U1=-m*g;
U2=0;
U3=0;
U4=0;
X1=0; X2=0; X3=0; X4=0; X5=pi; X6=0;X7=0; X8=0; X9=0; X10=0; X11=0; X12=0;


A = double(subs(A))
B = double(subs(B))
C =[1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 1 0 0 0 0 0 0 0 0 0;
    0 0 0 0 1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 0 0 0 0 0 1;]
D = zeros(size(C,1),size(B,2))

ctrl_obs(A,B,C);

eig(A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% close loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12];

K = place (A, B, p)

X0 = [10*pi/180 0 0 0 0 0 0 0 0 0 0 0].';
SetPoint = [5*pi/180 0 0 0 0 0 0 0 0 0 0 0].';
tspan = [0:0.001:6];
[t, y] = ode45(@(t,X)nonlinear_function(X, SetPoint, K, 1), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
for i=1:12   
    subplot (4,3,i);
    plot (t,y(:,i));
    title (mystr(i), 'interpreter' , 'latex');
    axis 'auto y';
end
%% LQR
[A, B, C, D] = getSystem();
Q = eye(12);
Q(1, 1) = 10;
Q(2, 2) = 10;
Q(3, 3) = 60;
Q(4, 4) = 60;
Q(5, 5) = 10;
Q(6, 6) = 10;
Q(7, 7) = 50;
R = 10*eye(4);
K = lqr(A, B, Q, R);
X0 = [0.8 0 0 0 0 0 0 0 0 0 0 0].';
SetPoint = [0 0 0 0 0 0 0 0 0 0 5 0].';
tspan = [0:0.01:7];

[t, y] = ode45(@(t,X)nonlinear_function(X, SetPoint, K, 1), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-15 15; -15 15; -15 15; -15 15; -15 15; -15 15; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end
%% Discretizado
[A, B, C, D] = getSystem();
Q = eye(12);
Q(1, 1) = 10;
Q(2, 2) = 10;
Q(3, 3) = 60;
Q(4, 4) = 60;
Q(5, 5) = 10;
Q(6, 6) = 10;
Q(7, 7) = 50;
R = 10*eye(4);
K = lqr(A, B, Q, R);

X0 = [0.8 0 0 0 0 0 0 0 0 0 0 0].';
SetPoint = [0 0 0 0 0 0 0 0 0 0 0 0].';

Tstep = .1e-3;
Ts = 20e-3;
TotalTime = 10;
TotalRefreshes = TotalTime/Ts;  % Esto siempre debe ser entero
pointsPerRefresh = Ts/Tstep;
tspan = 0:Tstep:(10-Tstep);
y = zeros(length(tspan), 12);
t = zeros(length(tspan), 1);
IC = zeros(12, TotalRefreshes);
IC(:, 1) = X0; 


[Kd,S,e] = lqrd(A,B,Q,R,Ts);

for i = 1:TotalRefreshes
    if i == 1
        [taux, yaux] = ode45(@(t,X)nonlinear_discrete_function(X, SetPoint, Kd, 1, IC(:, i)),... 
        tspan((i-1)*pointsPerRefresh + 1 : i*pointsPerRefresh), IC(:, i)); 
    
        t((i-1)*pointsPerRefresh + 1 : i*pointsPerRefresh, 1) = taux;
        y((i-1)*pointsPerRefresh + 1 : i*pointsPerRefresh, :) = yaux;
    else
        [taux2, yaux2] = ode45(@(t,X)nonlinear_discrete_function(X, SetPoint, Kd, 1, IC(:, i)),... 
        tspan((i-1)*pointsPerRefresh : i*pointsPerRefresh), IC(:, i)); 
    
        t((i-1)*pointsPerRefresh + 1 : i*pointsPerRefresh, 1) = taux2(2:end, 1);
        y((i-1)*pointsPerRefresh + 1 : i*pointsPerRefresh, :) = yaux2(2:end, :);    
    end
    if i < TotalRefreshes
        IC(:, i+1) = y(i*pointsPerRefresh, :).';
    end
end

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-15 15; -15 15; -15 15; -15 15; -15 15; -15 15; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end

U = zeros(4, 100000);
for i = 1:100000
    U(:, i) = -K*(y(i, :).'-SetPoint);
end
yLimits = [-1 1; -1 1; -1 1; -1 1];
for i=1:4   
    subplot (4,1,i);
    plot (t, U(i, :));
    %ylim(yLimits(i, :));
    grid on
end

%% Sistema lineal
[A, B, C, D] = getSystem();
Q = eye(8);
Q(1, 1) = 10;
Q(2, 2) = 10;
Q(3, 3) = 10;
Q(4, 4) = 10;
Q(5, 5) = 10;
Q(6, 6) = 10;
Q(7, 7) = 10;
Q(8, 8) = 10;
R = eye(4);
R(1, 1) = 10;
R(2, 2) = 1000000;
R(3, 3) = 1000000;
R(4, 4) = 1000000;
A = A(1:8, 1:8);
B = B(1:8, :);

K = lqr(A, B, Q, R);

X0 = [0.5 0 0 0 0 0 -10 0 0 0 0 0].';
SetPoint = [0 0 0 0 0 0 0 0].';
tspan = [0:0.001:10];

[A, B, C, D] = getSystem();
[t, y] = ode45(@(t,X)linearSystem(X, SetPoint, K, A, B), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-45 45; -45 45; -45 45; -45 45; -45 45; -45 45; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end


hold on
U = zeros(4, length(tspan));
for i = 1:length(tspan)
    U(:, i) = -K*(y(i, 1:8).'-SetPoint);
end
yLimits = [-1 1; -1 1; -1 1; -1 1];
for i=1:4   
    subplot (4,1,i);
    plot (t, U(i, :));
    %ylim(yLimits(i, :));
    grid on
end
%% Solo estados angulosos (continuous)
% LQR
[A, B, C, D] = getSystem();
Q = eye(8);
Q(1, 1) = 1000;
Q(2, 2) = 10;
Q(3, 3) = 1000;
Q(4, 4) = 10;
Q(5, 5) = 1000;
Q(6, 6) = 10;
Q(7, 7) = 1000;
Q(8, 8) = 10;
R = eye(4);
R(1, 1) = 10;
R(2, 2) = 1000000;
R(3, 3) = 1000000;
R(4, 4) = 1000000;
A = A(1:8, 1:8);
B = B(1:8, :);

K = lqr(A, B, Q, R);

X0 = [0.5 0 0 0 0 0 -10 0 0 0 0 0].';
SetPoint = [0 0 0 0 0 0 0 0].';
tspan = [0:0.001:10];

[t, y] = ode45(@(t,X)nonlinear_function_angularStates(X, SetPoint, K, 1), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-45 45; -45 45; -45 45; -45 45; -45 45; -45 45; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end


hold on
U = zeros(4, length(tspan));
for i = 1:length(tspan)
    U(:, i) = -K*(y(i, 1:8).'-SetPoint);
end
yLimits = [-1 1; -1 1; -1 1; -1 1];
for i=1:4   
    subplot (4,1,i);
    plot (t, U(i, :));
    %ylim(yLimits(i, :));
    grid on
end
% SISTEMA LINEAL PURO


% b = 1;
% X = [
%   (U(4, :) + U(1, :)*b - 2*U(3, :)*b)/(4*b); ...
%   (U(1, :)*b - U(4, :) + 2*U(2, :)*b)/(4*b);...
%   (U(4, :) + U(1, :)*b + 2*U(3, :)*b)/(4*b);...
%  -(U(4, :) - U(1, :)*b + 2*U(2, :)*b)/(4*b) ];
% for i=1:4   
%     subplot (4,1,i);
%     plot (t, X(i, :));
%     %ylim(yLimits(i, :));
%     grid on
% end
%% Solo estados angulosos y Z(continuous) y ademas con INTEGRADOR + DELAY
% LQR
DEG2RAD = pi/180
[A, B, C, D] = getSystem();

A = A(1:8, 1:8);
B = B(1:8, :);
C = [1 0 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 ];
 
Aaug = [ A   zeros(8, 2);
        -C   zeros(2, 2)];
Baug = [      B      ;
         zeros(2, 4)];
     
Q = eye(10);
Q(1, 1) = 17;
Q(2, 2) = 10;
Q(3, 3) = 10;
Q(4, 4) = 10;
Q(5, 5) = 1;
Q(6, 6) = 1;
Q(7, 7) = 100;
Q(8, 8) = 100;
Q(9, 9) = 88;
Q(10, 10) = 1;
R = eye(4);
R(1, 1) = 1;
R(2, 2) = 1;
R(3, 3) = 1;
R(4, 4) = 1;
K = lqr(Aaug, Baug, Q, R);

X0 = [30*DEG2RAD 0 15*DEG2RAD 0 0 0 0 0 0 0 0 0 0 0 0 0].';
SetPointESTADOS = [10*DEG2RAD 0 0 0 0 0 0 0].';
r = [0 0].';
tspan = [0:0.001:10];

[t, y] = ode45(@(t,X)nonlinear_function_angularStates_Integrators_WITH_Z_CONTROL(X, SetPointESTADOS, K, 1, C, r), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-45 45; -45 45; -45 45; -45 45; -45 45; -45 45; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end


hold on
U = zeros(4, length(tspan));
for i = 1:length(tspan)
    U(:, i) = -K*([(y(i, 1:8).' - SetPointESTADOS) ; y(i, 13:14).']);
end
yLimits = [-1 1; -1 1; -1 1; -1 1];
for i=1:4   
    subplot (4,1,i);
    plot (t, U(i, :));
    %ylim(yLimits(i, :));
    grid on
end
% SISTEMA LINEAL PURO


% b = 1;
% X = [
%   (U(4, :) + U(1, :)*b - 2*U(3, :)*b)/(4*b); ...
%   (U(1, :)*b - U(4, :) + 2*U(2, :)*b)/(4*b);...
%   (U(4, :) + U(1, :)*b + 2*U(3, :)*b)/(4*b);...
%  -(U(4, :) - U(1, :)*b + 2*U(2, :)*b)/(4*b) ];
% for i=1:4   
%     subplot (4,1,i);
%     plot (t, X(i, :));
%     %ylim(yLimits(i, :));
%     grid on
% end

%%
syms T1 T2 T3 T4 b U1 U2 U3 U4 c
eqn1 = T1 + T2 + T3 + T4 == U1;
eqn2 = T2 - T4 == U2;
eqn3 = T3 - T1 == U3;
eqn4 = c*T1 + c*T3 - c*T2 - c*T4 == U4;
[A,B] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4], [T1, T2, T3, T4])
X = linsolve(A,B)
%% Solo estados angulosos, Integrador y DELAY y MISMATCH
% LQR + I
DEG2RAD = pi/180;
[A, B, C, D] = getSystem();

A = A(1:6, 1:6);
B = B(1:6, :);
C = [1 0 0 0 0 0 ;
     0 0 1 0 0 0 ];
 
Aaug = [ A   zeros(6, 2);
         C   zeros(2, 2)];
Baug = [      B      ;
         zeros(2, 4)];
     
Q = eye(8);
Q(1, 1) = 2500;
Q(2, 2) = 0.0001;
Q(3, 3) = 2500;
Q(4, 4) = 0.0001;
Q(5, 5) = 1000;
Q(6, 6) = 10;
Q(7, 7) = 1000;
Q(8, 8) = 1000;
R = eye(4);
R(1, 1) = 100;
R(2, 2) = 100;
R(3, 3) = 100;
R(4, 4) = 100;
K = lqr(Aaug, Baug, Q, R);

X0 = [20*DEG2RAD 0 20*DEG2RAD 0 0 0 0 0 0 0 0 0 0 0 0 0].';
SetPointESTADOS = [0 0 0 0 0 0].';
r = [SetPointESTADOS(1) SetPointESTADOS(3)].';
tspan = 0:0.01:20;

[t, y] = ode45(@(t,X)nonlinear_function_angularStates_Integrators(X, SetPointESTADOS, K, 1, C, r), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-45 45; -45 45; -45 45; -45 45; -45 45; -45 45; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end

% Ploteo del error integral
hold off
mystr = ["Error en $\phi$", "Error en $\theta$"];
for i=13:14 
    subplot (2,1,i-12);
    plot (t,y(:,i));
    grid on
    title (mystr(i - 12), 'interpreter' , 'latex');
end
Ts = 1e-3;
[Kd,S,e] = lqrd(Aaug, Baug, Q, R, Ts);

Kx = Kd(:, 1:6);
Ki = Kd(:, 7:8);

printMatrixAsCcode(Kx);
printMatrixAsCcode(Ki);

hold on
U = zeros(4, length(tspan));
for i = 1:length(tspan)
    U(:, i) = -K*([(y(i, 1:6).' - SetPointESTADOS) ; y(i, 13:14).']);
end
yLimits = [-1 1; -1 1; -1 1; -1 1];
for i=1:4   
    subplot (4,1,i);
    plot (t, U(i, :));
    %ylim(yLimits(i, :));
    grid on
end


c = 10;
X = [
  -(U(4, :) - U(1, :)*c + 2*U(3, :)*c)/(4*c); ...
   (U(4, :) + U(1, :)*c - 2*U(2, :)*c)/(4*c);...
   (U(1, :)*c - U(4, :) + 2*U(3, :)*c)/(4*c);...
   (U(4, :) + U(1, :)*c + 2*U(2, :)*c)/(4*c) ];
for i=1:4   
    subplot (4,1,i);
    plot (t, X(i, :));
    %ylim(yLimits(i, :));
    grid on
end


%%
%% Solo estados angulosos, Integrador TRIPLE y DELAY y MISMATCH
% LQR + I
DEG2RAD = pi/180;
[A, B, C, D] = getSystem();

A = A(1:6, 1:6);
B = B(1:6, :);
C = [1 0 0 0 0 0 ;
     0 0 1 0 0 0 ;
     0 0 0 0 1 0];
 
Aaug = [ A   zeros(6, 3);
         C   zeros(3, 3)];
Baug = [      B      ;
         zeros(3, 4)];
     
Q = eye(9);
Q(1, 1) = 1200;
Q(2, 2) = 100;
Q(3, 3) = 1200;
Q(4, 4) = 100;
Q(5, 5) = 2500;
Q(6, 6) = 100;
Q(7, 7) = 1500;
Q(8, 8) = 1500;
Q(9, 9) = 1500;
R = eye(4);
R(1, 1) = 100;
R(2, 2) = 100;
R(3, 3) = 100;
R(4, 4) = 100;
K = lqr(Aaug, Baug, Q, R);

X0 = [20*DEG2RAD 0 20*DEG2RAD 0 20*DEG2RAD 0 0 0 0 0 0 0 0 0 0 0 0].';
SetPointESTADOS = [0 0 0 0 0 0].';
r = [SetPointESTADOS(1) SetPointESTADOS(3) SetPointESTADOS(5)].';
tspan = 0:0.01:20;

[t, y] = ode45(@(t,X)nonlinear_function_angularStates_Integrators_Triple(X, SetPointESTADOS, K, 1, C, r), tspan, X0);

mystr= ["$\Phi$", "$\dot{\Phi}$", "$\Theta$", "$\dot{\Theta}$", "$\Psi$", "$\dot{\Psi}$", "$Z$", "$\dot{Z}$", "$X$", "$\dot{X}$", "$Y$", "$\dot{Y}$"];
yLimits = [-45 45; -45 45; -45 45; -45 45; -45 45; -45 45; -10 10; -10 10; -5 5; -5 5; -20 20; -5 5];
units = [180/pi 180/pi 180/pi 180/pi 180/pi 180/pi 1 1 1 1 1 1];

for i=1:12   
    subplot (4,3,i);
    plot (t,units(i)*y(:,i));
    ylim(yLimits(i, :));
    grid on
    title (mystr(i), 'interpreter' , 'latex');
end

% Ploteo del error integral
hold off
mystr = ["Error en $\phi$", "Error en $\theta$"];
for i=13:14 
    subplot (2,1,i-12);
    plot (t,y(:,i));
    grid on
    title (mystr(i - 12), 'interpreter' , 'latex');
end
Ts = 1e-3;
[Kd,S,e] = lqrd(Aaug, Baug, Q, R, Ts);

Kx = Kd(:, 1:6);
Ki = Kd(:, 7:9);

printMatrixAsCcode(Kx);
printMatrixAsCcode(Ki);
    
hold on
U = zeros(4, length(tspan));
for i = 1:length(tspan)
    U(:, i) = -K*([(y(i, 1:6).' - SetPointESTADOS) ; y(i, 13:14).']);
end
yLimits = [-1 1; -1 1; -1 1; -1 1];
for i=1:4   
    subplot (4,1,i);
    plot (t, U(i, :));
    %ylim(yLimits(i, :));
    grid on
end


c = 10;
X = [
  -(U(4, :) - U(1, :)*c + 2*U(3, :)*c)/(4*c); ...
   (U(4, :) + U(1, :)*c - 2*U(2, :)*c)/(4*c);...
   (U(1, :)*c - U(4, :) + 2*U(3, :)*c)/(4*c);...
   (U(4, :) + U(1, :)*c + 2*U(2, :)*c)/(4*c) ];
for i=1:4   
    subplot (4,1,i);
    plot (t, X(i, :));
    %ylim(yLimits(i, :));
    grid on
end


%%
%% Least Squares curva motor

y = [0.05
0.1
0.15
0.2
0.25
0.3
0.35
0.4
0.45
0.5
0.55
0.6
0.65
0.7
0.75
0.8
0.85
0.9
0.95
1 ].';
x = [0.005
0.01
0.025
0.045
0.07
0.095
0.13
0.16
0.2
0.24
0.28
0.325
0.37
0.41
0.46
0.51
0.56
0.62
0.66
0.72].';


% M3 = [5.435   4.635   3.835   3.035   2.325   1.435   0.635];
% PWM = [1.00     1.28     1.70     2.20     2.97     4.35     7.50  ];
% p = polyfit(x, y, 2);                                               % Quadratic Function Fit
% v = polyval(p, x);                                                  % Evaluate
% TSE = sum((v - y).^2);                                              % Total Squared Error
% figure(1)
% plot(x, y, 'bp')
% hold on
% plot(x, v, '-r')
% grid

PWM = [0.05
0.1
0.15
0.2
0.25
0.3
0.35
0.4
0.45
0.5
0.55
0.6
0.65
0.7
0.75
0.8
0.85
0.9
0.95
1].';

Forza = 10*[0
0.005
0.015
0.025
0.035
0.05
0.065
0.085
0.105
0.125
0.145
0.175
0.205
0.235
0.265
0.3
0.33
0.365
0.39
0.425].';

p = polyfit(Forza, PWM, 2);                                         % Quadratic Function Fit
v = polyval(p, Forza);                                                  % Evaluate
TSE = sum((v - PWM).^2);                                              % Total Squared Error
figure(1)
plot(Forza, PWM, 'bp')
hold on
%plot(Forza, v, '-r')
%hold on
clear s;
pwm = @(s) p(1)*s.^2 + p(2)*s + p(3);
s = -0.5:0.01:6;
plot(s, pwm(s));
grid on
%% Solver 
syms F1 F2 F3 F4 b U1 U2 U3 U4 c
eqn1 = F1 + F2 + F3 + F4 == U1;
eqn2 = F3 - F1 == U2;
eqn3 = F4 - F2 == U3; 
eqn4 = +c*F1 + c*F3 - c*F2 - c*F4 == U4;
[A,B] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4], [F1, F2, F3, F4])
X = linsolve(A,B)

%% Test para comparar con el codigo en C 
Ts = 0.001;
InputState = [0.5*DEG2RAD; 2*DEG2RAD; 2*DEG2RAD; 2*DEG2RAD; 2*DEG2RAD; 2*DEG2RAD];
Reference = [-2*DEG2RAD; 0; 0; 0; 1*DEG2RAD; 0];
Int = zeros(3, 1);
for i=1:3000
    ErrP = InputState - Reference;
    Ux = Kx * ErrP;
    ErrI = [InputState(1); InputState(3); InputState(5)] - [Reference(1); Reference(3); Reference(5)];
    Int = Int + ErrI * Ts;
    U = -Ux - Ki*Int;
end

%% Curvas de Motor parametricas
syms a b
cantCurvas = 12;
x = zeros(2, cantCurvas);
for i = 1:cantCurvas
    
    eqn1 = a/4 + b/2 == 1/8*(0.5 + 0.1*i);
    eqn2 = a + b ==17/40*(0.5 + 0.1*i);
    [A, B] = equationsToMatrix([eqn1, eqn2], [a, b]);
    X(:, i) = linsolve(A,B);
    
end
f = @(a, b, x) a*x.^2 + b*x ;
t = 0:0.01:1;
X = double(X);
for i = 1:cantCurvas
    plot(9.8 * f(X(1, i), X(2, i), t), t);
    hold on 
    grid on
end


%% En base a las curvas anteriores vamos a
%% Funciones:

% Verifica controlabilidad y observabilidad.
function ctrl_obs(A,B,C)
    Cm=ctrb(A,B);                      
    disp('El sistema tiene');
    display( length(A) - rank(Cm));
    disp('estados no controlables')
    Ob = obsv(A,C);
    disp('El sistema tiene ');
    disp(length(A) - rank(Ob));
    disp('estados no observables');
end
function [A, B, C, D] = getSystem()
    syms b1 b2 b3 b4 Ixx Iyy Izz ut ux uy U1 U2 U3 U4 a1 a2 a3 m g l X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12
    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;

    ut = cos(X1)*cos(X3);
    ux = cos(X1)*sin(X3)*cos(X5) + sin(X1)*sin(X5);
    uy = cos(X1)*sin(X3)*sin(X5) - sin(X1)*cos(X5);

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;

    f(1) = X2;
    f(2) = X4*X6*a1 + b1*U2;
    f(3) = X4;
    f(4) = X2*X6*a2+b2*U3;
    f(5) = X6;
    f(6) = X2*X4*a3+b3*U4;
    f(7) = X8;
    f(8) = -g + ut*(1/m)*U1;
    f(9) = X10;
    f(10) = ux*(1/m)*U1;
    f(11) = X12;
    f(12) = uy*(1/m)*U1;

    A = sym (zeros (12,12));
    B = sym (zeros (12,4));

    for i=1:12
       A(i,:) = gradient (f(i), [X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12]).';
    end 
    for i=1:12
       B(i,:) = gradient (f(i), [U1 U2 U3 U4]).';
    end 
    Ixx = 7.5e-3;
    Iyy = 7.5e-3;
    Izz = 1.3e-3;
    g = 9.8;
    m = 0.8;
    l = 0.235;

%     Ixx = 8.12e-5;
%     Iyy = 8.12e-5;
%     Izz = 6.12e-5;
%     g = 9.8;
%     m = 0.5;
%     l = 0.235;
    U1= +m*g;
    U2=0;
    U3=0;
    U4=0;
    X1=0; X2=0; X3=0; X4=0; X5=0; X6=0;X7=0; X8=0; X9=0; X10=0; X11=0; X12=0;

    A = double(subs(A));
    B = double(subs(B));
    C =[1 0 0 0 0 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0 0 0 0 0;
        0 0 0 0 1 0 0 0 0 0 0 0;
        0 0 0 0 0 0 1 0 0 0 0 0];
    D = zeros(size(C,1),size(B,2));
end 
function f = nonlinear_function(X, SetPoint, K, ccl) %ccl=1 if close loop
    Ixx = 8.12e-5;
    Iyy = 8.12e-5;
    Izz = 6.12e-5;
    g = 9.8;
    m = 0.5;
    l = 0.235;
    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;
    
    ut = cos(X(1))*cos(X(3));
    ux = cos(X(1))*sin(X(3))*cos(X(5)) + sin(X(1))*sin(X(5));
    uy = cos(X(1))*sin(X(3))*sin(X(5)) - sin(X(1))*cos(X(5));

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;
    if ccl == 1
        U = -K*(X-SetPoint);
    else
        U = [4.9 0 0 0];
    end
    
    f(1,1) = X(2);
    f(2,1) = X(4)*X(6)*a1 + b1*U(2);
    f(3,1) = X(4);
    f(4,1) = X(2)*X(6)*a2+b2*U(3);
    f(5,1) = X(6);
    f(6,1) = X(2)*X(4)*a3+b3*U(4);
    f(7,1) = X(8);
    f(8,1) = -g + ut*(1/m)*U(1);
    f(9,1) = X(10);
    f(10,1) = ux*(1/m)*U(1);
    f(11,1) = X(12);
    f(12,1) = uy*(1/m)*U(1);
end
function f = nonlinear_function_angularStates(X, SetPoint, K, ccl) %ccl=1 if close loop
    Ixx = 8.12e-5;
    Iyy = 8.12e-5;
    Izz = 6.12e-5;
    g = 9.8;
    m = 0.5;
    l = 0.235;
    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;
    
    ut = cos(X(1))*cos(X(3));
    ux = cos(X(1))*sin(X(3))*cos(X(5)) + sin(X(1))*sin(X(5));
    uy = cos(X(1))*sin(X(3))*sin(X(5)) - sin(X(1))*cos(X(5));

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;
    if ccl == 1
        U = -K*(X(1:8)-SetPoint);
    else
        U = [4.9 0 0 0];
    end
    f(1,1) = X(2);
    f(2,1) = X(4)*X(6)*a1 + b1*(U(2) + 10e-3);
    f(3,1) = X(4);
    f(4,1) = X(2)*X(6)*a2+b2*(U(3));
    f(5,1) = X(6);
    f(6,1) = X(2)*X(4)*a3+b3*U(4);
    f(7,1) = X(8);
    f(8,1) = -g + ut*(1/m)*U(1);
    f(9,1) = X(10);
    f(10,1) = ux*(1/m)*U(1);
    f(11,1) = X(12);
    f(12,1) = uy*(1/m)*U(1);
end
function f = nonlinear_function_angularStates_Integrators(X, SetPointESTADOS, K, ccl, C, r) %ccl=1 if close loop
    Ixx = 7.5e-3;
    Iyy = 7.5e-3;
    Izz = 1.3e-3;
    g = 9.8;
    m = 0.8;
    l = 0.235;
    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;
    k = 10e-3; % en seg
    
    ut = cos(X(1))*cos(X(3));
    ux = cos(X(1))*sin(X(3))*cos(X(5)) + sin(X(1))*sin(X(5));
    uy = cos(X(1))*sin(X(3))*sin(X(5)) - sin(X(1))*cos(X(5));

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;
    if ccl == 1
        U = -K*([(X(1:6) - SetPointESTADOS) ; X(13:14) ]);
    else
        U = [4.9 0 0 0];
    end
    
    F1_MISMATCH = 1.1;
    F2_MISMATCH = 1;
    F3_MISMATCH = 0.9;
    F4_MISMATCH = 1.05;
%     F1_MISMATCH = 1;
%     F2_MISMATCH = 1;
%     F3_MISMATCH = 1;
%     F4_MISMATCH = 1;
  % U(1) = 9;

    c = 10;
    U(1) = 9;
    
    F1 = (U(4) + U(1)*c - 2*U(2)*c)/(4*c) * F1_MISMATCH;
    F2 = -(U(4) - U(1)*c + 2*U(3)*c)/(4*c) * F2_MISMATCH;
    F3 = (U(4) + U(1)*c + 2*U(2)*c)/(4*c) * F3_MISMATCH;
    F4 = (U(1)*c - U(4) + 2*U(3)*c)/(4*c) * F4_MISMATCH;     
    
    %% ACA va la K en las F
  
    
    U(1) = F1 + F2 + F3 + F4;
    U(2) = F3 - F1;
    U(3) = F4 - F2;
    U(4) = +c*F1 + c*F3 - c*F2 - c*F4;

%     c = 10;
%     F1 = -(U(4) - U(1)*c + 2*U(3)*c)/(4*c) * F1_MISMATCH;
%     F2 = (U(4) + U(1)*c - 2*U(2)*c)/(4*c) * F2_MISMATCH;
%     F3 = (U(1)*c - U(4) + 2*U(3)*c)/(4*c) * F3_MISMATCH;
%     F4 = (U(4) + U(1)*c + 2*U(2)*c)/(4*c) * F4_MISMATCH;
%     
%     U(1) = F1 + F2 + F3 + F4;
%     U(2) = F4 - F2;
%     U(1) = F3 - F1;
%     U(4) = -c*F1 - c*F3 + c*F2 + c*F4;
    
    f(1,1) = X(2);
    f(2,1) = X(4)*X(6)*a1 + b1*(X(15));
    f(3,1) = X(4);
    f(4,1) = X(2)*X(6)*a2+b2*(X(16));
    f(5,1) = X(6);
    f(6,1) = X(2)*X(4)*a3+b3*U(4);
    f(7,1) = X(8);
    f(8,1) = -g + ut*(1/m)*U(1);
    f(9,1) = X(10);
    f(10,1) = ux*(1/m)*U(1);
    f(11,1) = X(12);
    f(12,1) = uy*(1/m)*U(1);
    f(13:14,1) = C*X(1:6) - r;     % +2 variables por el integrador
    f(15,1) = (X(15) - U(2))/(-k); % +1 variable por el delay en phi 
    f(16,1) = (X(16) - U(3))/(-k); % +1 variable por el delay en theta
end
function f = nonlinear_function_angularStates_Integrators_Triple(X, SetPointESTADOS, K, ccl, C, r) %ccl=1 if close loop
    Ixx = 7.5e-3;
    Iyy = 7.5e-3;
    Izz = 1.3e-3;
    g = 9.8;
    m = 0.8;
    l = 0.235;
    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;
    k = 10e-3; % en seg
    
    ut = cos(X(1))*cos(X(3));
    ux = cos(X(1))*sin(X(3))*cos(X(5)) + sin(X(1))*sin(X(5));
    uy = cos(X(1))*sin(X(3))*sin(X(5)) - sin(X(1))*cos(X(5));

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;
    if ccl == 1
        U = -K*([(X(1:6) - SetPointESTADOS) ; X(13:15) ]);
    else
        U = [4.9 0 0 0];
    end
    
    F1_MISMATCH = 1.1;
    F2_MISMATCH = 1;
    F3_MISMATCH = 0.9;
    F4_MISMATCH = 1.05;
%     F1_MISMATCH = 1;
%     F2_MISMATCH = 1;
%     F3_MISMATCH = 1;
%     F4_MISMATCH = 1;
  % U(1) = 9;

    c = 10;
    U(1) = 9;
    
    F1 = (U(4) + U(1)*c - 2*U(2)*c)/(4*c) * F1_MISMATCH;
    F2 = -(U(4) - U(1)*c + 2*U(3)*c)/(4*c) * F2_MISMATCH;
    F3 = (U(4) + U(1)*c + 2*U(2)*c)/(4*c) * F3_MISMATCH;
    F4 = (U(1)*c - U(4) + 2*U(3)*c)/(4*c) * F4_MISMATCH;     
    
    %% ACA va la K en las F
  
    
    U(1) = F1 + F2 + F3 + F4;
    U(2) = F3 - F1;
    U(3) = F4 - F2;
    U(4) = +c*F1 + c*F3 - c*F2 - c*F4;

%     c = 10;
%     F1 = -(U(4) - U(1)*c + 2*U(3)*c)/(4*c) * F1_MISMATCH;
%     F2 = (U(4) + U(1)*c - 2*U(2)*c)/(4*c) * F2_MISMATCH;
%     F3 = (U(1)*c - U(4) + 2*U(3)*c)/(4*c) * F3_MISMATCH;
%     F4 = (U(4) + U(1)*c + 2*U(2)*c)/(4*c) * F4_MISMATCH;
%     
%     U(1) = F1 + F2 + F3 + F4;
%     U(2) = F4 - F2;
%     U(1) = F3 - F1;
%     U(4) = -c*F1 - c*F3 + c*F2 + c*F4;
    
    f(1,1) = X(2);
    f(2,1) = X(4)*X(6)*a1 + b1*(X(16));
    f(3,1) = X(4);
    f(4,1) = X(2)*X(6)*a2+b2*(X(17));
    f(5,1) = X(6);
    f(6,1) = X(2)*X(4)*a3+b3*U(4);
    f(7,1) = X(8);
    f(8,1) = -g + ut*(1/m)*U(1);
    f(9,1) = X(10);
    f(10,1) = ux*(1/m)*U(1);
    f(11,1) = X(12);
    f(12,1) = uy*(1/m)*U(1);
    f(13:15,1) = C*X(1:6) - r;     % +2 variables por el integrador
    f(16,1) = (X(16) - U(2))/(-k); % +1 variable por el delay en phi 
    f(17,1) = (X(17) - U(3))/(-k); % +1 variable por el delay en theta
end
function f = nonlinear_function_angularStates_Integrators_WITH_Z_CONTROL(X, SetPointESTADOS, K, ccl, C, r) %ccl=1 if close loop
    Ixx = 7.5e-3;
    Iyy = 7.5e-3;
    Izz = 1.3e-3;
    g = 9.81;
    m = 0.8;
    l = 0.235;
    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;
    k = 100e-3;
    
    ut = cos(X(1))*cos(X(3));
    ux = cos(X(1))*sin(X(3))*cos(X(5)) + sin(X(1))*sin(X(5));
    uy = cos(X(1))*sin(X(3))*sin(X(5)) - sin(X(1))*cos(X(5));

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;
    if ccl == 1
        U = -K*([(X(1:8) - SetPointESTADOS) ; X(13:14)]);
    else
        U = [4.9 0 0 0];
    end
    f(1,1) = X(2);
    f(2,1) = X(4)*X(6)*a1 + b1*(X(15));
    f(3,1) = X(4);
    f(4,1) = X(2)*X(6)*a2+b2*(X(16));
    f(5,1) = X(6);
    f(6,1) = X(2)*X(4)*a3+b3*U(4);
    f(7,1) = X(8);
    f(8,1) = -g + ut*(1/m)*U(1);
    f(9,1) = X(10);
    f(10,1) = ux*(1/m)*U(1);
    f(11,1) = X(12);
    f(12,1) = uy*(1/m)*U(1);
    f(13:14,1) = -C*X(1:8) + r;
    f(15,1) = (X(15) - U(2))/(-k);
    f(16,1) = (X(16) - U(3))/(-k);
end
function f = nonlinear_discrete_function(X, SetPoint, K, ccl, lastStateX) %ccl=1 if close loop
    Ixx = 7.5e-3;
    Iyy = 7.5e-3;
    Izz = 1.3e-3;
    g = 9.8;
    m = 0.8;
    l = 0.235;

    b1 = l/Ixx;
    b2 = l/Iyy;
    b3 = l/Izz;
    
    ut = cos(X(1))*cos(X(3));
    ux = cos(X(1))*sin(X(3))*cos(X(5)) + sin(X(1))*sin(X(5));
    uy = cos(X(1))*sin(X(3))*sin(X(5)) - sin(X(1))*cos(X(5));

    a1 = (Iyy - Izz)/Ixx;
    a2 = (Izz - Ixx)/Iyy;
    a3 = (Ixx - Iyy)/Izz;
    if ccl == 1
        U = -K*(lastStateX-SetPoint);
    else
        U = [4.9 0 0 0];
    end
    
    f(1,1) = X(2);
    f(2,1) = X(4)*X(6)*a1 + b1*U(2);
    f(3,1) = X(4);
    f(4,1) = X(2)*X(6)*a2+b2*U(3);
    f(5,1) = X(6);
    f(6,1) = X(2)*X(4)*a3+b3*U(4);
    f(7,1) = X(8);
    f(8,1) = -g + ut*(1/m)*U(1);
    f(9,1) = X(10);
    f(10,1) = ux*(1/m)*U(1);
    f(11,1) = X(12);
    f(12,1) = uy*(1/m)*U(1);
end
function f = linearSystem(X, SetPoint, K, A, B)
    u = -K*(X(1:8, 1) - SetPoint); % k es de 4x8
    f = A*X + B*u;
end
%% Matlab matrix to C code
function printMatrixAsCcode(A)
    fprintf("double A[%d][%d] = {\n", size(A, 1), size(A, 2));
    for i = 1:size(A, 1)
        fprintf("\t{");
        for j = 1:size(A, 2)
            fprintf("%.7f", A(i,j));
            if j < size(A, 2)
                fprintf(", ");
            end
        end
        fprintf("}");
        if i < size(A, 1)
            fprintf(",\n");
        else
            fprintf("\n");
        end
    end
    fprintf("};\n");
end