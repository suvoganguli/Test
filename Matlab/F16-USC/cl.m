%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  CL.m                      %%
%%                                            %%
%%  Author : Ying Huo                         %%
%%                                            %%
%%  rolling moment coefficients in F-16 model %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cl_value = cl( alpha, beta )

A = [  .0     .0     .0     .0     .0     .0     .0     .0     .0     .0     .0     .0  ;
      -.001  -.004  -.008  -.012  -.016  -.022  -.022  -.021  -.015  -.008  -.013  -.015;
      -.003  -.009  -.017  -.024  -.030  -.041  -.045  -.040  -.016  -.002  -.010  -.019;
      -.001  -.010  -.020  -.030  -.039  -.054  -.057  -.054  -.023  -.006  -.014  -.027;
       .000  -.010  -.022  -.034  -.047  -.060  -.069  -.067  -.033  -.036  -.035  -.035;
       .007  -.010  -.023  -.034  -.049  -.063  -.081  -.079  -.060  -.058  -.062  -.059;
       .009  -.011  -.023  -.037  -.050  -.068  -.089  -.088  -.091  -.076  -.077  -.076 ];
A = A'; 
row = 3;
col = 1;

s = 0.2 * alpha;
k = fix ( s );
if ( k <= -2 )
    k = -1;
end
if ( k >= 9 )
    k = 8;
end
da = s - k;
l = k + fix( sign ( da ) * 1.1 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% added as boundary condition
if l < -2
    l = -2;
elseif l > 9
        l = 9;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = 0.2 * abs( beta );
m = fix ( s );
if ( m == 0 )
   m = 1;
end
if ( m >= 6)
   m = 5;
end
db = s - m;
n = m + fix ( sign ( db ) * 1.1 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% added as boundary condition
if n < 0
    n = 0;
elseif n > 6
        n = 6;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = A( k+row, m+col );
u = A( k+row, n+col );
v = t + abs( da ) * ( A( l+row, m+col ) - t );
w = u + abs( da ) * ( A( l+row, n+col ) - u );
dum = v + ( w - v ) * abs( db );
cl_value = dum * sign ( beta ) * 1.0;
