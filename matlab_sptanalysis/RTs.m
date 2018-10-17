clear all
clear data_list pars
%% load in 500 ms data
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\datalist_500ms_h2b_zld.mat') % data_list
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\pars_500ms.mat') % pars file
data_list_500=data_list; pars_500=pars; % write to new variables
clear data_list
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\datalist_500ms_bcd.mat') % data_list
data_list_500bcd=data_list;
%% fit parameters
Alb=0; Aub=1000; As=1;
Flb=0.1; Fub=1; Fs=0.9; dslb=0.9; dsub=200; dss=5; dflb=0.1; dfub=5; dfs=0.1; % fitting paramaeters 500 mslb: lower, ub: upper, s: start poin
fitparams2_500=[[Alb Flb dflb dslb];[Aub Fub dfub dsub];[As Fs dfs dss]];

Alb=0; Aub=100; As=1;
dlb=0.1; dub=200; ds=5;
fitparams1_500=[[Alb dlb];[Aub dub];[As ds]];


ccol_h2b= [107/255, 107/255, 107/255]; 
ccol_zld= [255/255, 148/255, 5/255]; 
ccol_bcd= [72/255, 143/255, 208/255];

thresh=10^-3; %probability threshold
% Nmin=1.505; %
Nmin=2.02; %
%% fit bcd embryos individually
data_list_500bcd=get_datasub(data_list_500bcd,'exclude',1,'<');
clear cname
for k=1:size(data_list_500bcd,2)
    cname{k,1}=[data_list_500bcd(k).folder_name,data_list_500bcd(k).set_name];
    cname{k,2}=data_list_500bcd(k).folder_name;
    cname{k,3}=data_list_500bcd(k).set_name;
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear bcd2_em names_list
for cem=1:length(c)
    clear comp_t
    %     cem=1;
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_500bcd,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    %     comp_t=compile_bound_res_times2(cdata_list,pars_500,Dbound_bcd);
    comp_t=compile_res_times(cdata_list,pars_500);
    comp_t=comp_t(comp_t>=Nmin);
    if ~isempty(comp_t)
        [SP_c, SP_raw_c]=get_survprob(comp_t,pars_500.fr,thresh);
        [fit_results2c, fit_results1c]=fitcdf_final(SP_c,fitparams2_500,fitparams1_500);
        bcd2_em(ctr).fit_results=fit_results2c;  
        bcd2_em(ctr).SP=SP_c;  
        bcd2_em(ctr).SP_raw=SP_raw_c;  
        bcd2_fits(ctr,1)=fit_results2c.A;
        bcd2_fits(ctr,2)=fit_results2c.F;
        bcd2_fits(ctr,3)=fit_results2c.df;
        bcd2_fits(ctr,4)=fit_results2c.ds;
        bcd2_fits(ctr,5)=fit_results2c.Rsq;
        ctr=ctr+1;
    end
end

%% fit zld embryos individually
data_list_500zld=get_datasub(data_list_500,'cycle_group',3,'<='); % get the zelda data for 500 ms going from interphase-prophase
data_list_500zld=get_datasub(data_list_500zld,'motion',1,'<'); % no motion
clear cname
for k=1:size(data_list_500zld,2)
    cname{k,1}=[data_list_500zld(k).folder_name,data_list_500zld(k).set_name];
    cname{k,2}=data_list_500zld(k).folder_name;
    cname{k,3}=data_list_500zld(k).set_name;
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear zld2_em names_list zld2_fits
for cem=1:length(c)
    clear comp_t
    %     cem=1;
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_500zld,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    comp_t=compile_res_times(cdata_list,pars_500);
    comp_t=comp_t(comp_t>=Nmin);
    if ~isempty(comp_t)
        [SP_c, SP_raw_c]=get_survprob(comp_t,pars_500.fr,thresh);
        [fit_results2c, fit_results1c]=fitcdf_final(SP_c,fitparams2_500,fitparams1_500);
        zld2_em(ctr).fit_results=fit_results2c;  
        zld2_em(ctr).SP=SP_c;  
        zld2_em(ctr).SP_raw=SP_raw_c;
        zld2_fits(ctr,1)=fit_results2c.A;
        zld2_fits(ctr,2)=fit_results2c.F;
        zld2_fits(ctr,3)=fit_results2c.df;
        zld2_fits(ctr,4)=fit_results2c.ds;
        zld2_fits(ctr,5)=fit_results2c.Rsq;
        ctr=ctr+1;
    end
end

%% fit h2b embryos individually

data_list_500h2b=get_datasub(data_list_500,'cycle_group',5,'=='); % get the histone data for 500 ms
clear cname
for k=1:size(data_list_500h2b,2)
    cname{k,1}=[data_list_500h2b(k).folder_name,data_list_500h2b(k).set_name];
    cname{k,2}=data_list_500h2b(k).folder_name;
    cname{k,3}=data_list_500h2b(k).set_name;
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear h2b2_em names_list h2b2_fits
for cem=1:length(c)
    clear comp_t
    %     cem=1;
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_500h2b,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    comp_t=compile_res_times(cdata_list,pars_500);
    comp_t=comp_t(comp_t>=Nmin);
    if ~isempty(comp_t)
        [SP_c, SP_raw_c]=get_survprob(comp_t,pars_500.fr,thresh);
        [fit_results2c, fit_results1c]=fitcdf_final(SP_c,fitparams2_500,fitparams1_500);
        h2b2_em(ctr).fit_results=fit_results2c;  
        h2b2_em(ctr).SP=SP_c;  
        h2b2_em(ctr).SP_raw=SP_raw_c;
        h2b2_fits(ctr,1)=fit_results2c.A;
        h2b2_fits(ctr,2)=fit_results2c.F;
        h2b2_fits(ctr,3)=fit_results2c.df;
        h2b2_fits(ctr,4)=fit_results2c.ds;
        ctr=ctr+1;
    end
end

%% MAIN TEXT FIGURE 3B: fits embryo by embryo and with mean and SEM of fits 
clear cfit_bcd2 cfit_zld2 cfit_h2b2
tvec=(0.505:0.505:20)';
figure('Position',[100,100,250,200])
hold on
for cem=1:size(bcd2_em,2)
    cfit_bcd2(:,cem)=calc_2exp(bcd2_em(cem).fit_results.A,bcd2_em(cem).fit_results.F,bcd2_em(cem).fit_results.df,bcd2_em(cem).fit_results.ds,tvec,1.505);
end

for cem=1:size(zld2_em,2)
    cfit_zld2(:,cem)=calc_2exp(zld2_em(cem).fit_results.A,zld2_em(cem).fit_results.F,zld2_em(cem).fit_results.df,zld2_em(cem).fit_results.ds,tvec,1.505);
end

for cem=1:size(h2b2_em,2)
    cfit_h2b2(:,cem)=calc_2exp(h2b2_em(cem).fit_results.A,h2b2_em(cem).fit_results.F,h2b2_em(cem).fit_results.df,h2b2_em(cem).fit_results.ds,tvec,1.505);
end

% patch([tvec' fliplr(tvec')], [(mean(cfit_bcd2,2)-std(cfit_bcd2,0,2))'  fliplr((mean(cfit_bcd2,2)+std(cfit_bcd2,0,2))')],ccol_bcd,'facealpha',.5,'EdgeColor','none')
patch([tvec' fliplr(tvec')], [(mean(cfit_bcd2,2)-(std(cfit_bcd2,0,2)./sqrt(3)))'  fliplr((mean(cfit_bcd2,2)+std(cfit_bcd2,0,2)./sqrt(3))')],ccol_bcd,'facealpha',.5,'EdgeColor','none')
line(tvec,mean(cfit_bcd2,2),'color',ccol_bcd,'LineWidth',2.5)

% patch([tvec' fliplr(tvec')], [(mean(cfit_zld2,2)-std(cfit_zld2,0,2))'  fliplr((mean(cfit_zld2,2)+std(cfit_zld2,0,2))')],ccol_zld,'facealpha',.5,'EdgeColor','none')
patch([tvec' fliplr(tvec')], [(mean(cfit_zld2,2)-std(cfit_zld2,0,2)./sqrt(3))'  fliplr((mean(cfit_zld2,2)+std(cfit_zld2,0,2)./sqrt(3))')],ccol_zld,'facealpha',.5,'EdgeColor','none')
line(tvec,mean(cfit_zld2,2),'color',ccol_zld,'LineWidth',2.5)

% patch([tvec' fliplr(tvec')], [(mean(cfit_h2b2,2)-std(cfit_h2b2,0,2)./sqrt(3))'  fliplr((mean(cfit_h2b2,2)+std(cfit_h2b2,0,2)./sqrt(3))')],ccol_h2b,'facealpha',.5,'EdgeColor','none')
% line(tvec,mean(cfit_h2b2,2),'color',ccol_h2b,'LineWidth',2.5)



hold off 
set(gca, 'YScale', 'log')
ylim([10^-3,1])
xlim([0,15])

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'LineWidth'   , 1         );

%% MAIN TEXT FIGURE 3C: Corrected slow residence times bar plots from embryo by embryo fits showing mean and SEM of fits 
% fit residence time data to get correction factor
data_list_500h2b=get_datasub(data_list_500,'cycle_group',5,'=='); % get the histone data for 500 ms
[comp_t_500h2b, disp_comp_500h2b]=compile_res_times(data_list_500h2b,pars_500); % compile the trajectory lengths for 500 ms data no filtering
comp_t_500h2b=comp_t_500h2b(comp_t_500h2b>=Nmin);
[SP_h2b2, SP_raw_h2b2]=get_survprob(comp_t_500h2b,pars_500.fr,thresh);
[fit_results2h2b2, fit_results1h2b2]=fitcdf_final(SP_h2b2,fitparams2_500,fitparams1_500);

% calculate corrected ds values
for cem=1:size(bcd2_em,2)
    bcd2_dcorr(cem,1)=1/((1/bcd2_em(cem).fit_results.ds)-(1/fit_results2h2b2.ds));
    bcd2_dcorr(cem,2)=1/((1/bcd2_em(cem).fit_results.df)-(1/fit_results2h2b2.ds));
end


for cem=1:size(zld2_em,2)
    zld2_dcorr(cem,1)=1/((1/zld2_em(cem).fit_results.ds)-(1/fit_results2h2b2.ds));
    zld2_dcorr(cem,2)=1/((1/zld2_em(cem).fit_results.df)-(1/fit_results2h2b2.ds));
end
%
bar_w=0.20;
zld_cent=0.25;
bcd_cent=0.75;
ypmin=0.0001;
clear y b
figure('Position',[100,100,150,200])
hold on
% y = [2 4 6; 3 4 5]
y=[mean(zld2_dcorr(:,1)) 0; 0 mean(bcd2_dcorr(:,1))];

patch('Faces',[1 2 3 4],'Vertices',[zld_cent-bar_w ypmin; zld_cent-bar_w mean(zld2_dcorr(:,1)); zld_cent+bar_w  mean(zld2_dcorr(:,1)); zld_cent+bar_w ypmin], 'FaceColor',ccol_zld);
errorbar(zld_cent,mean(zld2_dcorr(:,1)),std(zld2_dcorr(:,1))./sqrt(3),'.',...
    'LineWidth',1,'Marker','none','CapSize',10,'Color','k')


patch('Faces',[1 2 3 4],'Vertices',[bcd_cent-bar_w ypmin; bcd_cent-bar_w mean(bcd2_dcorr(:,1)); bcd_cent+bar_w  mean(bcd2_dcorr(:,1)); bcd_cent+bar_w ypmin], 'FaceColor',ccol_bcd);
errorbar(bcd_cent,mean(bcd2_dcorr(:,1)),std(bcd2_dcorr(:,1))./sqrt(3),'.',...
    'LineWidth',1,'Marker','none','CapSize',10,'Color','k')

% ylim([0,15])
ylim([0,8])
xlim([0,1])
xticks([zld_cent bcd_cent])
xticklabels({'Zelda','Bicoid'})
hold  off


