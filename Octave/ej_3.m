config_m;

largo_senial_entrada = 50000;     % Es el largo de la senial u de referencia.
largo_parte_fir = 2;              % Cantidad de coeficientes del numerador.
largo_parte_iir = 2;              % Cantidad de coeficientes del denominador.
mu = 0.1;                         % Constante de aprendizaje.

ts=1;
k_const=3;
m_const=5;
b_const=2;

syms b m k

numB=[(b*ts)/(m+b*ts) (k*ts^2-b*ts)/(m+b*ts)];
denA=[1 (k*ts^2-2*m-b*ts)/(m+b*ts) m/(m+b*ts)];

B=double(subs(numB,{b,m,k},[b_const m_const k_const]));
A=double(subs(denA,{b,m,k},[b_const m_const k_const]));

entrada = wgn(1, largo_senial_entrada, 1);                  % Genero referencia.
salida = filter(B, A, entrada);     % La paso por el sistema a estimar.

salida_estimada = zeros(1, length(salida));                 % Hago espacio para la estimacion de la salida y los w.
w = zeros(largo_parte_fir + largo_parte_iir, length(entrada) - largo_parte_fir);

% Algoritmo LMS.
for i = (largo_parte_fir + largo_parte_iir) : length(entrada)
    entrada_ventaneada = [entrada(i : -1 : i - largo_parte_fir + 1), salida(i - 1 : -1 : i - largo_parte_iir)];
    w(:, i) = w(:, i - 1) + mu * entrada_ventaneada' * (salida(i) - entrada_ventaneada * w(:, i - 1));
end

% Coeficientes Al Final.
w(:, end)

% Figura de convergencia de los coeficientes.
figure(2);
hold on;
plot(w');
axis([largo_parte_fir + largo_parte_iir, largo_senial_entrada, -0.3, 0.7]);
title('Convergencia De Coeficientes');

% Obtención de los resultados

result=solve(w(1:2,end)'==numB,-w(3:4,end)'==denA(2:3),[m k b]);
result=double(struct2array(result));
fprintf('Los resultados de la estimación por LMS son:\n')
fprintf('m=%.2f \nk=%.2f \nb=%.2f\n',result(1),result(2),result(3))
