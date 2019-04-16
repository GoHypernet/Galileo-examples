clc
clear
close all

tmax = 0.1;
dt = 0.00005;
gamma = 1.4;
R     = 287;  % J/kg-K
p_inf = 1e5; % N/m^2
T_inf = 300;  % K
M_inf = 2;
theta = 10;   %degrees

c     = sqrt(gamma*R*T_inf);
rho   = p_inf/(R*T_inf);
V_inf = M_inf*c;
vx    = V_inf*cos(theta*pi/180);
vy    = -V_inf*sin(theta*pi/180);

numpointsx = 30;
numpointsy = 30;
domain     = [0, 3; 0, 3]; % meters

x     = linspace(domain(1,1),domain(1,2),numpointsx);
y     = linspace(domain(2,1),domain(2,2),numpointsy);
Winit = zeros(4,numpointsx,numpointsy);
for i = 1:numpointsx
    for j = 1:numpointsy
        Winit(1,i,j) = rho;
        Winit(2,i,j) = rho*vx;
        Winit(3,i,j) = rho*vy;
        Winit(4,i,j) = (p_inf/(gamma-1)) + 0.5*rho*V_inf^2;
    end
end

[W,prim,T,X,Y] = Roe2Dsteady(Winit,domain,tmax,dt);
[a,a,a,d] =size(prim);

% for i = 1:d
    ubuf = zeros(30,30);
    vbuf = zeros(30,30);
    pres = zeros(30,30);
    dens = zeros(30,30);
    for m = 1:30
        for n = 1:30
            ubuf(m,n) = prim(2,m,n,end);
            vbuf(m,n) = prim(3,m,n,end);
            pres(m,n) = prim(4,m,n,end);
            dens(m,n) = prim(1,m,n,end);
            Mach      = sqrt(ubuf.^2+vbuf.^2)./sqrt(gamma*pres./dens);
        end
    end
    
	hf = figure()
    subplot(2,2,1)
    contourf(X,Y,Mach')
    title('Mach Number')
    xlabel('x (m)')
    ylabel('y (m)')
    colorbar
    subplot(2,2,2)
    contourf(X,Y,vbuf')
    title('Y Velocity (m/s)')
    xlabel('x (m)')
    ylabel('y (m)')
    colorbar
    subplot(2,2,3)
    contourf(X,Y,pres') 
    title('Pressure (Pa)')
    xlabel('x (m)')
    ylabel('y (m)')
    colorbar
    subplot(2,2,4)
    contourf(X,Y,dens')
    title('Density (Kg/m^2)')
    xlabel('x (m)')
    ylabel('y (m)')
    colorbar
	print -dpng results.png
    
    %M(i) = getframe;
    
% end

