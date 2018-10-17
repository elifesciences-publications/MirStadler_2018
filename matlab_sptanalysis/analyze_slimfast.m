clear comp_t comp_all CDFC 
clear bin_cents SlowRate SlowFraction FastRate PrefixA


ctr=1;
excl=0;
bwd=0.1;
% fr=0.1; %frame rate in milliseconds
% edges=0.1:bwd:5;
% for k=2:length(edges)       % calculate bin centers
%     bin_cents(k-1,1)=edges(k-1)+(edges(k)-edges(k-1))/2;    
% end

bwd=0.5;
fr=0.5; %frame rate in milliseconds
edges=0.5:bwd:20;
for k=2:length(edges)       % calculate bin centers
    bin_cents(k-1,1)=edges(k-1)+(edges(k)-edges(k-1))/2;    
end


for cstack=1:size(data_list,2)
    load(data_list(cstack).tracked_path)
      if isstruct(data) && (data_list(cstack).exclude==0 || ~excl)  %if there is trackign for this nucleus and its not to be excluded
            ctrajs=data.tr;
            for c=1:size(ctrajs,2)
                ctrack= ctrajs{c};
                if size(ctrack,1) > 1 % if more than 1 frame
                comp_t(ctr,1)=(max(ctrack(:,3))-min(ctrack(:,3))+1).*fr;
                ctr=ctr+1;
                end
            end

      end
end

%
[N,edgesr] = histcounts(comp_t,edges,'Normalization','cdf');
N=N';
CDFC(:,1)=1-N; % copy this and bin_cents to excel for plotting


%% Fitting
 
xTime=bin_cents;

yProb=CDFC;


% clear f2 yFit2  fit_results2
% f2 = fittype('F*exp(-ka*x) + (1-F)*exp(-kb*x)');
% Flb=0.5; Fub=1; Fs=0.9;
% kalb=1; kaub=20; kas=5;
% kblb=0; kbub=5; kbs=0.0002;
% [TwoExp_fit, TwoExp_param] = fit(xTime, yProb, f2, 'Lower', [Flb kalb kblb], 'Upper', [Fub kaub kbub], 'StartPoint', [Fs kas kbs]); 
% TwoExp_CI = confint(TwoExp_fit);
% yFit2 = TwoExp_fit.F*exp(-TwoExp_fit.ka.*xTime) + (1-TwoExp_fit.F)*exp(-TwoExp_fit.kb.*xTime);
% % fit_results2(1,1)=TwoExp_fit.A;  fit_results2(1,2)=TwoExp_CI(1,1);   fit_results2(1,3)=TwoExp_CI(2,1);  
% fit_results2(1,1)=TwoExp_fit.F;  fit_results2(1,2)=TwoExp_CI(1,1);   fit_results2(1,3)=TwoExp_CI(2,1);  
% fit_results2(1,4)=TwoExp_fit.ka; fit_results2(1,5)=TwoExp_CI(1,2);   fit_results2(1,6)=TwoExp_CI(2,2);  
% fit_results2(1,7)=TwoExp_fit.kb; fit_results2(1,8)=TwoExp_CI(1,3);   fit_results2(1,9)=TwoExp_CI(2,3);  
% fit_results2(1,10)=TwoExp_param.adjrsquare;
% fit_results2(1,11)=TwoExp_param.sse;
% fit_results2(1,12)=length(comp_t);% number trajectories



clear f2 yFit2  fit_results2
f2 = fittype('A*(F*exp(-ka*x) + (1-F)*exp(-kb*x))');
Alb=0; Aub=100; As=1;
Flb=0.5; Fub=1; Fs=0.9;
kalb=4; kaub=25; kas=5;
kblb=0; kbub=5; kbs=0.0002;
[TwoExp_fit, TwoExp_param] = fit(xTime, yProb, f2, 'Lower', [Alb Flb kalb kblb], 'Upper', [Aub Fub kaub kbub], 'StartPoint', [As Fs kas kbs]); 
TwoExp_CI = confint(TwoExp_fit);
yFit2 = TwoExp_fit.A.*(TwoExp_fit.F*exp(-TwoExp_fit.ka.*xTime) + (1-TwoExp_fit.F)*exp(-TwoExp_fit.kb.*xTime) );
fit_results2(1,1)=TwoExp_fit.A;  fit_results2(1,2)=TwoExp_CI(1,1);   fit_results2(1,3)=TwoExp_CI(2,1);  
fit_results2(1,4)=TwoExp_fit.F;  fit_results2(1,5)=TwoExp_CI(1,2);   fit_results2(1,6)=TwoExp_CI(2,2);  
fit_results2(1,7)=TwoExp_fit.ka; fit_results2(1,8)=TwoExp_CI(1,3);   fit_results2(1,9)=TwoExp_CI(2,3);  
fit_results2(1,10)=TwoExp_fit.kb; fit_results2(1,11)=TwoExp_CI(1,4);   fit_results2(1,12)=TwoExp_CI(2,4);  
fit_results2(1,13)=TwoExp_param.adjrsquare;
fit_results2(1,14)=TwoExp_param.sse;
fit_results2(1,15)=length(comp_t);% number trajectories



%%

figure('position',[100 400 400 400]);
hold on
% loglog(xTime, yProb, 'k.', xTime, yFit2, 'k-','LineWidth', 1);
% title(['log-log Survival Probability EL Bin:',num2str(cEL)], 'FontSize',10, 'FontName', 'Calbiri');
plot(xTime, yProb, 'k.','LineWidth', 1);
plot(xTime, yFit2, 'k-','LineWidth', 1);

set(gca,'xscale','log');
set(gca,'yscale','log');
title('log-log', 'FontSize',10, 'FontName', 'Calbiri');
ylabel('Survival Probabiliy', 'FontSize',10, 'FontName', 'Calbiri');
xlabel('Time (s)', 'FontSize',10, 'FontName', 'Calbiri');
legend('Data', '2-Exp model fit','Location', 'NorthEast');
legend boxoff;
axis([0 100 10^-4 1])

hold off;