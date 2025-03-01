% trimit.m

Z0 = [zeros(13,1)];

Z0(1) = 502;

[Zstar,f0,exitflag] = fminunc('f16_cost',Z0,...
    optimset('TolFun',1e-10,...
    'TolX',1e-10,'MaxFunEval',1e5,'MaxIter',1e5))

x13 = TGEAR(Zstar(10));

state_trim = [Zstar(1:9); 0; 0; 0; x13];
control_trim = Zstar(10:13);

save trimcond2 state_trim control_trim xcg

% load trimcond.mat
% 
% [state_trim state_trim_new]
% [control_trim control_trim_new]