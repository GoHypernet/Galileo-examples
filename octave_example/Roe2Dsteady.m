function [W,prim,T,X,Y] = Roe2Dsteady(W0,domain,tmax,dt)

%compute spatial grid and temporal step
domain_length_x = domain(1,2)-domain(1,1);
domain_length_y = domain(2,2)-domain(2,1);
[num_prim,num_points_x,num_points_y] = size(W0);

x = linspace(domain(1,1),domain(1,2),num_points_x);
y = linspace(domain(2,1),domain(2,2),num_points_y);
[X,Y] = meshgrid(x,y);

dx = domain_length_x/(num_points_x-1);
dy = domain_length_y/(num_points_y-1);

cflx = dt/dx;
cfly = dt/dy;

gamma = 1.4;
%allocate space for solution
W    = zeros(num_prim,num_points_x,num_points_y,round(tmax/dt));
prim = zeros(num_prim,num_points_x,num_points_y,round(tmax/dt));
W(1,:,:,1) = W0(1,:,:);
W(2,:,:,1) = W0(2,:,:);
W(3,:,:,1) = W0(3,:,:);
W(4,:,:,1) = W0(4,:,:);
T(1) = 0;
%intitialize counters;
time = 0; n = 1;
fprintf('Time Integration Loop: ');
while time <= tmax  %start time loop
    T(n+1) = time+dt;
    fprintf('%1.3e%% complete\n',100*((time/tmax)));
    
    fx = zeros(num_prim,num_points_x,num_points_y,1);
    fy = zeros(num_prim,num_points_x,num_points_y,1);
    for j = 1:num_points_y
        for i = 1:num_points_x
            if     i == 1    %left boundary, incoming flow
                if j == 1    % at bottom left corner
                    Wmirror = W(:,i,j,n); Wmirror(3) = -Wmirror(3);
                    fx(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i+1,j,n),'x')-RoeFlux2D(W0(:,i,j),W(:,i,j,n),'x'));
                    fy(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j+1,n),'y')-RoeFlux2D(Wmirror,W(:,i,j,n),'y'));
                elseif j == num_points_y %at top left corner
                    fx(:,i,j)  = 0;
                    fy(:,i,j)  = 0;
                else  %in middle of left wall
                    fx(:,i,j)  = 0;
                    fy(:,i,j)  = 0;
                end
            elseif i == num_points_x  % at right boundary, outgoing flow
                if j == 1 % bottom right corner, at solid wall
                    Wmirror = W(:,i,j,n); Wmirror(3) = -Wmirror(3);
                    fx(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j,n),'x')-RoeFlux2D(W(:,i-1,j,n),W(:,i,j,n),'x'));
                    fy(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j+1,n),'y')-RoeFlux2D(Wmirror,W(:,i,j,n),'y'));
                elseif j == num_points_y % at top right corner
                    fx(:,i,j)  = 0;
                    fy(:,i,j)  = 0;
                else  % in middle of outflow wall
                    fx(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j,n),'x')-RoeFlux2D(W(:,i-1,j,n),W(:,i,j,n),'x'));
                    fy(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j+1,n),'y')-RoeFlux2D(W(:,i,j-1,n),W(:,i,j,n),'y'));
                end
            else
                if j == 1 % in middle of solid wall
                    Wmirror = W(:,i,j,n); Wmirror(3) = -Wmirror(3);
                    fx(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i+1,j,n),'x')-RoeFlux2D(W(:,i-1,j,n),W(:,i,j,n),'x'));
                    fy(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j+1,n),'y')-RoeFlux2D(Wmirror,W(:,i,j,n),'y'));
                elseif j == num_points_y % in middle of top boundary
                    fx(:,i,j)  = 0;
                    fy(:,i,j)  = 0;
                else
                    fx(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i+1,j,n),'x')-RoeFlux2D(W(:,i-1,j,n),W(:,i,j,n),'x'));
                    fy(:,i,j)  = (RoeFlux2D(W(:,i,j,n),W(:,i,j+1,n),'y')-RoeFlux2D(W(:,i,j-1,n),W(:,i,j,n),'y'));
                end
            end        
        end
    end
        
    W(:,:,:,n+1) = W(:,:,:,n) - cflx*fx - cfly*fy;
    
    prim(1,:,:,n) = W(1,:,:,n);
    prim(2,:,:,n) = W(2,:,:,n)./W(1,:,:,n);
    prim(3,:,:,n) = W(3,:,:,n)./W(1,:,:,n);
    prim(4,:,:,n) = (gamma - 1)*(W(4,:,:,n) - 0.5*W(1,:,:,n).*(prim(2,:,:,n).^2+prim(3,:,:,n).^2));
   
%     ubuf = zeros(30,30); ubuf(:,:) = prim(2,:,:,n);
%     vbuf = zeros(30,30); vbuf(:,:) = prim(3,:,:,n);
%     pres = zeros(30,30); pres(:,:) = prim(4,:,:,n);
%     dens = zeros(30,30); dens(:,:) = prim(1,:,:,n);
%     Mach = sqrt(ubuf.^2+vbuf.^2)./sqrt(gamma*pres./dens);
%     
%     subplot(2,2,1)
%     contourf(X,Y,Mach')
%     title('Mach Number')
%     xlabel('x (m)')
%     ylabel('y (m)')
%     colorbar
%     subplot(2,2,2)
%     contourf(X,Y,vbuf')
%     title('Y Velocity (m/s)')
%     xlabel('x (m)')
%     ylabel('y (m)')
%     colorbar
%     subplot(2,2,3)
%     contourf(X,Y,pres') 
%     title('Pressure (Pa)')
%     xlabel('x (m)')
%     ylabel('y (m)')
%     colorbar
%     subplot(2,2,4)
%     contourf(X,Y,dens')
%     title('Density (Kg/m^2)')
%     xlabel('x (m)')
%     ylabel('y (m)')
%     colorbar
%     
%     M(n) = getframe;

    time = time + dt; n = n + 1;
        
end

return