clear all
% dat_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per_tiffs\';
% anal_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per_tiffs_anal\';


dat_path='/Users/MStadler/Documents/Imaging/2018-02-10/tiffs/';
anal_path='/Users/MStadler/Documents/Imaging/2018-02-10/analysis/';


% tint=0.088145454545455; %time interval s

tint=0.024; %time interval s
FRAP_path=[anal_path,'FRAP_anal.mat']; %segmented images matrix path
load(FRAP_path)


%% align to bleach frame

FRAP_data_all=FRAP_data;
clear FRAP_data
% RPB1
% FRAP_data(2)=FRAP_data_all(1)
% FRAP_data(3)=FRAP_data_all(2)
% FRAP_data(1)=FRAP_data_all(11);

% % Zelda
% FRAP_data(1)=FRAP_data_all(13)
% FRAP_data(2)=FRAP_data_all(14)
% FRAP_data(3)=FRAP_data_all(15)
% FRAP_data(1)=FRAP_data_all(14)
% 
% % % CP190
% FRAP_data(1)=FRAP_data_all(3);
% FRAP_data(2)=FRAP_data_all(8);
% % FRAP_data(2)=FRAP_data_all(4)
% 
% % % H2B
FRAP_data(1)=FRAP_data_all(9);
FRAP_data(2)=FRAP_data_all(10);


for k=1:length(FRAP_data)
    bleachts(k,1)=FRAP_data(k).BleachFrame;
    movie_lengths(k,1)=size(FRAP_data(k).norm_FRAP,1);
    min_bleacht=min(bleachts); % get the earliest bleach frame to align all the curves to


end

 
for k=1:length(FRAP_data)
    cbleacht=FRAP_data(k).BleachFrame;
    dift=cbleacht-min_bleacht;
    for creg=1:size(FRAP_data(k).norm_FRAP,2)
        FRAP_data(k).norm_FRAP_aligned(:,creg)=FRAP_data(k).norm_FRAP(dift+1:end,creg);       
    end
    
    movie_lengths_aligned(k,1)=size(FRAP_data(k).norm_FRAP_aligned,1);
end

% cut them all of to the same length
min_movielength=min(movie_lengths_aligned);
ctr=1;
for k=1:length(FRAP_data)
    for creg=1:size(FRAP_data(k).norm_FRAP,2)
        FRAP_aligned(:,ctr)=FRAP_data(k).norm_FRAP_aligned(1:min_movielength,creg);
        ctr=ctr+1;
    end
end
%%
tvec=(0:tint:(length(FRAP_aligned)-1)*tint)';
tvec=tvec-(min_bleacht-1)*tint;
meanFRAP=mean(FRAP_aligned,2);
stdFRAP = std(FRAP_aligned,0,2);
% 
% pre_bleach=meanFRAP(1:min_bleacht); pre_bleach_tvec=tvec(1:min_bleacht);
% post_bleach=meanFRAP(min_bleacht:end); post_bleach_tvec=tvec(min_bleacht:end);
% % 
% figure 
% hold on
% for k=1:size(FRAP_aligned,2)
%     plot(tvec,FRAP_aligned(:,k),'Color',[0.4, 0.4, 0.4])
% %     scatter(tvec,FRAP_aligned(:,k),'MarkerFaceColor',[0.4, 0.4, 0.4],'LineColor','none')
% end
% % plot(tvec,mean_FRAP,'k','LineWidth',5)
% errorbar(tvec, meanFRAP, stdFRAP, 'o', 'Color', 'k', 'MarkerSize', 2);
% % plot(pre_bleach_tvec,smooth(pre_bleach,2),'k','LineWidth',4)
% plot(pre_bleach_tvec,pre_bleach,'k','LineWidth',4)
% plot(post_bleach_tvec,smooth(post_bleach,5),'k','LineWidth',4)
% 
% hold off

forxl=horzcat(tvec,stdFRAP,meanFRAP)
% exponential fitting
nfit frames
clear f1 yFit1 Fit1_text
xTime=tvec(min_bleacht:end);
yFRAP=meanFRAP(min_bleacht:end);

f1 = fittype('1 - A*exp(-ka*x) ');
[OneExp_fit, OneExp_param, One_output] = fit(xTime, yFRAP, f1, 'Lower', [0 0], 'Upper', [100 100], 'StartPoint', [0 0]); 
OneExp_CI = confint(OneExp_fit);

yFit1 = 1 -  OneExp_fit.A.* exp(-OneExp_fit.ka .* xTime);
Fit1_text(1) = {'1-Exp fit: 1-A*exp(-ka*t) '};
Fit1_text(2) = {['A = ', num2str(OneExp_fit.A)]};
Fit1_text(3) = {['A (95% CI): [', num2str(OneExp_CI(1,1)), ';', num2str(OneExp_CI(2,1)), ']']};
Fit1_text(4) = {['ka = ', num2str(OneExp_fit.ka), ' s^-1 or 1/k = ', num2str(1/OneExp_fit.ka), 's']};
Fit1_text(5) = {['a (95% CI): [', num2str(OneExp_CI(1,2)), ';', num2str(OneExp_CI(2,2)), ']']};
Fit1_text(6) = {['R^2:' num2str(OneExp_param.adjrsquare)]};

f2 = fittype('1 - A*exp(-ka*x) - B*exp(-kb*x)');
[TwoExp_fit, TwoExp_param, Two_output] = fit(xTime, yFRAP, f2, 'Lower', [0 0 0 0], 'Upper', [100 100 100 100], 'StartPoint', [0.5 1.1 0.5 0.0005]); 
TwoExp_CI = confint(TwoExp_fit);
yFit2 = 1 - TwoExp_fit.A .* exp(-TwoExp_fit.ka .* xTime) - TwoExp_fit.B .* exp(-TwoExp_fit.kb .* xTime);

Fit2_text(1) = {'2-Exp fit: 1-A*exp(-ka*t)-B*exp(-kb*t)'};
Fit2_text(2) = {['A = ', num2str(TwoExp_fit.A)]};
Fit2_text(3) = {['A (95% CI): [', num2str(TwoExp_CI(1,1)), ';', num2str(TwoExp_CI(2,1)), ']']};
Fit2_text(4) = {['ka = ', num2str(TwoExp_fit.ka), ' s^-1 or 1/k = ', num2str(1/TwoExp_fit.ka), 's']};
Fit2_text(5) = {['a (95% CI): [', num2str(TwoExp_CI(1,3)), ';', num2str(TwoExp_CI(2,3)), ']']};
Fit2_text(6) = {['B = ', num2str(TwoExp_fit.B)]};
Fit2_text(7) = {['B (95% CI): [', num2str(TwoExp_CI(1,2)), ';', num2str(TwoExp_CI(2,2)), ']']};
Fit2_text(8) = {['kb = ', num2str(TwoExp_fit.kb), ' s^-1 or 1/k = ', num2str(1/TwoExp_fit.kb), 's']};
Fit2_text(9) = {['kb (95% CI): [', num2str(TwoExp_CI(1,4)), ';', num2str(TwoExp_CI(2,4)), ']']};
Fit2_text(10) = {['R^2:' num2str(TwoExp_param.adjrsquare)]};



%  figure; %[x y width height]
%  
% hold on;
% figure
% subplot(1,2,1),plot(tvec, meanFRAP, 'o', 'Color', [237/255, 28/255, 36/255], 'MarkerSize', 6);
% hold on
% % subplot(1,2,1),plot(xTime, yFRAP, 'o', 'Color', 'k', 'MarkerSize', 6);
% 
% plot(xTime, yFit1, 'k--', 'LineWidth', 3);
% % plot([min(xTime), max(xTime)], [1, 1], 'k--', 'LineWidth', 1);
% text(1,0.6,Fit1_text,'HorizontalAlignment','Left', 'FontSize',9, 'FontName', 'Helvetica');
% title('1-Exponent fit to  FRAP', 'FontSize',10, 'FontName', 'Helvetica');
% ylabel('Normalized Fluoresence Intensity [a.u.]', 'FontSize',10, 'FontName', 'Helvetica');
% xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
% legend('FRAP Data', 'Exp model fit', 'Location', 'SouthEast');
% legend boxoff;
% hold off;
% 
% subplot(1,2,2),plot(tvec, meanFRAP, 'o', 'Color', [237/255, 28/255, 36/255], 'MarkerSize', 6);
% hold on
% % subplot(1,2,2),plot(xTime, yFRAP, 'o', 'Color', 'k', 'MarkerSize', 6);
% subplot(1,2,2),plot(xTime, yFit2, 'k--', 'LineWidth', 3);
% text(1,0.6,Fit2_text,'HorizontalAlignment','Left', 'FontSize',9, 'FontName', 'Helvetica');
% title('2-Exponent fit to  FRAP', 'FontSize',10, 'FontName', 'Helvetica');
% ylabel('Normalized Fluoresence Intensity [a.u.]', 'FontSize',10, 'FontName', 'Helvetica');
% xlabel('Time (s)', 'FontSize',10, 'FontName', 'Helvetica');
% legend('FRAP Data', 'Exp model fit', 'Location', 'SouthEast');
% legend boxoff;
% hold off;

%% evaluate model fit
figure

% figure
subplot(1,2,1),plot(xTime,One_output.residuals,'o','Color', 'k');
hold on
subplot(1,2,1),plot(xTime,zeros(length(One_output.residuals),1),'k--');
hold off
title('Residuals for 1-Exponent fit', 'FontSize',10, 'FontName', 'Helvetica');
axis([-1 5 -0.15 0.15])


subplot(1,2,2),plot(xTime,Two_output.residuals,'o','Color', 'k');
hold on
subplot(1,2,2),plot(xTime,zeros(length(Two_output.residuals),1),'k--');
axis([-1 5 -0.15 0.15])
hold off
title('Residuals for 2-Exponent fit', 'FontSize',10, 'FontName', 'Helvetica');


%%
% SS1=OneExp_param.sse 
% df1=length(yFRAP)-2
% SS2=TwoExp_param.sse 
% df2=length(yFRAP)-4
% 
% F1=((SS1-SS2)/(df1-df2))/(SS2/df2);
% P1=1-fcdf(F1,df1,df2)
% 
% F2=((SS2-SS1)/(df2-df1))/(SS1/df1);
% P2=1-fcdf(F2,df2,df1)
