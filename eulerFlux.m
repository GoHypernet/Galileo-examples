function [flux] = eulerFlux(u)

gamma = 1.4;
e = (u(3)/(gamma-1)) + 0.5*u(1)*u(2)^2;

flux = [u(1)*u(2);
        u(1)*u(2)^2 + u(3);
        (e+u(3))*u(2)];
        
return