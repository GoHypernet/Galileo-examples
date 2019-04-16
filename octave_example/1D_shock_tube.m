clc 
clear
close all

domain = [-10, 10];
tmax   = 0.01; %s
cfl = 0.001;

pL   = 1e5; pR = 1e4;     %N/m^2
rhoL = 1;   rhoR = 0.125; %kg/m^3
uL   = 100; uR = 50;      %m/s

numPoints = 100;
x = linspace(domain(1),domain(2),numPoints);
for i=1:numPoints
    if x(i) <= 0
        initialCond(1,i) = rhoL;
        initialCond(2,i) = uL;
        initialCond(3,i) = pL;
    else
        initialCond(1,i) = rhoR;
        initialCond(2,i) = uR;
        initialCond(3,i) = pR;
    end  
end
    
[W,prim1,T,x] = StegerWarm(initialCond,domain,tmax,cfl);
[W,prim2,T,x] = RoeUpwind(initialCond,domain,tmax,cfl);
[W,prim3,T,x] = RoeUpwind2(initialCond,domain,tmax,cfl);
% prim1 = prim3;
 % prim2 = prim3;
% for i = 1:length(T)
    i = length(T);
	hf = figure()
    subplot(2,2,1)
    plot(x,prim1(1,:,i),x,prim2(1,:,i),'-.',x,prim3(1,:,i),'--')
    title('density')
    ylabel('\rho (kg/m^3)')
    xlabel('x (m)')
    legend('Steger-Warming','1st Order Roe Upwind','2nd Order Roe Upwind')
    subplot(2,2,2)
    plot(x,prim1(2,:,i),x,prim2(2,:,i),'-.',x,prim3(2,:,i),'--')
    title('velocity')
    ylabel('v (m/s)')
    xlabel('x (m)')
    legend('Steger-Warming','1st Order Roe Upwind','2nd Order Roe Upwind')
    subplot(2,2,3)
    plot(x,prim1(3,:,i),x,prim2(3,:,i),'-.',x,prim3(3,:,i),'--')
    title('pressure')
    ylabel('p (Pa)')
    xlabel('x (m)')
    legend('Steger-Warming','1st Order Roe Upwind','2nd Order Roe Upwind')
    print -dpng results.png
    
%    M(i) = getframe;
    
% end
% 
% movie(M)