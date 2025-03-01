% script for testing gtm closed-loop performance
% with different loop closures
%
% created       : 10-08-2009
% last updated  : 04-23-2010

%% Change Notes

% s-function needs to be updated (4/22/10)
% added functionality to easily change simulation model (4/22/10)

%% Preamble

use_sfun_model = 0;
sim_name = 'main_sim_adapt_Gref_SP';
sim_name = 'main_sim_noadapt'

do_GTMfaults = 1;

%% 1st run

list_gtm_expts
gtm_exptno = input('Input GTM Experiment No. : ');

if (gtm_exptno ~= 0)
    tic
    doit_GTM
    fprintf('\nAdding MRAC code ...\n');    
    set_MRAC
    if do_GTMfaults     
        in_DamageCase = input('Enter Damage Case No. [1-6, 0 for nominal]: ');
        trac_params.aero.DamageCase=in_DamageCase;
        trac_params.aero.DamageOnsetTime=0;
        obac_params.aero.DamageCase=in_DamageCase;
        obac_params.aero.DamageOnsetTime=0;
        disp(['DamageCase = ' num2str(trac_params.aero.DamageCase)]);
        disp(['DamageOnsetTime = ' num2str(trac_params.aero.DamageOnsetTime)]);
    end
    if use_sfun_model
        disp('this branch of the script is not updated ...')
        return
        fprintf('\nSimulating main_sim_claw_main_sf.mdl (tsim_max=%d) ...\n',tsim_max);
        fprintf('Note 3: sfun is not updated with LPF in att_ff path\n');
        sim('main_sim_claw_main_sf');    
    else
        fprintf('\nSimulating (tsim_max=%d) ...\n',tsim_max);    
        sim(sim_name);        
    end
    fprintf('\nPlotting ...\n');
    %close all
    mkplt    
    toc
end

return

%% Subsequent runs


while (gtm_exptno~=0)   
    list_gtm_expts
    gtm_exptno = input('Input GTM Experiment No. : ');    
    if (gtm_exptno ~= 0)                      
        do_actfail_scenarios  
        do_command_tracking        
        tic
        part_doit_GTM        
        if do_GTMfaults
            disp(' ')
            disp('> trac_params.aero.DamageCase=0; - no fault');
            disp('> trac_params.aero.DamageCase=1; - rudder off');
            disp('> trac_params.aero.DamageCase=2; - vert. tail off');
            disp('> Giving keyboard access to change DamageCase');
            disp('  (use, if needed >> close all)');
            keyboard
        end        
        if use_sfun_model
            disp('this branch of the script is not updated ...')
            return
            fprintf('\nSimulating main_sim_claw_main_sf.mdl (tsim_max=%d) ...\n',tsim_max);
            fprintf('Note 3: sfun is not updated with LPF in att_ff path\n');
            sim('main_sim_claw_main_sf');
        else
            fprintf('\nSimulating (tsim_max=%d) ...\n',tsim_max);    
            sim(sim_name);             
        end        
        if ~do_keyboard
            %close all
        end
        fprintf('\nPlotting ...\n');        
        mkplt
        toc
    end
end



