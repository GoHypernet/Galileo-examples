function [F] = StegWarmFlux(W,upwind)

% W = [rho,
%      rho*v
%      E]

%compute primatives
gamma = 1.4;
rho   = W(1);
v     = W(2)/rho;
E     = W(3);
p     = (gamma - 1)*(E - rho*1/2*v^2);
c     = sqrt(gamma*p/rho);
if ~isreal(c) || p < 0 || rho < 0
    error('speed of sound is not real');
end

%check for sonic points, add rounding correction
M = v/c;
eigenVals = [v; v+c; v-c];
eps = 1e-6;
if M == 0
    if strcmp(upwind,'plus')
        eigenVals(1) = 0.5*(eigenVals(1) + sqrt(eigenVals(1)^2 + eps^2));
        eigenVals(2) = 0.5*(eigenVals(2) + sqrt(eigenVals(2)^2));
        eigenVals(3) = 0.5*(eigenVals(3) + sqrt(eigenVals(3)^2));
    else 
        eigenVals(1) = 0.5*(eigenVals(1) - sqrt(eigenVals(1)^2 + eps^2));
        eigenVals(2) = 0.5*(eigenVals(2) - sqrt(eigenVals(2)^2));
        eigenVals(3) = 0.5*(eigenVals(3) - sqrt(eigenVals(3)^2));
    end
    l1 = eigenVals(1); l2 = eigenVals(2); l3 = eigenVals(3);
elseif M == 1 || M == -1
    if strcmp(upwind,'plus')
        eigenVals(1) = 0.5*(eigenVals(1) + sqrt(eigenVals(1)^2));
        eigenVals(2) = 0.5*(eigenVals(2) + sqrt(eigenVals(2)^2 + eps^2));
        eigenVals(3) = 0.5*(eigenVals(3) + sqrt(eigenVals(3)^2 + eps^2));
    else 
        eigenVals(1) = 0.5*(eigenVals(1) - sqrt(eigenVals(1)^2));
        eigenVals(2) = 0.5*(eigenVals(2) - sqrt(eigenVals(2)^2 - eps^2));
        eigenVals(3) = 0.5*(eigenVals(3) - sqrt(eigenVals(3)^2 - eps^2));
    end
    l1 = eigenVals(1); l2 = eigenVals(2); l3 = eigenVals(3);
elseif M ~= 1 && M ~= -1 && M~= 0
    %compute lambda+ and lambda
    if  strcmp(upwind,'plus') 
        l1 = max(0,eigenVals(1)); l2 = max(0,eigenVals(2)); l3 = max(0,eigenVals(3));
    elseif strcmp(upwind,'minus')
        l1 = min(0,eigenVals(1)); l2 = min(0,eigenVals(2)); l3 = min(0,eigenVals(3));
    else
        fprint('eulerFlux must be plus or minus')
        return
    end
end

%compute flux vector
dummy1 = zeros(3,1); dummy2 = dummy1; dummy3 = dummy2;

if l1 ~= 0
    dummy1 = [1; v; 0.5*v^2];
end

if l2 ~= 0
    dummy2 = [1; v+c; 0.5*v^2 + c^2/(gamma-1) + c*v];
end

if l3 ~= 0
    dummy3 = [1; v-c; 0.5*v^2 + c^2/(gamma-1) - c*v];
end

F = ((gamma - 1)/gamma)*rho*l1*dummy1 + ...
    ((rho*l2)/(2*gamma))*dummy2 + ...
    ((rho*l3)/(2*gamma))*dummy3;

return