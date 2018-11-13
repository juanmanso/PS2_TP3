config_m;

largo_senial_entrada = 200;     % Es el largo de la senial u de referencia.
largo_filtro_adaptativo = 10;   % Es el largo de w, de agregarse de mas, convergen a 0.
mu = 0.1;                       % Constante de aprendizaje.

entrada = wgn(1, largo_senial_entrada, 1);                  % Genero referencia.
salida = filter([0.5, 0.4, 0.3, 0.2, 0.1], 1, entrada);     % La paso por el sistema a estimar.

salida_estimada = zeros(1, length(salida));                 % Hago espacio para la estimacion de la salida y los w.
w = zeros(largo_filtro_adaptativo, length(entrada) - largo_filtro_adaptativo);

% Algoritmo LMS.
for i = largo_filtro_adaptativo : length(entrada)
    entrada_ventaneada = entrada(i : -1 : i - largo_filtro_adaptativo + 1);
    w(:, i) = w(:, i - 1) + mu * entrada_ventaneada' * (salida(i) - entrada_ventaneada * w(:, i - 1));
    salida_estimada(i) = entrada_ventaneada * w(:, i);
end

% Coeficientes Al Final.
w(:, end)

% Figura de comparacion de salidas de los dos sistemas.
figure(1);
hold on;
plot(salida, 'b');
plot(salida_estimada, '--r');
axis([largo_senial_entrada - 50, largo_senial_entrada, -2, 2]);
title('Salida VS Salida Estimada Al Final')

% Figura de convergencia de los coeficientes.
figure(2);
hold on;
plot(w');
axis([largo_filtro_adaptativo, largo_senial_entrada, -0.3, 0.7]);
title('Convergencia De Coeficientes');