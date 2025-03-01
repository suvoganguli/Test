function U_OUT = F16DYNINV(XD,X,XCG,XD_DES)
% f16 dynamics

% Author: Subhabrata Ganguli
%
% Ref: Stevens, Brian L.; Lewis, Frank L.; Johnson, Eric N.. 
% Aircraft Control and Simulation: Dynamics, 
% Controls Design, and Autonomous Systems. 
% Wiley.

U_OUT = zeros(4,1);

%% Parameters

IXX = 9496.0;
IYY = 55814.0;
IZZ = 63100.0;
IXZ =   982.0;

AXX = IXX;
AYY = IYY;
AZZ = IZZ;
AXZ = IXZ;

AXZS = AXZ^2;
XPQ  = AXZ * (AXX - AYY + AZZ);
GAM  = AXX * AZZ - AXZ^2;

XQR = AZZ * (AZZ - AYY) + AXZS;
ZPQ =(AXX-AYY) * AXX + AXZS;
YPR = AZZ - AXX;

WEIGHT = 25000.0;
GD = 32.174;
MASS = WEIGHT/GD;

S = 300;
B = 30;
CBAR = 11.32;
XCGR = 0.35;
HX = 160;
RTOD = 180/pi;

%% Assign State Variables

VT = X(1); 
ALPHA = X(2)*RTOD; 
BETA = X(3)*RTOD;
PHI = X(4); 
THETA = X(5); 
PSI = X(6);
P = X(7); 
Q = X(8); 
R = X(9); 
ALT = X(12); 
POW = X(13);

%% Air data computer and engine model

[TFAC, TEMP, RHO, AMACH, QBAR, PS ] = ADC(VT, ALT);

CPOW = PDOTINV_K(POW,XD_DES(13)-XD(13));
THTL = TGEARINV_K(CPOW);
T = THRUST(POW,ALT,AMACH);

QS    = QBAR * S; 
QSB   = QS * B; 
QHX   = Q*HX;

%% State varibles

CBTA  = cos(X(3)); 
U     = VT*cos(X(2))*CBTA;
V     = VT * sin(X(3)); 
W     = VT*sin(X(2))*CBTA;
STH   = sin(THETA); 
CTH   = cos(THETA);   
SPH   = sin(PHI);
CPH   = cos(PHI); 
SPSI  = sin(PSI);    
CPSI  = cos(PSI);
QS    = QBAR * S; 
QSB   = QS * B;        
RMQS  = QS/MASS;
GCTH  = GD * CTH; 
QSPH  = Q * SPH;

%% Forces

DUM   = (U*U + W*W);
AMAT = [ U  V  W;
        -W  0  U;
         0 VT  0];
BVEC = [VT*XD(1); DUM*XD(2); (DUM/CBTA)*XD(3) + V*XD(1)];

TMP = AMAT\BVEC;
UDOT = TMP(1);
VDOT = TMP(2);
WDOT = TMP(3);

CXT = ((UDOT - R*V + Q*W + GD*STH)*MASS - T)/QS;
AY = VDOT - P*W + R*U - GCTH * SPH;
AZ = WDOT - Q*U + P*V - GCTH * CPH;
CYT   = AY/RMQS; 
CZT   = AZ/RMQS;

%% Moments

PDOT_ = XD(7);
QDOT_ = XD(8);
RDOT_ = XD(9);

ROLL = IXX*PDOT_ - IXZ*RDOT_ + (IZZ-IYY)*Q*R - IXZ*P*Q;
PITCH = IYY*QDOT_ - YPR*R*P + IXZ*(P^2-R^2) + R*HX;
YAW = -IXZ*PDOT_ + IZZ*RDOT_ + (IYY-IXX)*P*Q + IXZ*Q*R - QHX;

CLT = ROLL/QSB;
CMT = PITCH/(QS *CBAR);
CNT = YAW/QSB;

TVT = 0.5/VT; 
B2V = B*TVT; 
CQ = CBAR*Q*TVT;

D = DAMP(ALPHA);

CXT = CXT - (CQ * D(1));
CYT = CYT - (B2V * (D(2)*R + D(3)*P ));
CZT = CZT - (CQ * D(4));
CLT = CLT - (B2V * ( D(5)*R + D(6)*P ));
CMT = CMT - (CQ * D(7) + CZT * (XCGR-XCG));
CNT = CNT - (B2V*(D(8)*R + D(9)*P) - CYT*(XCGR-XCG) * CBAR/B);

%% Look-up tables and component buildup
      
DLDA_OUT = DLDA(ALPHA,BETA);
DLDR_OUT = DLDR(ALPHA,BETA);
DNDA_OUT = DNDA(ALPHA,BETA);
DNDR_OUT = DNDR(ALPHA,BETA);

A1 = CL(ALPHA,BETA);
B1 = DLDA_OUT;
C1 = DLDR_OUT;
D1 = CLT;

A2 = CN(ALPHA,BETA);
B2 = DNDA_OUT;
C2 = DNDR_OUT;
D2 = CNT;

%DAIL1 = ((D1*B2-D2*B1) - (A1*B2-A2*B1))/(C1*B2-C2*B1)
%DRDR1 = ((D1*C2-D2*C1) - (A1*C2-A2*C1))/(B1*C2-B2*C1)

mat = [B1 C1;
        B2 C2];
vec = [(D1-A1); (D2-A2)];

inv = mat\vec;
DAIL = inv(1);
DRDR = inv(2);

EL = CMINV(CMT,ALPHA);
AIL = DAIL * 20.0; 
RDR = DRDR * 30.0;

U_OUT(1) = THTL;
U_OUT(2) = EL;
U_OUT(3) = AIL;
U_OUT(4) = RDR;

U_OUT = U_OUT(:);

end