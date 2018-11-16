config_m;

largo_senial_entrada = 50000;     % Es el largo de la senial u de referencia.
largo_parte_fir = 5;              % Cantidad de coeficientes del numerador.
largo_parte_iir = 2;              % Cantidad de coeficientes del denominador.
mu = 0.1;                         % Constante de aprendizaje.

entrada = wgn(1, largo_senial_entrada, 1);                  % Genero referencia.
salida = filter([0.5, 0.4, 0.3, 0.2, 0.1], [1, 0.2, 0.1], entrada);     % La paso por el sistema a estimar.

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