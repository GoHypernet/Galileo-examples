function [F_x] = RoeFlux2D(WL,WR,varargin)


  gamma = 1.4;
  rhol  = WL(1);
  rhor  = WR(1);
  ul    = WL(2)/rhol;
  ur    = WR(2)/rhor;
  vl    = WL(3)/rhol;
  vr    = WR(3)/rhor;
  Hl    = gamma*WL(4)-0.5*(gamma-1)*rhol*(ul^2+vl^2);
  Hr    = gamma*WR(4)-0.5*(gamma-1)*rhor*(ur^2+vr^2);

  rhorl = sqrt(rhor*rhol);
  url   = (sqrt(rhor)*ur+sqrt(rhol)*ul)/(sqrt(rhor)+sqrt(rhol));
  vrl   = (sqrt(rhor)*vr+sqrt(rhol)*vl)/(sqrt(rhor)+sqrt(rhol));
  hrl   = (Hr/sqrt(rhor)+Hl/sqrt(rhol))/(sqrt(rhor)+sqrt(rhol));
  prl   = ((gamma-1)/gamma)*(hrl - (1/2)*rhorl*(url^2 + vrl^2));
  
  B = [1               0          0        0;
       url             rhorl      0        0;
       vrl             0          rhorl    0;
      (url^2+vrl^2)/2  rhorl*url rhorl*vrl 1/(gamma-1)];
      
  xory = varargin{1};
  if xory == 'x'

      F = [url                rhorl                                         0             0;
           url^2              2*rhorl*url                                   0             1;
           url*vrl            rhorl*vrl                                     rhorl*url     0;
          (url^3+url*vrl^2)/2 rhorl*(3*url^2+vrl^2)/2+(gamma*prl)/(gamma-1) rhorl*url*vrl gamma*url/(gamma-1)];
      
  elseif xory == 'y'      

      F = [vrl                0             rhorl                                         0;
           url*vrl            rhorl*vrl     rhorl*url                                     0;
           vrl^2              0             2*rhorl*vrl                                   1;          
          (vrl^3+url^2*vrl)/2 rhorl*url*vrl rhorl*(url^2+3*vrl^2)/2+(gamma*prl)/(gamma-1) gamma*vrl/(gamma-1)];
  else
      error('must pick x or y');
  end
    
   Arl = F*B^-1;

      
   [rEigV,Eigval] = eig(Arl);
   lEigV = rEigV^-1;
   
     EigvalPlus = abs(Eigval);

F_x = 0.5*Arl*(WR+WL) - ...
         0.5*rEigV*EigvalPlus/rEigV*(WR-WL);

   if length(varargin) == 2
       F_x
   end
     
return