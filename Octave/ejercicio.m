
config_m;

% Parámetros
fase = pi;	% Fase de la intereferncia
w0 = 50;	% Frecuencia de la interferencia
A0 = 0.5;	% Amplitud interferencia
A1 = 1;		% Amplitud referencia
mu = 0.5;	% Paso

L = 2;		% Largo del Wiener




% Levanto la pista
[s, fs] = waveread('pista_1.wav');

% Genero referencia e interferencia
i = A0*sen(w0*n+fase);
u = A1*sen(w0*n);
d = s+i;


w = zeros(L,1);


for k = 1:L
	e(k) = d(k) - w(k-1)'*u(k-1);
	w(k) = w(k-1
