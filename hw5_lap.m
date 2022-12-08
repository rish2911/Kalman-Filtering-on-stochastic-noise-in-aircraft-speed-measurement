syms s

Gd2s = 1/(1+0.1*s);
b = [1 0];
a = [0.01 1];
[A, B, C, D] = tf2ss(b,a)