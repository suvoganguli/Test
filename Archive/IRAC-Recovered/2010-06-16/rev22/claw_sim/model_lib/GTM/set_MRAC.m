% set_MRAC
%
% Orig: 2/10/10
% Last: 2/10/10

% Note1 : Change all variables so that they are in a single data structure
% 

%% Preamble

dir = fileparts(mfilename('fullpath'));
addpath(fullfile(dir,'gtm','util_MRAC'));

%% Add all (additional) change notes in this area (2/10/10)

% Change 1: add some configuration inputs
flag_uad = 0;
flag_exsig = 0;
flag_gtm_ver = 2;           % 1 = V0905, 2 = V0912
flag_elastic_mode = 0;
flag_elastic_mode_shift = 0;

% Change 2: need to update the nominal plant parameters and trim values

% Change 3: need to update baseline claw gains

% Change 4: add simulation sample time
ts = dtsim;  % = dtsim

flag_runafterlin = 0;
if flag_runafterlin
    
    % These values are same from the linear design setup
    % delta_t = delta_t;
    % flag_autoadapt = flag_autoadapt;
    
    % Change 5: add MRAC parameters    
    in_Gamx = datain.var.Gamx;
    in_Gamtheta = 0;
    in_Q = datain.var.Q;

    % Change 7: add parameters for excitation signal
    in_gdoub = datain.var.gdoub*pi/180;  % rad/sec
    in_tdoub = datain.var.tdoub;
    in_ndoub = datain.var.ndoub;
    
    % Change 8: add error threshold mod
    in_error_thresh = datain.fix.error_thresh;
    
else
    %delta_t = input('Enter delta_t (from linear setup): ');   
    
    % Change x: add more pars
    delta_t = 2.5*0;
    flag_signaltype = 1;
    %in_tlength1 = 1;
    in_tadaptoff_forced = 10 + delta_t+200; 
    in_tadapton_forced  =  2.5+200;
       
    % Change 5: add MRAC parameters
    in_Q = 1e3;
    in_Gamx = 1e3;
    in_Gamtheta = 0;

    % Change 7: add parameters for excitation signal
    in_gdoub = 1.1*pi/180;  % rad/sec
    in_tdoub = 4;
    in_ndoub = 2;
    
    in_error_thresh = [inf;0.8*pi/180;inf]; % xc, q, alpha
    
    flag_autoadapt      = 1;
    
    in_t_timer  = 10; %in_tdoub*in_ndoub + in_tlength1;
    
end

% Change 6: add Kxstar for specific failure

in_DZkx = 0;
in_DZtheta = 0;

% Change 8: Add New Reference Model
% new stuff start/end

% Change 9: Add threshold signal value
% in_error_thresh = [inf; 0.6*pi/180; inf];
in_reset_stoptime = 0;
% 
% % Change 10: Forced Adaptation
% if flag_autoadapt == 0
%     data.fix.tadapton_forced  =  2.5;
%     data.fix.tadaptoff_forced =  10 + delta_t; 
% else
%     data.fix.tadapton_forced = 1e10;
%     data.fix.tadaptoff_forced = 1e10;
% end
% in_tadapton_forced = data.fix.tadaptoff_forced;

% Change 11: extend the sim time
config.tsim_max = config.tsim_max + delta_t - ts;
tsim_max = get_value('tsim_max');
if gtm_exptno == 1
    rate_cmd_fw = get_value('rate_cmd_fw');
elseif gtm_exptno == 3
    config.rate_cmd_fw(6:9,1) = config.rate_cmd_fw(6:9,1) + delta_t;
    rate_cmd_fw = get_value('rate_cmd_fw');
else
    ;
end

in_t_exsig = in_tadapton_forced;


%% From Plant_Params.m

% PLANT PARAMETERS

% -------------------------------------------------------
% nominal paramaters

% GTM Aircraft - Trimmed at EAS 75 knots, FPA = 0 deg, h = 800 ft
if flag_gtm_ver == 1
    error('Support removed');
    %load TrimPt_EAS75_V0905;
else
    load TrimPt_EAS75_V0912;
end

Mq = TrimPt.shortperiod.Mq;
Ma = TrimPt.shortperiod.Ma;
Zq = TrimPt.shortperiod.Zq;
Za = TrimPt.shortperiod.Za;
Md = TrimPt.shortperiod.Md;
Zd = TrimPt.shortperiod.Zd;

% trim value
V_trim      = TrimPt.Trimcond.tas*1.687; % fps
delta_trim  = TrimPt.Trimcond.elevator; % deg
altitude    = TrimPt.Trimcond.altitude; % ft
alpha_trim  = TrimPt.Trimcond.alpha; % deg

% elastic mode parameters
switch (flag_elastic_mode_shift)
    case 0
        w1 = 20; % rad/sec
        z1 = 0.01 ;
        Fd = -2.0 ; % (1/sec^2)/deg
        Fq = 0.03 ; % rad
        Fn = 0.1 ; % g's
        Fa = 0.01 ; % rad
    case 1
        w1 = 10; % rad/sec
        z1 = 0.001 ;
        Fd = -4.0 ; % (1/sec^2)/deg
        Fq = 0.03 ; % rad
        Fn = 0.1 ; % g's
        Fa = 0.01 ; % rad
end

% elastic mode on/off
switch flag_elastic_mode
    case 0
        int_etadot_A = [];
        int_etadot_B = [];
        int_etadot_C = [];
        int_etadot_D = 0;
        int_eta_A = [];
        int_eta_B = [];
        int_eta_C = [];
        int_eta_D = 0;
    case 1
        int_etadot_A = 0;
        int_etadot_B = 1;
        int_etadot_C = 1;
        int_etadot_D = 0;
        int_eta_A = 0;
        int_eta_B = 1;
        int_eta_C = 1;
        int_eta_D = 0;        
end



%% From Baseline_Claw.m

% BASELINE CLAW
% =============

% these are design parameters to create CV
kq = 1;
ka = 0;

[Ap,Bp,Cp,Dp] = linmod('sim_MRAC_Plant');
% make sure that the states are in order
eval('[d1,d2,d3,d4]= sim_MRAC_Plant;')
chk1 = strfind(d3(1),'int_q');
chk2 = strfind(d3(2),'int_alpha');
if isempty(chk1{1}) || isempty(chk1{1})
    error('Incorrect state order for linmod');
end

% DI TO LQR FRAMEWORK
% ===================

CA = [1 0]*Ap;
invCB = 1/Bp(1,1);
Kb = 10;
fi = 1/4;
fc = 1/2*0;


%% From Create_Adaptive_Claw.m

% CREATE ADAPTIVE CLAW

KqI = - invCB * Kb * fi * Kb;
Kq  = invCB * ( -Kb - CA(1));
Ka  = invCB * ( - CA(2));

% OLD LQR DESIGN
%KqI = 10;
%Kq = 10.7432;
%Ka = 3.2433;

Kxnom = [KqI Kq Ka]';
Krnom = 0;

% ======================================
% AUGMENTED SYSTEM
% ======================================

A = zeros(3,3);
A(1,2) = 1;
A(2:3,2:3) = Ap;
B1 = [0; Bp];
B2 = [-1; 0; 0];

% ======================================
% REFERENCE MODEL
% ======================================

Am = A + B1*Kxnom';
Bm = B2;

% new stuff start ------------------------------

% Alon = TrimPt.lonsys.a;      % x = [u w q theta]
% Blon = TrimPt.lonsys.b(:,1);  % u = [de dspL dspR thL thR]
% Clon = [0 0 1 0;
%         0 1/V_trim 0 0;];
% 
% lonxm0 = 0*TrimPt.StatesInp([1 3 5 11]);

% new stuff end --------------------------------

% ======================================
% ADAPTIVE LAW DESIGN PARAMS
% ======================================

Q = in_Q*diag([1,1,0]);
P = lyap(Am',Q);

Gamx = in_Gamx*eye(3);
% Gamx(2,2) = Gamx(2,2)*1
% Gamx(3,3) = Gamx(3,3)*6

Nrbf = 11;
Gamtheta = in_Gamtheta*eye(Nrbf);
C = [-10:2:10]*pi/180;     % centers for alpha
Sig = (0.0116/sqrt(2))*ones(Nrbf,1);

% DEADZONE
DZkx = in_DZkx;
DZtheta = in_DZtheta;

% IDEAL ADAPTIVE GAINS
% - calculated in Create_Failure

% INITIAL CONDITION
Kxhat0 = zeros(3,1);
Thetahat0 = zeros(11,1);
xm0 = zeros(3,1);
nx = 3;
nr = 1;

%% From Create_Failure

p1 = 1;     % Ma
p2 = 1;     % Mq (0.2)
%p3 = 0.5;   % Md, Zd
p4 = 1;     % Za

if actfail_case == 0
    p3 = 1;
elseif actfail_case == 3
    p3 = cell2mat(config.fail_surfs(3,3)); % Md, Zd
else
    %keyboard
    p3 = 0.5;
end

K1 = 1/p3;
K2 = ((1-p2)*Mq + Md*Kq)/(p3*Md*Kq);
K3 = ((1-p1)*Ma + Md*Ka)/(p3*Md*Ka);

KqIstar = K1*KqI;
Kqstar  = K2*Kq;
Kastar  = K3*Ka;
Kxstar  = [KqIstar Kqstar Kastar]';

%% From Construct_Excitation_Signal

dum_exsig_vecin  = [0   in_tdoub/2   in_tdoub];
dum_exsig_vecout = [0   1            -1      ]*in_gdoub;

in_exsig_vecin = [];
if (in_ndoub == 0)
    in_exsig_vecin  = 0;
    in_exsig_vecout = 0;
else
    for ii = 1:in_ndoub
        if isempty(in_exsig_vecin)
            lastval = 0;
        else
            lastval = in_exsig_vecin(end);
        end
        in_exsig_vecin  = [in_exsig_vecin dum_exsig_vecin(2:3)+lastval];
    end
    in_exsig_vecout = repmat(dum_exsig_vecout(2:3),1,in_ndoub);
end

% end forcing to be zero
in_exsig_vecin  = [in_exsig_vecin in_exsig_vecin(end)+in_tdoub/2];
in_exsig_vecout = [in_exsig_vecout 0];

% contructing end time for excitation signal
% if flag_signaltype == 0 
%     in_t_timer = datain.fix.timer_sin;
% else
%     in_t_timer  = in_tdoub*in_ndoub + in_tlength1;
% end

