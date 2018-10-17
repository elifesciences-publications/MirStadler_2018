clear all
% dat_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per_tiffs\';
% anal_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per_tiffs_anal\';

dat_path='F:\2017-01-23\rd2_256x256_58msx40bleach_100per_histones_tiffs\';
anal_path='F:\2017-01-23\rd2_256x256_58msx40bleach_100per_histones_tiffs_anal\';

tint=0.058; %time interval s


FRAP_path=[anal_path,'FRAP_Data.mat']; %segmented images matrix path
load(FRAP_path)
%% align to bleach frame
% 
for k=1:length(FRAP_data)
    bleachts(k,1)=FRAP_data(k).BleachFrame;
    movie_lengths(k,1)=length(FRAP_data(k).norm_FRAP);
end

min_bleacht=min(bleachts); % get the earliest bleach frame to align all the curves to


for k=1:length(FRAP_data)
    cbleacht=FRAP_data(k).BleachFrame;
    dift=cbleacht-min_bleacht;
    FRAP_data(k).norm_FRAP_aligned=FRAP_data(k).norm_FRAP(dift+1:end);
    movie_lengths_aligned(k,1)=length(FRAP_data(k).norm_FRAP_aligned);
end

%% cut them all of to the same length
min_movielength=min(movie_lengths_aligned);
for k=1:length(FRAP_data)
    FRAP_aligned(:,k)=FRAP_data(k).norm_FRAP_aligned(1:min_movielength);
end

tvec=(0:tint:(length(FRAP_aligned)-1)*tint)';
tvec=tvec-(min_bleacht-1)*tint;
meanFRAP=mean(FRAP_aligned,2);
stdFRAP = std(FRAP_aligned,0,2);

pre_bleach=meanFRAP(1:min_bleacht); pre_bleach_tvec=tvec(1:min_bleacht);
post_bleach=meanFRAP(min_bleacht:end); post_bleach_tvec=tvec(min_bleacht:end);


xTime=tvec(min_bleacht:end);
yFRAP=meanFRAP(min_bleacht:end);

%% exponential fitting
% nfit frames

% Exponential model
% f1 = fittype('1 - A*exp(-ka*x) ');
% ('1 - A*exp(-ka*x) - B*exp(-kb*x)');

model1=@(A,t) 1-A(1).*exp(-A(2).*xTime);
guess1=[0.4 6];
% Power law model
model2=@(B,T) 1-B(1).*exp(-B(2).*xTime)-B(3).*exp(-B(4).*xTime);
guess2=[0.4 10 0.2 2];

% Determine values of the parameters using nlinfit
mdl1 = fitnlm(xTime,yFRAP,model1, guess1);
mdl2 = fitnlm(xTime,yFRAP,model2, guess2);


% [onef,R1,J1,CovB1,MSE1] = nlinfit(xTime,yFRAP,model1, guess1);
% [twof,R2,J2,CovB2,MSE2] = nlinfit(xTime,yFRAP,model2, guess2);


%% Plot models with raw data

fit1A=mdl1.Coefficients.Estimate(1);
fit1ka=mdl1.Coefficients.Estimate(2);
N1=1-fit1A.*exp(-fit1ka.*xTime);
Fit1_text(1) = {'1-Exp fit: 1-A*exp(-ka*t) '};
Fit1_text(2) = {['A = ', num2str(fit1A)]};
Fit1_text(3) = {['ka = ', num2str(fit1ka), ' s^-1 or 1/k = ', num2str(1/fit1ka), 's']};
Fit1_text(4) = {['Adjusted R^2:' num2str(mdl1.Rsquared.Adjusted)]};


fit2A=mdl2.Coefficients.Estimate(1);
fit2ka=mdl2.Coefficients.Estimate(2);
fit2B=mdl2.Coefficients.Estimate(3);
fit2kb=mdl2.Coefficients.Estimate(4);

N2=1-fit2A.*exp(-fit2ka.*xTime)-fit2B.*exp(-fit2kb.*xTime);
Fit2_text(1) = {'2-Exp fit: 1-A*exp(-ka*t)-B*exp(-kb*t)'};
Fit2_text(2) = {['A = ', num2str(fit2A)]};
Fit2_text(3) = {['ka = ', num2str(fit2ka), ' s^-1 or 1/k = ', num2str(1/fit2ka), 's']};
Fit2_text(4) = {['B = ', num2str(fit2B)]};
Fit2_text(5) = {['kb = ', num2str(fit2kb), ' s^-1 or 1/k = ', num2str(1/fit2kb), 's']};
Fit2_text(6) = {['Adjusted R^2:' num2str(mdl2.Rsquared.Adjusted)]};

figure
subplot(1,2,1),plot(tvec, meanFRAP, 'o', 'Color', 'k', 'MarkerSize', 6);
hold on
subplot(1,2,1),plot(xTime, N1, 'k--', 'LineWidth', 3);
text(1,0.6,Fit1_text,'HorizontalAlignment','Left', 'FontSize',9, 'FontName', 'Helvetica');
hold off
title('1-Exponent fit to  FRAP', 'FontSize',10, 'FontName', 'Helvetica');
ylabel('Normalized Fluoresence Intensity [a.u.]', 'FontSize',10, 'FontName', 'Helvetica');
xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
legend('FRAP Data', 'Exp model fit', 'Location', 'SouthEast');
legend boxoff;


subplot(1,2,2),plot(tvec, meanFRAP, 'o', 'Color', 'k', 'MarkerSize', 6);
hold on
subplot(1,2,2),plot(xTime, N2, 'k--', 'LineWidth', 3);
text(1,0.6,Fit2_text,'HorizontalAlignment','Left', 'FontSize',9, 'FontName', 'Helvetica');
hold off
title('2-Exponent fit to  FRAP', 'FontSize',10, 'FontName', 'Helvetica');
ylabel('Normalized Fluoresence Intensity [a.u.]', 'FontSize',10, 'FontName', 'Helvetica');
xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
legend('FRAP Data', 'Exp model fit', 'Location', 'SouthEast');
legend boxoff;

% % Plot Residual Plots
figure

subplot(1,2,1),plot(xTime,0,xTime,mdl1.Residuals.Raw,'kp')
title('Residual Plot for 1-Exponent fit', 'FontSize',10, 'FontName', 'Helvetica');
ylabel('Residuals', 'FontSize',10, 'FontName', 'Helvetica');
xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
axis([-1 5 -0.15 0.15])

subplot(1,2,2),plot(xTime,0,xTime,mdl2.Residuals.Raw,'kp')
title('Residual Plot for 2-Exponent fit', 'FontSize',10, 'FontName', 'Helvetica');
ylabel('Residuals', 'FontSize',10, 'FontName', 'Helvetica');
xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
axis([-1 5 -0.15 0.15])



%% for histones
figure
Fit2_text(1) = {['A = ', num2str(fit2A)]};
Fit2_text(2) = {['ka = ', num2str(fit2ka), ' s^-1 or 1/k = ', num2str(1/fit2ka), 's']};
Fit2_text(3) = {['B = ', num2str(fit2B)]};
Fit2_text(4) = {['kb = ', num2str(fit2kb), ' s^-1 or 1/k = ', num2str(1/fit2kb), 's']};
Fit2_text(5) = {['Adjusted R^2:' num2str(mdl2.Rsquared.Adjusted)]};
plot(tvec, meanFRAP, 'o', 'Color', 'r', 'MarkerSize', 6);
hold on
plot(xTime, N2, 'r--', 'LineWidth', 3);
text(1,0.98,Fit2_text,'HorizontalAlignment','Left', 'FontSize',9, 'FontName', 'Helvetica');

hold off
title('2-Exponent fit to Histone FRAP', 'FontSize',10, 'FontName', 'Helvetica');
ylabel('Normalized Fluoresence Intensity [a.u.]', 'FontSize',10, 'FontName', 'Helvetica');
xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
axis([-1 5 0.2 1.2])
legend('FRAP Data', 'Exp model fit', 'Location', 'SouthEast');
legend boxoff;


%% Compare fits to see which is better
[aic,bic] = aicbic([mdl1.LogLikelihood;mdl2.LogLikelihood], [2; 4;], length(xTime))

%%
SS1=sum(mdl1.Residuals.Raw.^2);
SS2=sum(mdl2.Residuals.Raw.^2);

df1=length(xTime)-2;
df2=length(xTime)-4;

F=((SS1-SS2)./(df1-df2))./(SS2./df2);
P=1-fcdf(F,df1,df2)

