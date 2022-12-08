syms s

Sd1  = ((1 + (3*sqrt(3)*s))/((1+3*s)^2));
Sd2 = simplify((s/(1+0.1*s))*Sd1);

%% 
bd1 = [0 3*sqrt(3) 1];
ad1 = [9 6 1];

[Ad1, Bd1, Cd1, Dd1] = tf2ss(bd1,ad1);
%% 
bd2 = [0 5.1962 1 0];
ad2 = [0.9 9.6 6.1 1];

[Ad2, Bd2, Cd2, Dd2] = tf2ss(bd2,ad2);

%% Augmented model for disturbance

Ad = [Ad1 zeros(2,3); zeros(3,2) Ad2];
Bd = [Bd1;Bd2];
Cd = [Cd1 zeros(1,3); zeros(1,2) Cd2];
Dd = [0;0];

%% Augmented oberver matrix for 
Aa = [A B*Cd; zeros(5,4) Ad];
Ba = [B*Dd; Bd];
Ca = [C zeros(2,5)];

%% Variance of the process using lyapunov equation
Q_c = Ba*147*Ba';
Pss = lyap(Aa, Q_c);

%%RMS values
Var = Ca*Pss*Ca';
rms_speed = sqrt(Var(1,1));
rms_climbrate = sqrt(Var(2,2));

%%c part
lam = [-Aa Q_c; zeros(9,9) Aa'];
Tau = 0.05;
stat_trans = expm(lam*Tau);
F = stat_trans(10:18,10:18)';
Q_bar = F*stat_trans(1:9,10:18);

%% d part
G = eye(9,9);
Q_d = G*Q_bar*G';
P_disc = dlyap(F,Q_d);
var_discrete = Ca*P_disc*Ca'