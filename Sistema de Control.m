syms tita phi psi

A = [1          0                              sin(tita);
     0          cos(phi)              cos(tita)*sin(phi);
     0          -sin(tita)            cos(tita)*cos(phi)]
 
 D = inv(A);
 
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
   
m = 0.506;
g = 9.8;
l = 0.235;
Ixx = 8.12e-5;
Iyy = 8.12e-5;
Izz = 6.12e-5;
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

X0 = [0.8 0 0.8 0 0 0 0 0 0 0 0 0].';
SetPoint = [0 0 0 0 0 0 0 0 0 0 5 0].';
tspan = [0:0.001:7];

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
Q(7, 7) = 10;
Q(8, 8) = 50;
Q(9, 9) = 10;
Q(10, 10) = 50;
Q(11, 11) = 10;
Q(12, 12) = 50;
R = 10*eye(4);
K = lqr(A, B, Q, R);

X0 = [0.8 0 0 0 0 0 0 0 0 0 0 0].';
SetPoint = [0 0 0 0 0 0 0 0 0 0 5 0].';

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

Kd(:, 8) = zeros(4, 1);
Kd(:, 10) = zeros(4, 1);
Kd(:, 12) = zeros(4, 1);

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


%% Debug
g = @(t,X)nonlinear_function(X, zeros(12), zeros(4, 12), 1);
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

    m = 0.506;
    g = 9.8;
    l = 0.235;
    Ixx = 8.12e-5;
    Iyy = 8.12e-5;
    Izz = 6.12e-5;
    U1=-m*g;
    U2=0;
    U3=0;
    U4=0;
    X1=0; X2=0; X3=0; X4=0; X5=pi; X6=0;X7=0; X8=0; X9=0; X10=0; X11=0; X12=0;

    A = double(subs(A));
    B = double(subs(B));
    C =[1 0 0 0 0 0 0 0 0 0 0 0;
        0 0 1 0 0 0 0 0 0 0 0 0;
        0 0 0 0 1 0 0 0 0 0 0 0;
        0 0 0 0 0 0 1 0 0 0 0 0];
    D = zeros(size(C,1),size(B,2))   ;
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
function f = nonlinear_discrete_function(X, SetPoint, K, ccl, lastStateX) %ccl=1 if close loop
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

