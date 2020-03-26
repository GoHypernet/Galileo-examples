function [W,prim,T,x] = StegerWarm(initial_condition,domain,tmax,cfl)

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
fprintf('Steger Warming \n');
while time <= tmax  %start time loop
    T(n+1) = time+dt;
    %if(n ~= 1)
    %    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
    %end
    %fprintf('%1.3e%% complete \r',100*((time/tmax)));
    
    f       = zeros(num_prim,num_points,1);
    f_plus  = zeros(num_prim,num_points,1);
    f_minus = zeros(num_prim,num_points,1);
    for i = 1:num_points
        if     i==1 
            f_plus(:,i)  = (StegWarmFlux(W(:,i+1,n),'plus')  - StegWarmFlux(W(:,i,n),'plus'));
            f_minus(:,i) = (StegWarmFlux(W(:,i+1,n),'minus') - StegWarmFlux(W(:,i,n),'minus'));
        elseif i==num_points
            f_plus(:,i)  = (StegWarmFlux(W(:,i,n),'plus')    - StegWarmFlux(W(:,i-1,n),'plus'));
            f_minus(:,i) = (StegWarmFlux(W(:,i,n),'minus')   - StegWarmFlux(W(:,i-1,n),'minus'));
        else
            f_plus(:,i)  = (StegWarmFlux(W(:,i,n),'plus')    - StegWarmFlux(W(:,i-1,n),'plus'));
            f_minus(:,i) = (StegWarmFlux(W(:,i+1,n),'minus') - StegWarmFlux(W(:,i,n),'minus'));          
        end
        f = f_plus + f_minus;
    end
        
    W(:,:,n+1) = W(:,:,n) - cfl*f;
   
    time = time + dt; n = n + 1;
   
end

prim = zeros(num_prim,num_points,length(T));
prim(1,:,:) = W(1,:,:);
prim(2,:,:) = W(2,:,:)./W(1,:,:);
prim(3,:,:) = (gamma - 1)*(W(3,:,:) - 0.5*W(1,:,:).*prim(2,:,:).^2);

return