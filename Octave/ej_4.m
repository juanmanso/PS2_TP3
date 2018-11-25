config_m;

% Imprimir imágenes?
bool_print=1;

largo_senial_entrada = 1500000;     % Es el largo de la senial u de referencia.
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
B2=double(subs(numB,{b,m,k},[b_const m_const 0.1]));
A2=double(subs(denA,{b,m,k},[b_const m_const 0.1]));

entrada = wgn(1, largo_senial_entrada, 1);                  % Genero referencia.
[salida,zf]= filter(B, A, entrada(1:end/32));     % La paso por el sistema a estimar.
salida2 = filter(B2, A2, entrada((end/32)+1:end),zf);     % La paso por el sistema a estimar.
salida=[salida salida2];
salida=salida+randn(1,length(salida))*0.01;

salida_estimada = zeros(1, length(salida));                 % Hago espacio para la estimacion de la salida y los w.
w = zeros(largo_parte_fir + largo_parte_iir, length(entrada) - largo_parte_fir);

% Algoritmo LMS.
for i = (largo_parte_fir + largo_parte_iir) : length(entrada)
    entrada_ventaneada = [entrada(i : -1 : i - largo_parte_fir + 1), -salida(i - 1 : -1 : i - largo_parte_iir)];
    w(:, i) = w(:, i - 1) + mu * entrada_ventaneada' * (salida(i) - entrada_ventaneada * w(:, i - 1));
end

% Coeficientes Al Final.
w(:, end)

% Figura de convergencia de los coeficientes.
fig1=figure();
hold on;
plot(w','LineWidth',3);
fir_line_1=refline(0,B2(1));
fir_line_2=refline(0,B2(2));
fir_line_3=refline(0,A2(2));
fir_line_4=refline(0,A2(3));
fir_line_1.LineStyle='--';
fir_line_1.LineWidth=1;
fir_line_1.Color=colors.gecko;
fir_line_2.LineStyle='--';
fir_line_2.LineWidth=1;
fir_line_2.Color=colors.castaway;
fir_line_3.LineStyle='--';
fir_line_3.LineWidth=1;
fir_line_4.LineStyle='--';
fir_line_4.LineWidth=1;
fir_line_4.Color=colors.orchid;
%axis([largo_parte_fir + largo_parte_iir, largo_senial_entrada, -0.3, 0.7]);
grid minor;
title({'Convergencia De Coeficientes LMS - Corte de resorte';'\sigma_{N}=0.01'});
setGraphSize(fig1,wide_1);
leg1=legend({'$\hat{B1}$','$\hat{B2}$','$\hat{A2}$','$\hat{A3}$','$B1$','$B2$','$A2$','$A3$'});
set(leg1,'Interpreter','latex');
leg1.Location='eastoutside';
xlabel('Muestras');

if bool_print
    print('../Informe/Figuras/graf_ej4','-dpdf','-bestfit');
end

% Obtención de los resultados

result=solve(mean(w(1:2,end-400:end)')==numB,m_const==m,[m k b]);
result=double(struct2array(result));
if ~isempty(result)
    fprintf('Los resultados de la estimación por LMS al cortar el resorte son:\n')
    fprintf('m=%.4f \nk=%.4f \nb=%.4f\n',result(1),result(2),result(3))
end

%% Ruido con varianza 0.001 (para que converja)

[salida,zf]= filter(B, A, entrada(1:end/32));     % La paso por el sistema a estimar.
salida2 = filter(B2, A2, entrada((end/32)+1:end),zf);     % La paso por el sistema a estimar.
salida=[salida salida2];
salida=salida+randn(1,length(salida))*0.001;

salida_estimada = zeros(1, length(salida));                 % Hago espacio para la estimacion de la salida y los w.
w = zeros(largo_parte_fir + largo_parte_iir, length(entrada) - largo_parte_fir);

% Algoritmo LMS.
for i = (largo_parte_fir + largo_parte_iir) : length(entrada)
    entrada_ventaneada = [entrada(i : -1 : i - largo_parte_fir + 1), -salida(i - 1 : -1 : i - largo_parte_iir)];
    w(:, i) = w(:, i - 1) + mu * entrada_ventaneada' * (salida(i) - entrada_ventaneada * w(:, i - 1));
end

% Coeficientes Al Final.
w(:, end)

% Figura de convergencia de los coeficientes.
fig1=figure();
hold on;
plot(w','LineWidth',3);
fir_line_1=refline(0,B2(1));
fir_line_2=refline(0,B2(2));
fir_line_3=refline(0,A2(2));
fir_line_4=refline(0,A2(3));
fir_line_1.LineStyle='--';
fir_line_1.LineWidth=1;
fir_line_1.Color=colors.gecko;
fir_line_2.LineStyle='--';
fir_line_2.LineWidth=1;
fir_line_2.Color=colors.castaway;
fir_line_3.LineStyle='--';
fir_line_3.LineWidth=1;
fir_line_4.LineStyle='--';
fir_line_4.LineWidth=1;
fir_line_4.Color=colors.orchid;
%axis([largo_parte_fir + largo_parte_iir, largo_senial_entrada, -0.3, 0.7]);
grid minor;
title({'Convergencia De Coeficientes LMS - Corte de resorte';'\sigma_{N}=0.001'});
setGraphSize(fig1,wide_1);
leg1=legend({'$\hat{B1}$','$\hat{B2}$','$\hat{A2}$','$\hat{A3}$','$B1$','$B2$','$A2$','$A3$'});
set(leg1,'Interpreter','latex');
leg1.Location='eastoutside';
xlabel('Muestras');

if bool_print
    print('../Informe/Figuras/graf_ej4bis','-dpdf','-bestfit');
end

% Obtención de los resultados

result=solve(mean(w(1:2,end-400:end)')==numB,m_const==m,[m k b]);
result=double(struct2array(result));
if ~isempty(result)
    fprintf('Los resultados de la estimación por LMS al cortar el resorte son:\n')
    fprintf('m=%.4f \nk=%.4f \nb=%.4f\n',result(1),result(2),result(3))
end
