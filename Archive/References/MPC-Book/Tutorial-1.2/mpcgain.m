function [Phi_Phi, Phi_F, Phi_R, Phi, F, Phix, Fx, A_e, B_e, C_e] = ...
    mpcgain(Ap, Bp, Cp, Nc, Np)

[m1,~] = size(Cp);
[n1,n_in] = size(Bp);
A_e = eye(n1+m1,n1+m1);
A_e(1:n1,1:n1) = Ap;
A_e(n1+1:n1+m1,1:n1) = Cp*Ap;
B_e = zeros(n1+m1,n_in);
B_e(1:n1,:) = Bp;
B_e(n1+1:n1+m1,:) = Cp*Bp;
C_e = zeros(m1,n1+m1);
C_e(:,n1+1:n1+m1) = eye(m1);

n = n1+m1;
h(1,:) = C_e;
hx(1,:) = [ones(1,n1) 0];

F(1,:) = C_e*A_e;
Fx(1:n,:) = blkdiag(eye(n-m1),0*m1)*A_e;

for kk=2:Np
    h(kk,:) = h(kk-1,:)*A_e;
    F(kk,:) = F(kk-1,:)*A_e;
    
    hx(kk,:) = hx(kk-1,:)*A_e;
    Fx(kk+n-1:kk+2*n-2,:) = Fx(kk-1:kk+n-2,:)*A_e;
end

v = h*B_e;
vx = hx*B_e;

Phi = zeros(Np,Nc);
Phi(:,1) = v;
Phix(:,1) = vx;

for i=2:Nc
    Phi(:,i) = [zeros(i-1,1);v(1:Np-i+1,1)];
    Phix(:,i) = [zeros(i-1,1);vx(1:Np-i+1,1)];
end

BarRs = ones(Np,1);
Phi_Phi = Phi'*Phi;
Phi_F = Phi'*F;
Phi_R = Phi'*BarRs;



