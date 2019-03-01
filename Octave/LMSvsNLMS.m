config_m;
clc;

% Imprimir imágenes?
bool_print=0;

error_var_length=300;

load('LMSyNLMSdata.mat');

k_const=3;
m_const=5;
b_const=2;
ts=1;

syms b m k

numB=[(b*ts)/(m+b*ts) (k*ts^2-b*ts)/(m+b*ts)];
denA=[1 (k*ts^2-2*m-b*ts)/(m+b*ts) m/(m+b*ts)];

B=double(subs(numB,{b,m,k},[b_const m_const k_const]));
A=double(subs(denA,{b,m,k},[b_const m_const k_const]));

h1=figure;
hold on;
grid minor;
plot(w_LMS(:,1:500)');
plot(w_NLMS(:,1:500)');
plot(w_RLS(:,1:500)');
setGraphSize(h1,wide_1);
leg1=legend('B1 LMS','B2 LMS','A2 LMS','A3 LMS','B1 NLMS','B2 NLMS','A2 NLMS','A3 NLMS','B1 RLS','B2 RLS','A2 RLS','A3 RLS');
leg1.Location='eastoutside';
title('Comparación LMS vs NLMS vs RLS');

if bool_print
    print('../Informe/Figuras/graf_LMS_vs_NLMS_vs_RLS','-dpdf','-bestfit');
end

errB1LMS=bsxfun(@minus,B(1),w_LMS(1,:));
errB2LMS=bsxfun(@minus,B(2),w_LMS(2,:));
errA2LMS=bsxfun(@minus,A(2),w_LMS(3,:));
errA3LMS=bsxfun(@minus,A(3),w_LMS(4,:));

errB1NLMS=bsxfun(@minus,B(1),w_NLMS(1,:));
errB2NLMS=bsxfun(@minus,B(2),w_NLMS(2,:));
errA2NLMS=bsxfun(@minus,A(2),w_NLMS(3,:));
errA3NLMS=bsxfun(@minus,A(3),w_NLMS(4,:));

errB1RLS=bsxfun(@minus,B(1),w_RLS(1,:));
errB2RLS=bsxfun(@minus,B(2),w_RLS(2,:));
errA2RLS=bsxfun(@minus,A(2),w_RLS(3,:));
errA3RLS=bsxfun(@minus,A(3),w_RLS(4,:));

errsize=length(errB1LMS);
h2=figure;
subplot(4,1,1);
hold on;
grid minor;
plot(errB1LMS,'LineWidth',2);
plot(errB1NLMS,'LineWidth',2);
plot(errB1RLS,'LineWidth',2);
leg1=legend('LMS','NLMS','RLS');
leg1.Location='eastoutside';
xlim([errsize-error_var_length errsize]);
ylabel('B1');
subplot(4,1,2);
hold on;
grid minor;
plot(errB2LMS,'LineWidth',2);
plot(errB2NLMS,'LineWidth',2);
plot(errB2RLS,'LineWidth',2);
leg2=legend('LMS','NLMS','RLS');
leg2.Location='eastoutside';
xlim([errsize-error_var_length errsize]);
ylabel('B2');
subplot(4,1,3);
hold on;
grid minor;
plot(errA2LMS,'LineWidth',2);
plot(errA2NLMS,'LineWidth',2);
plot(errA2RLS,'LineWidth',2);
leg3=legend('LMS','NLMS','RLS');
leg3.Location='eastoutside';
xlim([errsize-error_var_length errsize]);
ylabel('A2');
subplot(4,1,4);
hold on;
grid minor;
plot(errA3LMS,'LineWidth',2);
plot(errA3NLMS,'LineWidth',2);
plot(errA3RLS,'LineWidth',2);
leg4=legend('LMS','NLMS','RLS');
leg4.Location='eastoutside';
xlim([errsize-error_var_length errsize]);
ylabel('A3');
if EsMatlab
    suptitle('Error LMS vs NLMS vs RLS');
end
setGraphSize(h2,wide_1);

if bool_print
    print('../Informe/Figuras/graf_err_LMS_vs_NLMS_vs_RLS','-dpdf','-bestfit');
end

verrB1LMS=var(errB1LMS(end-error_var_length:end));
verrB2LMS=var(errB2LMS(end-error_var_length:end));
verrA2LMS=var(errA2LMS(end-error_var_length:end));
verrA3LMS=var(errA3LMS(end-error_var_length:end));
verrB1NLMS=var(errB1NLMS(end-error_var_length:end));
verrB2NLMS=var(errB2NLMS(end-error_var_length:end));
verrA2NLMS=var(errA2NLMS(end-error_var_length:end));
verrA3NLMS=var(errA3NLMS(end-error_var_length:end));
verrB1RLS=var(errB1RLS(end-error_var_length:end));
verrB2RLS=var(errB2RLS(end-error_var_length:end));
verrA2RLS=var(errA2RLS(end-error_var_length:end));
verrA3RLS=var(errA3RLS(end-error_var_length:end));

fprintf('Resultados varianza de errores\n')
fprintf('------------------------------\n')
fprintf('\t \t LMS \t \t \t NLMS \t \t \t RLS\r\n')

fprintf('verrB1 \t %.4e \t %.4e \t %.4e\n',verrB1LMS,verrB1NLMS,verrB1RLS)
fprintf('verrB2 \t %.4e \t %.4e \t %.4e\n',verrB2LMS,verrB2NLMS,verrB2RLS)
fprintf('verrA2 \t %.4e \t %.4e \t %.4e\n',verrA2LMS,verrA2NLMS,verrA2RLS)
fprintf('verrA3 \t %.4e \t %.4e \t %.4e\n',verrA3LMS,verrA3NLMS,verrA3RLS)
