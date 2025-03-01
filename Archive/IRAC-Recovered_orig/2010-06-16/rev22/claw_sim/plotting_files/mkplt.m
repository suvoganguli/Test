compare_plot = ishandle(2);

if(~compare_plot)
%     close all
    line1 = '-';
    line2 = ':';
else
    line1 = '-.';
    line2 = '--';
end

% configuration flags --- see set_MACH_def.m for details
plot_udot = get_value('plot_udot') ;
plot_attdot = get_value('plot_attdot') ;
plot_photo = get_value('plot_photo') ;
plot3D = get_value('plot3D') ;
plot_traj = get_value('plot_traj') ;
plot_homing = get_value('plot_homing') ;
plot_fltpath = get_value('plot_fltpath') ;
enable_ideal = get_value('enable_ideal') ;
show_along_fltpath = get_value('show_along_fltpath') ;
show_surf_limits = get_value('show_surf_limits') ;
t_trim = get_value('t_trim') ;
set_paper_position = get_value('set_paper_position') ;


% ---------------------------------------------------------
% over-writing some plots for convenience - suvo (10/22/09)

show_surf_limits = 0;

% ---------------------------------------------------------



% logicals for loop plots
% Note: show_x_cmd has precedence over show_x_ideal

% true for the following values means that command will be shown
% in addition to actual value
show_pos_cmd = mode > modes.pos || 1 ;
show_vel_cmd = mode > modes.vel || 1 ;
show_att_cmd = mode > modes.att || 1 ;
show_rate_cmd = mode > modes.rate ;

% true for the following values means that ideal will be shown
% in addition to actual value if the corresponding 'show_x_cmd' is false
if(enable_ideal)
    show_pos_ideal = mode >= modes.vel ;
    show_vel_ideal = mode == modes.vel ;
    show_att_ideal = mode >= modes.rate ;
    show_rate_ideal = mode == modes.rate ;
else
    show_pos_ideal = 0 ;
    show_vel_ideal = 0 ;
    show_att_ideal = 0 ;
    show_rate_ideal = 0 ;
end

use_NE_NM = 0 ;
if( use_NE_NM )
    pos_units = {'NM', 'NM', 'ft'} ;
    pos_scaling = [1/constants.nm2ft 1/constants.nm2ft 1] ;
else
    pos_units = {'ft', 'ft', 'ft'} ;
    pos_scaling = [1 1 1] ;
end

use_accel_g = 1 ;
if( use_accel_g )
    accel_units = 'g' ;
    accel_scaling = 1/constants.g ;
else
    accel_units = 'ft/sec2' ;
    accel_scaling = 1 ;
end

use_att_deg = 1 ;
if( use_att_deg )
    att_units = 'deg' ;
    att_scaling = constants.r2d ;
else
    att_units = 'rad' ;
    att_scaling = 1 ;
end

% get angle names corresponding to att_cmds order
att_angles = MACH.att_angles(MACH.att_type,:) ;

% the flag printoption controls whether plots go to screen (=0), get paused (=2), 
% or go to the printer (=1)
if(~exist('printoption'))
    printoption = 0;
end

% to add date and time to plots
titledate = datestr(clock,0) ;

% sample out tmin < t < tmax
% tmin and tmax are assumed to be set externally
tm = find(t >= tmin & t <= tmax) ;
tm1 = find(t1 >= tmin & t1 <= tmax) ;
t1plot = t1(tm1) ;
t1min = t1plot(1) ;
t1max = t1plot(end) ;

% u = u_cmd ; % use the commands with one MACH.dt delay at input to servos
u = u_out ; % use the computed commands without transport delay for plotting

wind_min = min(max(winds)) ;
wind_max = max(max(winds)) ;
plot_wind = wind_max > 1.e-3 | wind_min < 1.e-3 ;

cv_rate_idx = 1:3 ;
cv_att_idx = 4:7 ;
cv_vel_idx = 8:10 ;
cv_pos_idx = 11:13 ;

y_accel_idx = 1:3 ;
y_accel_cg_idx = 4:6 ;
y_dircos_idx = 7:15 ;
y_uvw_rw_idx = 16:18 ;
y_tiltcam_idx = 19:21 ;
y_rpy_idx = 22:24 ;
y_mab_idx = 25:27 ;
y_mass_idx = 28 ;
y_aero_mach_idx = 29 ;
y_aero_sos_idx = 30 ;
y_aero_rho_idx = 31 ;
y_aero_qbar_idx = 32 ;
y_aero_vel_idx = 33 ;
y_aero_alpha_idx = 34 ;
y_aero_beta_idx = 35 ;
y_aero_h_idx = 36 ;
y_aero_uvw_rw_idx = 37:39 ;
y_atmos_P_idx = 40 ;
y_atmos_T_idx = 41 ;
y_LOS_rate_idx = 42:43 ;
y_LOS_angle_idx = 44:45 ;
y_target_range_idx = 46:47 ;
y_dc_L2W_idx = 48:56 ;

y_accel = y(:,y_accel_idx) ;
y_accel_cg = y(:,y_accel_cg_idx) ;
y_dircos = reshape(y(:,y_dircos_idx),size(y,1),3,3);
y_aero_qbar = y(:,y_aero_qbar_idx) ;
y_aero_mach = y(:,y_aero_mach_idx) ;
y_aero_uvw_rw = y(:,y_aero_uvw_rw_idx) ;
y_mass = y(:,y_mass_idx) ;
y_LOS_rate = y(:,y_LOS_rate_idx) ;
y_LOS_angle = y(:,y_LOS_angle_idx) ;
y_target_range = y(:,y_target_range_idx) ;

use_sim_angles = 1 ;
if(use_sim_angles || size(y,2) < min(y_dc_L2W_idx))
    y_tiltcam = y(:,y_tiltcam_idx) ;
    y_rpy = y(:,y_rpy_idx) ;
    y_mab = y(:,y_mab_idx) ;
else
    y_tiltcam = q2euler(y_dircos,att_type.tiltcam,1:3) ;
    y_rpy = q2euler(y_dircos,att_type.ypr_bank,1:3) ;
    y_dc_L2W = reshape(y(:,y_dc_L2W_idx),size(y,1),3,3) ;
    y_mab = q2euler(y_dircos,att_type.mba_bank,1:3,y_dc_L2W) ;
end

x_pos = x(:,MACH.NEh_idx) ;
xdot_vel = xdot(:,MACH.NEh_idx) ;
x_quat = x(:,MACH.quat_idx) ;
x_pqr = x(:,MACH.pqr_idx) ;

% first check if limiting occured and then plot
thresh_limiting = 1.e-5 ;
cvdex_max = max(abs(cvdex(tm1,:))) ;
plot_rateatt_cvdex = 0 ;
plot_velpos_cvdex = 0 ;

cvdex_max_max = max(cvdex_max) ;
if( cvdex_max_max < thresh_limiting )
    disp('no limiting occured')
else
    cvdex_rate = cvdex_max(cv_rate_idx) ;
    cvdex_att = cvdex_max(cv_att_idx) ;
    cvdex_vel = cvdex_max(cv_vel_idx) ;
    cvdex_pos = cvdex_max(cv_pos_idx) ;
    if( max(cvdex_rate) > thresh_limiting ) 
        disp(sprintf('limiting in rate loops did occur, cvdex_rate = %s', num2str(cvdex_rate)))
        plot_rateatt_cvdex = 1 ;
    end
    if( max(cvdex_att) > thresh_limiting )
        disp(sprintf('limiting in att loops did occur, cvdex_vel = %s', num2str(cvdex_att)))
        plot_rateatt_cvdex = 1 ;
    end
    if( max(cvdex_vel) > thresh_limiting )
        disp(sprintf('limiting in vel loops did occur, cvdex_vel = %s', num2str(cvdex_vel)))
        plot_velpos_cvdex = 1 ;
    end
    if( max(cvdex_pos) > thresh_limiting )
        disp(sprintf('limiting in pos loops did occur, cvdex_pos = %s', num2str(cvdex_pos)))
        plot_velpos_cvdex = 1 ;
    end
end

plotB = -1 ; % 0 => skip B plots; 1 => always do B plots; -1 => do only with high condition number

fltpath_mode = all(u_llim_vel(:,3:end) == u_ulim_vel(:,3:end),2);

if(plotB)
    plotB = min(plotB,0) ;
    cond_thresh = 5 ;
    det_thresh = 0.01 ;

    % >>>> GET THE CONDITION NUMBERS OF BOTH B MATRICES AT EACH INSTANT <<<
    
    % We enter fltpath mode (zero weighting along path) whenever throttle
    % is fixed
    Bcond_vel = zeros(length(tm1),1) ;
    Bcond_rate = zeros(length(tm1),1) ;
    Bdet_vel = zeros(length(tm1),1) ;
    for i = 1:length(tm1)
        tm1i = tm1(i) ;
        if(fltpath_mode(tm1i))
            % if in fltpath mode, the actual allocation problem is
            % contained in the lower right 2x2 of Bmat_fltpath
            Bcond_vel(i) = cond(Bmat_fltpath(2:3,1:2,tm1i)) ;
        else
            Bcond_vel(i) = cond(Bmat_vel(:,:,tm1i)) ;
        end
        Bdet_vel(i) = det(Bmat_fltpath(2:3,1:2,tm1i)) ;
        Bcond_rate(i) = cond(Bmat_rate(:,:,tm1i)) ;
    end

    Bmaxc_rate = max(Bcond_rate) ;    
    Bmaxc_vel = max(Bcond_vel) ;  
    Bmind_vel = min(abs(Bdet_vel)) ;  

    if( Bmaxc_rate > cond_thresh )
        plotB = 1 ;
        disp(sprintf('high condition number for Bmat_rate = %g', Bmaxc_rate))
    end
    if( Bmaxc_vel > cond_thresh )
        plotB = 1 ;
        disp(sprintf('high condition number for Bmat_vel = %g', Bmaxc_vel))
    end
    if( Bmind_vel < det_thresh )
        plotB = 1 ;
        disp(sprintf('small determinant for Bmat_vel = %g', Bmind_vel))
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)

pos_label = {'North', 'East', 'altitude'} ;

for iplot = 1:3
    subplot(3,1,iplot); hold on
    if( show_pos_cmd )
        plot(t(tm),pos_scaling(iplot)*x_pos(tm,iplot),line1,t1(tm1),pos_scaling(iplot)*cvc(tm1,cv_pos_idx(iplot)),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( show_pos_ideal )
        plot(t(tm),pos_scaling(iplot)*x_pos(tm,iplot),line1,t1(tm1),pos_scaling(iplot)*ideal_pos(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),pos_scaling(iplot)*x_pos(tm,iplot))
    end
    ylabel([pos_label{iplot} ' (' pos_units{iplot} ')'])
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Velocity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)

vel_label = {'Nd', 'Ed', 'hd'} ;

for iplot = 1:3
    subplot(3,1,iplot); hold on
    if( show_vel_cmd )
        plot(t(tm),xdot_vel(tm,iplot),line1,t1(tm1),cvc(tm1,cv_vel_idx(iplot)),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( show_vel_ideal )
        plot(t(tm),xdot_vel(tm,iplot),line1,t1(tm1),ideal_vel(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),xdot_vel(tm,iplot))
        if( iplot == 1 )
            legend('actual')
        end
    end
    ylabel([vel_label{iplot} ' (ft/sec)'])
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%%%%%%%% Attitude (Quaternions) %%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)

att_label = {'e0', 'e1', 'e2', 'e3'} ;

for iplot = 1:4
    subplot(4,1,iplot); hold on
    if( show_att_cmd )
        plot(t(tm),x_quat(tm,iplot),line1,t1(tm1),cvc(tm1,cv_att_idx(iplot)),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( show_att_ideal )
        plot(t(tm),x_quat(tm,iplot),line1,t1(tm1),ideal_quat(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),x_quat(tm,iplot))
        if( iplot == 1 )
            update_legend('actual')
        end
    end
    ylabel(att_label{iplot})
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angular Rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5)

rate_label = {'p', 'q', 'r'} ;

for iplot = 1:3    
    subplot(3,1,iplot); hold on
    if( show_rate_cmd )
        plot(t(tm),x_pqr(tm,iplot),line1,t1(tm1),cvc(tm1,cv_rate_idx(iplot)),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( show_rate_ideal )
        plot(t(tm),x_pqr(tm,iplot),line1,t1(tm1),ideal_pqr(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),x_pqr(tm,iplot))
        if( iplot == 1 )
            update_legend('actual')
        end
    end
    ylabel([rate_label{iplot} ' (rad/sec)'])
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%% Plot attitude as phi_b, theta_b, psi_b %%%%%%%%%%%%%%%%%%%%%
% These are the 'classical' Euler angles, zero when body axes are aligned
% as [x, y, z] => [N, E, D]
% only show this plot if it is different from the airplane/propulsion axis
% relative angles (see Figure 22)

if(max(max(abs(MACH.body2horz - eye(3)))) > 0)
    figure(6)

    att_label = {'phi_b', 'theta_b', 'psi_b'} ;
    y_att = dc2rot(y_dircos, 'zyx') ;
    att_cmds = rpy_cmds ;
    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t(tm),att_scaling*y_att(tm,iplot),line1)
        if( iplot == 1 )
            update_legend('actual')
        end
        ylabel([att_label{iplot} ' (' att_units ')'])
    end
    
end

xlabel('time (sec)')
printpause

if( plot_rateatt_cvdex )
    %%%%%%%%%%%%%%%%% Rate Loops and Attitude Loops CVDEX %%%%%%%%%%%%%%%%%
    figure(7); clf
    
    subplot(2,1,1)
    plot(t1(tm1),cvdex(tm1,1),'-',t1(tm1),cvdex(tm1,2),':',t1(tm1),cvdex(tm1,3),'-.')
    legend('pd','qd','rd')
    ylabel('pqr cvdex (rad/sec ^2)')
    
    subplot(2,1,2)
    plot(t1(tm1),cvdex(tm1,4),'-',t1(tm1),cvdex(tm1,5),':',t1(tm1),cvdex(tm1,6),'-.',t1(tm1),cvdex(tm1,7),'--')
    legend('e0d','e1d','e2d','e3d')
    ylabel('att cvdex (rad/sec)')
    
    xlabel('time (sec)')
    printpause
end ;

if( plot_velpos_cvdex )
    %%%%%%%%%%%%%% Velocity Loops and Position Loops CVDEX %%%%%%%%%%%%%%%%
    figure(8); clf
    
    subplot(2,1,1)
    if( plot_fltpath )
        if( show_along_fltpath )
            plot(t1(tm1),cvdex_fltpath(tm1,1),'-',t1(tm1),cvdex_fltpath(tm1,2),':',t1(tm1),cvdex_fltpath(tm1,3),'-.')
            legend('along path accel','cross path accel','vertical normal accel')
        else
            plot(t1(tm1),cvdex_fltpath(tm1,2),'-',t1(tm1),cvdex_fltpath(tm1,3),':')
            legend('cross path accel','vertical normal accel')
        end
    else
        plot(t1(tm1),cvdex(tm1,8),'-',t1(tm1),cvdex(tm1,9),':',t1(tm1),cvdex(tm1,10),'-.')
        legend('Ndd','Edd','hdd')
    end
    ylabel('vel cvdex (ft/sec  ^2)')

    subplot(2,1,2)
    plot(t1(tm1),cvdex(tm1,11),'-',t1(tm1),cvdex(tm1,12),':',t1(tm1),cvdex(tm1,13),'-.')  
    legend('Nd','Ed','hd')
    ylabel('pos cvdex (ft/sec)')
    
    xlabel('time (sec)')
    printpause
end

%%%%%%%%%%%%%%%%%%%%%%%% Accelerometers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(9)

accel_label = {'axa', 'aya', 'aza'} ;

if( use_wind_est )
    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t(tm),accel_scaling*y_accel_cg(tm,iplot),line1,t1(tm1),accel_scaling*accels(tm1,iplot),line2) 
        if( iplot == 1 )
            update_legend('actual','model')
        end
        ylabel([accel_label{iplot} ' (' accel_units ')'])
    end
else
    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t(tm),accel_scaling*y_accel_cg(tm,iplot),line1)
        if( iplot == 1 )
            update_legend('actual')
        end
        ylabel([accel_label{iplot} ' (' accel_units ')'])
    end   
end

xlabel('time (sec)')
printpause
    
if( use_wind_est )
    %%%%%%%%%%%%%%%%%%%%% Relative Wind Estimate %%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(10)
    
    wind_label = {'u', 'v', 'w'} ;

    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t(tm),y_aero_uvw_rw(tm,1),line1,t1(tm1),uvw_rw_est(tm1,1),line2)
        if( iplot == 1 )
            update_legend('actual','estimate')
        end
        ylabel([wind_label{iplot} ' rw (ft/sec)'])
    end
        
    xlabel('time (sec)')
    printpause
end

if( plot_wind )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Winds %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure(11)
    
    wind_label = {'N', 'E', 'D'} ;

    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t(tm),winds(tm,iplot),line1,t1(tm1),w_est(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','estimate')
        end
        ylabel([wind_label{iplot} ' wind (ft/sec)'])
    end
    
    xlabel('time (sec)')
    printpause
end

if( plotB )
    %%%%%%%%%%%%%%%%%%%%%%%% THE RATE B MATRIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Imax = size(Bmat_rate,1) ;
    
    uidx = MACH.pqr_u_idx ;
    if(~use_tvc)
        % exclude tvc plots
        uidx = setdiff(uidx,MACH.tvc_idx) ;
    end
    if(~use_rcs || 1)
        % exclude rcs plots
        % for now, always exclude rcs, since allocation is not through SMN
        uidx = setdiff(uidx,MACH.rcs_idx) ;
    end

    Jmax_all = length(uidx) ;

    nfig_Brate = ceil(Jmax_all/4) ;
    
    for ifig = 1:nfig_Brate
        
        Jmax = min(4,Jmax_all-(ifig-1)*4) ;

        figure(11+ifig); clf

        k = 0;
        for i = 1:Imax
            for j = 1:Jmax
                k = k + 1 ;
                col_idx = j + (ifig-1)*4 ;
                btmp = squeeze(Bmat_rate(i,col_idx,:)) ;
                subplot(Imax,Jmax,k), plot(t1(tm1),btmp(tm1)) 
                subplot(Imax,Jmax,Jmax*fix(Imax/2)+j), title(MACH.u_names{uidx(col_idx)})
            end
        end
        if( nfig_Brate > 1)
            part_label = sprintf(' (part %d)', ifig) ;
        else
            part_label = '' ;
        end
        subplot(Imax,Jmax,Jmax*fix(Imax/2)+1), ylabel(['Bmat rate' part_label])
        subplot(Imax,Jmax,(Imax-1)*Jmax+fix((Jmax+1)/2)), xlabel('time (sec)')
        printpause
    end
    
    if(use_rcs)
        % add rcs back in for later effector plots
        uidx = union(uidx,MACH.rcs_idx) ;
    end

    %%%%%%%%%%%%%%%%%%%%%%% THE VELOCITY B MATRIX %%%%%%%%%%%%%%%%%%%%%%%%%
    figure(17); clf
    
    Imax = size(Bmat_vel,1) ;
    col_names = att_angles(1:2) ;
    if(use_throt)
        col_names = horzcat(col_names, MACH.u_names(MACH.throttle_idx)) ;
    end
    Jmax = length(col_names) ;
        
    k = 0;
    for i = 1:Imax
        for j = 1:Jmax
            k = k + 1 ;
            btmp = squeeze(Bmat_vel(i,j,:)) ;
            subplot(Imax,Jmax,k), plot(t1(tm1),btmp(tm1)) 
            subplot(Imax,Jmax,Jmax*fix(Imax/2)+j), title(col_names(j))
        end
    end
    subplot(Imax,Jmax,Jmax*fix((Imax-1)/2)+1), ylabel('Bmat vel')
    subplot(Imax,Jmax,(Imax-1)*Jmax+fix((Jmax+1)/2)), xlabel('time (sec)')
    printpause
        
    %%%%%%%%%%%%% PLOT THE CONDITION NUMBERS OF BOTH B MATRICES %%%%%%%%%%%
    figure(18); clf
    
    subplot(3,1,1)
    plot(t1(tm1),Bcond_rate)
    ylabel('Rate Condition no.'), 
    
    subplot(3,1,2)
    plot(t1(tm1),Bcond_vel)
    ylabel('Velocity Condition no.')

    subplot(3,1,3)
    plot(t1(tm1),Bdet_vel)
    ylabel('Velocity Determinant')

    xlabel('time')
    printpause
end

%%%%%%%%%%%%%%%%% Overlay Horizontal Path on Aerial Photo %%%%%%%%%%%%%%%%%
figure(19)
subplot(1,1,1); hold on

if( plot_photo )
    photo = imread('testarea.jpg') ;
    xx(1) = -611.0;
    xx(2) = 858.1;
    % N position of pad appears to be off by about 15 ft [2003-08-08 SGP]
    % yy(2)=-1173.5;
    % yy(1)=295.6;
    yy(2) = -1173.5 - 15;
    yy(1) = 295.6 - 15;
    %imshow(photo,'truesize');
    h = image(xx,yy,photo);
    axis xy
    axis image
end

axis equal

if( mode >= modes.pos )
    plot(x(tm,8),x(tm,7),['c' line1],cvc(tm1,cv_pos_idx(2)),cvc(tm1,cv_pos_idx(1)),['r' line2])
    legend_str = {'actual', 'cmd'} ;
else
    plot(x(tm,8),x(tm,7),['c' line1])
    legend_str = {'actual'} ;
end

legend_str = horzcat(legend_str, {'start', 'end'});
plot(x(tm(1),8),x(tm(1),7),'ko',x(tm(end),8),x(tm(end),7),'kx');
if(plot_homing)
    plot(target_pos_IC(2),target_pos_IC(1),'rx');
    legend_str = horzcat(legend_str, 'target');
end

update_legend(legend_str)
xlabel('E (ft)'), ylabel('N (ft)')
printpause

% if( plot3D == 1 )
%     %%%%%%%%%%%% 3D plot of trajectory %%%%%%%%%%%%%%%%%%%%
%     figure(18)
%     
%     plot3(x(tm,8),x(tm,7),x(tm,9),cvc(tm1,cv_pos_idx(2)),cvc(tm1,cv_pos_idx(1)),cvc(tm1,cv_pos_idx(3)),'r')
%     xlabel('E'), ylabel('N'), zlabel('h (ft)')
%     legend('actual','cmd')
%     grid
%     
%     printpause
% end
% 
% if( plot_traj && mode == modes.waypoint )
%     %%%%%%%%%%%%%%%%%%%%% TRAJECTORY %%%%%%%%%%%%%%%%%%%%%%
%     figure(19)
%     
%     plot(x(tm,8),x(tm,7),cvc(tm,cv_pos_idx(2)),cvc(tm,cv_pos_idx(1)))
%     xlabel('E (ft)'), ylabel('N (ft)')
%     legend('actual','cmd')
%     axis equal
%     
%     printpause
% end

%%%%%%%%%%%%%%% Plot control vane cmd rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( plot_udot )
    % first compute the rate of change of u
    delt = t1(2) - t1(1) ;    
    udot = [zeros(1,size(u,2)); diff(u)/delt];
    
    disp(sprintf('minimum udot = %s', num2str(min(udot(tm1,:)))))
    disp(sprintf('maximum udot = %s', num2str(max(udot(tm1,:)))))
    
    figure(20); clf
    
    subplot(2,1,1)
    switch MACH.num_u_aero
        case 4
            plot(t1(tm1),udot(tm1,1),'-',t1(tm1),udot(tm1,2),':',t1(tm1),udot(tm1,3),'-.',t1(tm1),udot(tm1,4),'--')
        case 3
            plot(t1(tm1),udot(tm1,1),'-',t1(tm1),udot(tm1,2),':',t1(tm1),udot(tm1,3),'-.')
        otherwise
            plot(t1(tm1),udot(tm1,:),'-')
    end
    legend(strcat(MACH.u_names(MACH.vane_idx),' rate (',MACH.u_units(MACH.vane_idx),'/sec)'))
    ylabel('servo rates')

    subplot(2,1,2), plot(t1(tm1),udot(tm1,MACH.throttle_idx))
    if(length(MACH.throttle_idx) > 1)
        legend(strcat(MACH.u_names(MACH.throttle_idx),' rate'))
    end
    ylabel('throttle rate (1/sec)')
    
    xlabel('time (sec)')
    printpause
end

%%%%%%%%%%%%%%%%%%%% Plot attitude cmd rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( plot_attdot  )
    % Note: this plot only makes sense if att_type is constant during sim
    
    switch( MACH.att_type )
        case att_type.tiltcam
            att_cmds = tiltcam_cmds ;
        case {att_type.ypr_bank, att_type.ypr_skid}
            att_cmds = rpy_cmds ;
        case {att_type.mba_bank, att_type.mba_skid}
            att_cmds = mab_cmds ;
    end
    
    % re-order so that first two angles are the control angles
    att_cmds = att_cmds(:,MACH.att_out_order(MACH.att_type,:)) ;
    
    % first compute the rate of change of att_cmds
    n = size(att_cmds,1) ;
    delt = t1(2) - t1(1) ;
    att_cmds_dot = [zeros(1,size(att_cmds,2)); diff(att_cmds)/delt];
    
    disp(sprintf('minimum att_cmds_dot = %s', num2str(min(att_cmds_dot))))
    disp(sprintf('maximum att_cmds_dot = %s', num2str(max(att_cmds_dot))))
    
    figure(21); clf
    
    subplot(2,1,1)
    plot(t1(tm1),att_cmds_dot(tm1,1),'-',t1(tm1),att_cmds_dot(tm1,2),'--')
    legend(att_angles(1:2))
    ylabel('control-angle-cmds-dot (rad/sec)')
    
    subplot(2,1,2)
    plot(t1(tm1),att_cmds_dot(tm1,3),'-')
    legend(att_angles(3))
    ylabel('specified-angle-cmd-dot (rad/sec)')
    
    xlabel('time (sec)')
    printpause
end

%%%%%%%%%%%%%%%%%%%% Plot attitude as phi, theta, psi %%%%%%%%%%%%%%%%%%%%%
% Note: these angles are defined relative to propulsion axis horizontal
% For airplane vehicles, they are zero when body axes are aligned
% as [x, y, z] => [N, E, D]
% For heli vehicles, they are zero when body axes are aligned
% as [x, y, z] => [D, E, -N]

figure(22)

att_label = {'phi_a', 'theta_a', 'psi_a'} ;
y_att = y_rpy ;

ideal_att_active = [] ;
if( show_att_cmd )
    att_cmds = rpy_cmds ;
elseif( show_att_ideal )
    ideal_att = ideal_rpy ;
    ideal_att_active = intersect(find(att_type_tw == att_type.ypr_bank | att_type_tw == att_type.ypr_skid),tm1);
end

for iplot = 1:3
    subplot(3,1,iplot); hold on
    if( show_att_cmd )
        plot(t(tm),att_scaling*y_att(tm,iplot),line1,t1(tm1),att_scaling*att_cmds(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( ~isempty(ideal_att_active) )
        plot(t(tm),att_scaling*y_att(tm,iplot),line1,t1(ideal_att_active),att_scaling*ideal_att(ideal_att_active,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),att_scaling*y_att(tm,iplot),line1)
        if( iplot == 1 )
            update_legend('actual')
        end
    end
    ylabel([att_label{iplot} ' (' att_units ')'])
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%% Plot attitude as mu, alpha, beta %%%%%%%%%%%%%%%%%%%%%
figure(23)

att_label = {'mu', 'alpha', 'beta'} ;
y_att = y_mab ;

ideal_att_active = [] ;
if( show_att_cmd )
    att_cmds = mab_cmds ;
elseif( show_att_ideal )
    ideal_att = ideal_mab ;
    ideal_att_active = intersect(find(att_type_tw == att_type.mba_bank | att_type_tw == att_type.mba_skid),tm1);
end

for iplot = 1:3
    subplot(3,1,iplot); hold on
    if( show_att_cmd )
        plot(t(tm),att_scaling*y_att(tm,iplot),line1,t1(tm1),att_scaling*att_cmds(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( ~isempty(ideal_att_active) )
        plot(t(tm),att_scaling*y_att(tm,iplot),line1,t1(ideal_att_active),att_scaling*ideal_att(ideal_att_active,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),att_scaling*y_att(tm,iplot),line1)
        if( iplot == 1 )
            update_legend('actual')
        end
    end
    ylabel([att_label{iplot} ' (' att_units ')'])
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%% Plot attitude as tilta, tiltb, cam %%%%%%%%%%%%%%%%%%%
% Note: these angles are defined relative to propulsion axis vertical
% For airplane vehicles, they are zero when body axes are aligned
% as [x, y, z] => [-D, E, N]
% For heli vehicles, they are zero when body axes are aligned
% as [x, y, z] => [N, E, D]
figure(24)

att_label = {'tilta', 'tiltb', 'cam'} ;
y_att = y_tiltcam ;

ideal_att_active = [] ;
if( show_att_cmd )
    att_cmds = tiltcam_cmds ;
elseif( show_att_ideal )
    ideal_att = ideal_tiltcam ;
    ideal_att_active = intersect(find(att_type_tw == att_type.tiltcam),tm1);
end

for iplot = 1:3
    subplot(3,1,iplot); hold on
    if( show_att_cmd )
        plot(t(tm),att_scaling*y_att(tm,iplot),line1,t1(tm1),att_scaling*att_cmds(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( ~isempty(ideal_att_active) )
        plot(t(tm),att_scaling*y_att(tm,iplot),line1,t1(ideal_att_active),att_scaling*ideal_att(ideal_att_active,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),att_scaling*y_att(tm,iplot),line1)
        if( iplot == 1 )
            update_legend('actual')
        end
    end
    ylabel([att_label{iplot} ' (' att_units ')'])
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%% Plot mag vel, chi, gamma %%%%%%%%%%%%%%%%%%%
figure(25)

vel_tmp = xdot_vel ;
vchigam1 = sqrt(sum(vel_tmp.^2, 2)) ;
vchigam2 = atan2(vel_tmp(:,2), vel_tmp(:,1)) ;
vchigam2 = unwrap(vchigam2) ;
vchigam3 = atan2(vel_tmp(:,3), sqrt(sum(vel_tmp(:,[1 2]).^2, 2))) ;
vchigam = [ vchigam1 vchigam2 vchigam3 ] ;

if( show_vel_cmd )
    vel_tmp = cvc(:,cv_vel_idx(1:3)) ;
    vchigam1 = sqrt(sum(vel_tmp.^2, 2)) ;
    vchigam2 = atan2(vel_tmp(:,2), vel_tmp(:,1)) ;
    vchigam2 = unwrap(vchigam2) ;
    vchigam3 = atan2(vel_tmp(:,3), sqrt(sum(vel_tmp(:,[1 2]).^2, 2))) ;
    vchigam_cmd = [ vchigam1 vchigam2 vchigam3 ] ;
elseif( show_vel_ideal )
    vel_tmp = ideal_vel ;
    vchigam1 = sqrt(sum(vel_tmp.^2, 2)) ;
    vchigam2 = atan2(vel_tmp(:,2), vel_tmp(:,1)) ;
    vchigam2 = unwrap(vchigam2) ;
    vchigam3 = atan2(vel_tmp(:,3), sqrt(sum(vel_tmp(:,[1 2]).^2, 2))) ;
    ideal_vchigam = [ vchigam1 vchigam2 vchigam3 ] ;
end

vel_label = {'vel (ft/sec)', ['track (' att_units ')'], ['gamma (' att_units ')']} ;
vel_scaling = [1 att_scaling att_scaling] ;

for iplot = 1:3
    subplot(3,1,iplot); hold on
    if( show_vel_cmd )
        plot(t(tm),vel_scaling(iplot)*vchigam(tm,iplot),line1,t1(tm1),vel_scaling(iplot)*vchigam_cmd(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','cmd')
        end
    elseif( show_vel_ideal )
        plot(t(tm),vel_scaling(iplot)*vchigam(tm,iplot),line1,t1(tm1),vel_scaling(iplot)*ideal_vchigam(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend('actual','ideal')
        end
    else
        plot(t(tm),vel_scaling(iplot)*vchigam(tm,iplot),line1)
        if( iplot == 1 )
            update_legend('actual')
        end
    end
    ylabel(vel_label{iplot})
end

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%% Plot mode and pseudo surface cmds %%%%%%%%%%%%%%%%%%%%
figure(26); clf

subplot(2,1,1)
plot(t1(tm1),mode_tw(tm1),'-',t1(tm1),att_type_tw(tm1),':',t1(tm1),gain_set_tw(tm1),'-.')
legend('mode', 'att type', 'gain set')
ylabel('mode')
axis(axis + [0 0 -1 1]) % move the y limits one unit from the data extremes

subplot(2,1,2)
surf_eff = u(:,MACH.vane_idx)*MACH.gang(1:3,:)' ;
da_eff = surf_eff(:,1) ;
de_eff = surf_eff(:,2) ;
dr_eff = surf_eff(:,3) ;
plot(t1(tm1),da_eff(tm1),'-',t1(tm1),de_eff(tm1),':',t1(tm1),dr_eff(tm1),'-.')
legend('DA', 'DE', 'DR')
ylabel('pseudo surfaces (deg)')

xlabel('time (sec)')
printpause

%%%%%%%%%%%%%%%%%%%% Plot control cmds and servo pos %%%%%%%%%%%%%%%%%%%%%%
full_surf_obac_ulim = [u_ulim_rate u_ulim_vel(:,3:end)] ;
full_surf_obac_llim = [u_llim_rate u_llim_vel(:,3:end)] ;
full_surf_trac_ulim = max(u_servo,full_surf_trac_ulim) ;
full_surf_trac_llim = min(u_servo,full_surf_trac_llim) ;

% The following only works correctly with plot overlays if show_surf_limits
% is false.
pstr = strcat({'b', 'r', 'b', 'r', 'b', 'r'},{line1 line1 line2 line2 line2 line2}) ;
if(~show_surf_limits)
    pstr = pstr(1:end-4);
end

if(use_throt)
    % add throt plot
    uidx = [uidx MACH.throttle_idx] ;
end
unames = MACH.u_names(uidx);
uunits = MACH.u_units(uidx);

nsub = 3 ; % number of subplots per figure
isub = nsub ;
for i = 1:length(uidx)
    
    idx = uidx(i) ;
    
    isub = isub + 1 ;
    if( isub > nsub )
        figure(gcf+1)
        isub = 1 ;
    end

    plot_mat = [ u(tm1,idx) u_servo(tm1,idx) ] ;
    
    if(show_surf_limits)
        plot_mat = [ plot_mat ...
            full_surf_obac_ulim(tm1,i) ...
            full_surf_trac_ulim(tm1,idx) ...
            full_surf_obac_llim(tm1,i) ...
            full_surf_trac_llim(tm1,idx) ...
            ] ;
    end

    subplot(nsub,1,isub); hold on
    if(show_surf_limits)
        ulim = max(max(plot_mat)) ;
        llim = min(min(plot_mat)) ;
        if( ulim ~= llim )
            axis([t1min t1max 1.1*llim-0.1*ulim 1.1*ulim-0.1*llim]) ;
        end
    end

    % Note: (x+eps)-eps will round any abs(x) below eps^2 to zero, to avoid a
    % bug in plot for unnormalized numbers
    for iplot = 1:length(pstr)
        plot(t1plot, (plot_mat(:,iplot)+eps)-eps, pstr{iplot})
    end
    ylabel(sprintf('%s (%s)', unames{i}, uunits{i}))
    if( isub == 1 )
        update_legend('command','servo')
    end
    
    if( isub == nsub )
        xlabel('time (sec)')
        printpause
    end
end

if(use_rcs)
    ylabels = {'p cvdex (rad/sec^2)', 'q cvdex (rad/sec^2)', 'r cvdex (rad/sec^2)'} ;
    figure(gcf+1)
    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t1(tm1),cvdex_smn_rate(tm1,iplot),line1,t1(tm1),cvdex(tm1,iplot),line2)
        if( iplot == 1 )
            update_legend({'w/o RCS','with RCS'})
        end
        ylabel(ylabels{iplot})
    end
    xlabel('time (sec)')
    printpause

    ylabels = {'RCS pdot (rad/sec^2)', 'RCS qdot (rad/sec^2)', 'RCS rdot (rad/sec^2)'} ;
    figure(gcf+1)
    rcs_angular_accel = cvdex(:,cv_rate_idx) - cvdex_smn_rate ;
    for iplot = 1:3
        subplot(3,1,iplot); hold on
        plot(t1(tm1),rcs_angular_accel(tm1,iplot))
        if( iplot == 1 )
            update_legend('actual')
        end
        ylabel(ylabels{iplot})
    end
    xlabel('time (sec)')
    printpause
end

figure(50); clf
hold on
plot(y_aero_mach(tm),att_scaling*y_mab(tm,2))
if(isfield(MACH,'BF_schedule') && isfield(MACH.BF_schedule,'is_trimmable'))
    trim_solution = MACH.BF_schedule ;
    axis_range = axis ;
    [mplot_not,aplot_not] = find(~trim_solution.is_trimmable) ;
    h = plot(trim_solution.tbl_mach(mplot_not),trim_solution.tbl_alpha(aplot_not),'ro') ;
    axis(axis_range) ;
    legend(h,'not trimmable');
end
xlabel('Mach number')
ylabel(['Angle-of-attack (' att_units ')'])
printpause

if(~exist('qbar1000'))
    load qbar_hVplots
end

figure(51); clf
hold on
plot(y_aero_mach(tm),x(tm,9))
if(exist('qbar300'))
    axis_range = axis ;
    % overlay (M,h) plots of constant qbar
    plot(qbar300(:,2),qbar300(:,1),'g:',qbar1000(:,2),qbar1000(:,1),'r-.')
    axis(axis_range) ;
end
legend('actual','qbar = 300 psf','qbar = 1000 psf')
xlabel('Mach number')
ylabel('altitude (feet)')
printpause

figure(52); clf
subplot(2,1,1), plot(t(tm),y_aero_mach(tm))
ylabel('Mach number')
subplot(2,1,2), plot(t(tm),y_aero_qbar(tm))
ylabel('dynamic pressure (psf)')
xlabel('time (sec)')
printpause

Energy = 0.5 * vchigam(:,1).^2 + constants.g * x(:,9) ;
N_final = x(end,7) ;
E_final = x(end,8) ;
Range = sqrt( ( x(:,7) - N_final ).^2 +  ( x(:,8) - E_final ).^2 ) ;

figure(53); clf
plot(Range(tm)/constants.nm2ft,Energy(tm))
ylabel('Specific Energy (ft2/sec2)')
xlabel('Range (nmiles)')
printpause

if(use_variable_mass)
    figure(54)
    subplot(1,1,1); hold on
    plot(t(tm),constants.g*y_mass(tm),line1,t1(tm1),constants.g*mass_obac_tw(tm1),line2)
    ylabel('weight (lbs)')
    xlabel('time (sec)')
    update_legend('trac','obac')
    printpause
end

if(plot_homing)
    figure(55); clf
    subplot(3,1,1), plot(t(tm),att_scaling*y_LOS_rate(tm,:),'-')
    ylabel(['LOS rates (' att_units '/sec)'])
    legend('azimuth rate', 'elevation rate') ;
    subplot(3,1,2), plot(t(tm),att_scaling*y_LOS_angle(tm,:),'-')
    ylabel(['LOS angles (' att_units ')'])
    legend('azimuth', 'elevation') ;
    subplot(3,1,3), plot(t(tm),pos_scaling(1)*y_target_range(tm,:),'-')
    ylabel(['target range (' pos_units{1} ')'])
    legend('ground', 'slant') ;
    xlabel('time (sec)')
    printpause

    [cpa_dist, cpa_idx] = min(y_target_range(:,2)) ;
    disp(sprintf('miss distance = %g %s, time = %g sec, angle = %g %s', pos_scaling(1)*cpa_dist, pos_units{1}, t(cpa_idx), att_scaling*vchigam(cpa_idx,3), att_units))
end

if(exist('mkplt_extra','file'))
    mkplt_extra
end

% Compute and display mean data over the time segment [tmin tmax]
x_mean = mean(x(tm,:));
u_mean = mean(u(tm1,:));
integ_mean = mean(integ(tm1,:));
y_mean = mean(y(tm,:));
surf_eff_mean = mean(surf_eff(tm1,:)) ;

% display the mean data of interest
disp(['x_mean = [' sprintf(' %g',x_mean) ' ]'';']);
disp(['u_mean = [' sprintf(' %g',u_mean) ' ]'';']);

if(t_trim > 0)
    disp(['vehicle_params.x_trim = [' sprintf(' %g',mean(x(t >= t(end) - t_trim,:))) ' ]'';']) ;
    disp(['vehicle_params.u_trim = [' sprintf(' %g',mean(u_out(t1 >= t1(end) - t_trim,:))) ' ]'';']) ;
end

namefigs

% order by increasing figure number by bringing to top in reverse order
% optionally, shift to non-default screen (if shift_fig defined and true)
figures = sort(get(0,'Children'),1,'descend')';
if(exist('shift_fig') && shift_fig)
    fig_pos = get(figures(1),'Position') ;
    screen_size = get(0,'Screensize') ;
    fig_pos(1) = fig_pos(1) - sign(fig_pos(1))*screen_size(3) ;
else
    shift_fig = 0 ;
end

for i = figures
    try
        figure(i)
    catch
        continue
    end
    
    if(shift_fig)
        set(i,'Position',fig_pos) ;
    end
    
    % set paper position for printed copies
    if(set_paper_position)
        set(i,'PaperPosition',[0.5,0.5,8,10])
    end
    
    % add figure titles
    axes('Position',[0.5 0.92 0.001 0.001]) ;
    axis off
    %title(sprintf('%s      page  %d',titledate,gcf))
end