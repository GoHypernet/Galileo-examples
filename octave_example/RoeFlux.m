function [F_x] = RoeFlux(WL,WR,varargin)


  gamma = 1.4;
  rhol = WL(1);
  rhor = WR(1);
  ul = WL(2)/rhol;
  ur = WR(2)/rhor;
  Hl = gamma*WL(3)-0.5*(gamma-1)*rhol*ul^2;
  Hr = gamma*WR(3)-0.5*(gamma-1)*rhor*ur^2;

  %rhorl = sqrt(rhor*rhol);
  url = (sqrt(rhor)*ur+sqrt(rhol)*ul)/(sqrt(rhor)+sqrt(rhol));
  Hrl = (Hr/sqrt(rhor)+Hl/sqrt(rhol))/(sqrt(rhor)+sqrt(rhol));
    
   Arl = [ 0,                           1,                   0;
       (gamma-3)/2*url^2,            (3-gamma)*url,       gamma-1;
       -url*Hrl+0.5*(gamma-1)*url^3, Hrl-(gamma-1)*url^2, gamma*url];

   [rEigV,Eigval] = eig(Arl);
   lEigV = rEigV^-1;
    
   EigvalPlus = abs(Eigval);
   
   F_x = 0.5*Arl*(WR+WL) - ...
         0.5*rEigV*EigvalPlus/rEigV*(WR-WL);

return