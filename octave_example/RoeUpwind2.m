function [W,prim,T,x] = RoeUpwind2(initial_condition,domain,tmax,cfl)

%compute spatial grid and temporal step
domain_length = domain(2)-domain(1);
[num_prim,num_points] = size(initial_condition);
x = linspace(domain(1),domain(2),num_points);
dx = domain_length/(num_points-1);
dt = cfl*dx;

gamma = 1.4;
%allocate space for solution
W    = zeros(num_prim,num_points,round(tmax/dt));
W(1,:,1) = initial_condition(1,:);
W(2,:,1) = initial_condition(1,:).*initial_condition(2,:);
W(3,:,1) = initial_condition(3,:)/(gamma-1) + 0.5*W(1,:,1).*initial_condition(2,:).^2;
T(1) = 0;
%intitialize counters;
time = 0; n = 1;
fprintf('Roe Upwind 2nd order \n');
while time <= tmax  %start time loop
    T(n+1) = time+dt;
    %if(n ~= 1)
    %    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
    %end
    %fprintf('%1.3e%% complete \r',100*((time/tmax)));
    
    f       = zeros(num_prim,num_points,1);
    for i = 1:num_points
        if     i==1 || i==2 || i == 3
            f(:,i)  = (RoeFlux(W(:,i+1,n),W(:,i+2,n)) -...
                       RoeFlux(W(:,i,n),W(:,i+1)));
        elseif i==num_points || i == num_points-1
            f(:,i)  = (RoeFlux(W(:,i-1,n),W(:,i,n)) -...
                       RoeFlux(W(:,i-2,n),W(:,i-1,n)));
        else
            f(:,i)  = (RoeTrapFlux(W(:,i+2,n),W(:,i+1,n),W(:,i,n)  ,W(:,i-1,n)) -...
                       RoeTrapFlux(W(:,i+1,n),W(:,i,n)  ,W(:,i-1,n),W(:,i-2,n)));     
        end        
    end
        
    W(:,:,n+1) = W(:,:,n) - cfl*f;   
    time = time + dt; n = n + 1;
   
end

prim = zeros(num_prim,num_points,length(T));
prim(1,:,:) = W(1,:,:);
prim(2,:,:) = W(2,:,:)./W(1,:,:);
prim(3,:,:) = (gamma - 1)*(W(3,:,:) - 0.5*W(1,:,:).*prim(2,:,:).^2);

return