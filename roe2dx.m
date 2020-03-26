function F_0 = roe2dx(W_R,W_L)

% Algorithm to implement Roe's first-order upwind approximate Riemann
% solver for the fluxes in the x-direction.
%
% Input definitions:
%      gamma is the ratio of specific heats
%      W_R is the right state vector
%      W_L is the left state vector
%
% Output definitions:
%      W is the state vector at x,t **(currently disabled; must add W1,W2,W3
%      back to function output and uncomment code at the end)**
%      F_0 is the flux vector at x = 0
%
% The state vector W is described by
% W(x,t) = (rho,rho*u,E)' = (W(1),W(2),W(3))'
gamma = 1.4;
u_R = W_R(2)/W_R(1);
u_L = W_L(2)/W_L(1);
v_R = W_R(3)/W_R(1);
v_L = W_L(3)/W_L(1);
H_R = gamma*W_R(4) - 1/2*(gamma-1)*(W_R(2)^2+W_R(3)^2)/W_R(1);
H_L = gamma*W_L(4) - 1/2*(gamma-1)*(W_L(2)^2+W_L(3)^2)/W_L(1);

% Calculating Roe's average values:

rho_RL = sqrt(W_R(1)*W_L(1));
u_RL = (sqrt(W_L(1))*u_L+sqrt(W_R(1))*u_R)/(sqrt(W_L(1))+sqrt(W_R(1)));
v_RL = (sqrt(W_L(1))*v_L+sqrt(W_R(1))*v_R)/(sqrt(W_L(1))+sqrt(W_R(1)));
h_RL = (H_L/sqrt(W_L(1))+H_R/sqrt(W_R(1)))/(sqrt(W_L(1))+sqrt(W_R(1)));
E_RL = h_RL/gamma + (gamma-1)/(2*gamma)*rho_RL*(u_RL^2+v_RL^2);

% Constructing Roe's Jacobian matrix:

A_RL = [0 1 0 0;1/2*(gamma-1)*(u_RL^2+v_RL^2)-u_RL^2 (3-gamma)*u_RL -(gamma-1)*v_RL gamma-1;-u_RL*v_RL v_RL u_RL 0;(gamma-1)*u_RL*(u_RL^2+v_RL^2)-gamma*E_RL*u_RL/rho_RL gamma*E_RL/rho_RL-1/2*(gamma-1)*(u_RL^2+v_RL^2)-(gamma-1)*u_RL^2 -(gamma-1)*u_RL*v_RL gamma*u_RL];

% Computing the eigenvalues and corresponding eigenvectors of A:

[Q L] = eig(A_RL);
L_abs = abs(L);
A_abs = Q*L_abs/Q;

% Computing the flux vector at x=0:

F_0 = 1/2*A_RL*(W_R+W_L) - 1/2*A_abs*(W_R-W_L);