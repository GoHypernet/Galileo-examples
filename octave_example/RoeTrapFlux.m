function [flux] = RoeTrapFlux(W2,W1,W,Wm1)

gamma = 1.4;
%first build primatives
u2  = [W2(1);  W2(2)/W2(1);   ((gamma-1)*(W2(3)  - 0.5*W2(1)*(W2(2)/W2(1))^2))];
u1  = [W1(1);  W1(2)/W1(1);   ((gamma-1)*(W1(3)  - 0.5*W1(1)*(W1(2)/W1(1))^2))];
u   = [W(1);   W(2)/W(1);     ((gamma-1)*(W(3)   - 0.5*W(1)*(W(2)/W(1))^2))];
um1 = [Wm1(1); Wm1(2)/Wm1(1); ((gamma-1)*(Wm1(3) - 0.5*Wm1(1)*(Wm1(2)/Wm1(1))^2))];

%now compute slope limiters

rpi = (u1 - u)./(u - um1);
rm1 = (u1 - u)./(u2 - u1);

phii = zeros(3,1);  
phi1 = zeros(3,1);  
toler = 1e-1;
for i = 1:3   
    if abs(u1(i) - u(i)) < toler && abs(u(i) - um1(i)) < toler
        phii(i) = 1;
    else
        phii(i) = max(0,min(1,rpi(i)));    
    end
    if abs(u1(i) - u(i)) < toler && abs(u2(i) - u1(i)) < toler
        phi1(i) = 1;
    else
        phi1(i) = max(0,min(1,rm1(i)));    
    end        
end

%compute linear reconstruction of primatives with left bias
uL = u  + 0.5*phii.*(u-um1); 
WL = [uL(1); uL(1)*uL(2); ((uL(3)/(gamma-1)) + 0.5*uL(1)*uL(2)^2)];

uR = u1 - 0.5*phi1.*(u2-u1); 
WR = [uR(1); uR(1)*uR(2); ((uR(3)/(gamma-1)) + 0.5*uR(1)*uR(2)^2)];

%compute second order temporal evolution
flux = RoeFlux(WL,WR);

return