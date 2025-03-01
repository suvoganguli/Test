% plot_K_pqr.m

% Author: Subhabrata Ganguli

%% setup
load trimcond.mat
load F16lin.mat

C_rate = C([7:9 13],:);

K_rate = 4*ones(4,1);
fc_rate = 1/2*ones(4,1);
fi_rate = 1/4*ones(4,1);

%% Doublet Commands

tstep = 0.1;
tdoublet = 2.5;

%% Closed Loop Sims

% roll rate
pc = 10; % deg/s
qc = 0; % deg/s
rc = 0; % deg/s

sim('F16_K_pqr')

figure(1); clf
subplot(321)
hp = plot(t, yc(:,1)*180/pi, 'k:', ...
    t, y(:,1)*180/pi, 'r-.');
set(hp,'LineWidth',2);
hold on
title('roll rate (deg/sec)')
ylabel('p (deg/sec)')
xlabel('t (sec)')

subplot(322);
plot(t, u(:,3), 'r', 'LineWidth', 2)
title('aileron (deg)')
ylabel('\delta_a (deg)')
xlabel('t (sec)')

% pitch rate
pc = 0; % deg/s
qc = 10; % deg/s
rc = 0; % deg/s
sim('F16_K_pqr')

subplot(323)
hp = plot(t, yc(:,2)*180/pi, 'k:', ...
    t, y(:,2)*180/pi, 'r-.');
set(hp,'LineWidth',2);
title('pitch rate (deg/sec)')
ylabel('q (deg/sec)')
xlabel('t (sec)')

subplot(324);
plot(t, u(:,2), 'r', 'LineWidth', 2)
title('elevator (deg)')
ylabel('\delta_e (deg)')
xlabel('t (sec)')

% yaw rate
pc = 0; % deg/s
qc = 0; % deg/s
rc = 10; % deg/s
sim('F16_K_pqr')

subplot(325)
hp = plot(t, yc(:,3)*180/pi, 'k:', ...
    t, y(:,3)*180/pi, 'r-.');
set(hp,'LineWidth',2);
title('yaw rate (deg/sec)')
ylabel('r (deg/sec)')
xlabel('t (sec)')

subplot(326);
plot(t, u(:,4), 'r', 'LineWidth', 2)
title('rudder (deg)')
ylabel('\delta_r (deg)')
xlabel('t (sec)')


%% Desired Dynamics

sim('DesDyn.slx');

figure(1);
subplot(321);
hold on;
plot(t,ydes,'g--', 'LineWidth', 2);
legend('pc','p','pdes')
subplot(323);
hold on;
plot(t, ydes,'g--', 'LineWidth', 2);
legend('qc','q','qdes')
subplot(325);
hold on;
plot(t,ydes,'g--', 'LineWidth', 2);
legend('rc','r','rdes')
