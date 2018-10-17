%%
ccol_h2b= [107/255, 107/255, 107/255]; 
ccol_zld= [255/255, 148/255, 5/255]; 
ccol_bcd= [72/255, 143/255, 208/255];
%
bar_w=0.20;
zld_cent=1.25;
bcd_cent=0.75;
h2b_cent=0.25;
ypmin=0.0001;
 

figure('Position',[100,100,250,200])
hold on

load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zldby_em.mat'); 
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_bcdby_em.mat'); 
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_h2bby_em.mat'); 
for k=1:3 
    zld_fbound(k,1)=Spoton_zldby_em{k}.merged_model_params(3);
    bcd_fbound(k,1)=Spoton_bcdby_em{k}.merged_model_params(3);
    h2b_fbound(k,1)=Spoton_h2bby_em{k}.merged_model_params(3);
end
 
zld_mean=mean(zld_fbound); zld_std=std(zld_fbound);
bcd=mean(bcd_fbound); bcd_std=std(bcd_fbound);
h2b=mean(h2b_fbound); h2b_std=std(h2b_fbound);
 
patch('Faces',[1 2 3 4],'Vertices',[h2b_cent-bar_w ypmin; h2b_cent-bar_w h2b; h2b_cent+bar_w  h2b; h2b_cent+bar_w ypmin], 'FaceColor',ccol_h2b);
errorbar(h2b_cent,h2b,h2b_std./sqrt(3),'.',...
    'LineWidth',1,'Marker','none','CapSize',10,'Color','k')
 
 
patch('Faces',[1 2 3 4],'Vertices',[bcd_cent-bar_w ypmin; bcd_cent-bar_w bcd; bcd_cent+bar_w  bcd; bcd_cent+bar_w ypmin], 'FaceColor',ccol_bcd);
errorbar(bcd_cent,bcd,bcd_std./sqrt(3),'.',...
    'LineWidth',1,'Marker','none','CapSize',10,'Color','k')
 
patch('Faces',[1 2 3 4],'Vertices',[zld_cent-bar_w ypmin; zld_cent-bar_w zld_mean; zld_cent+bar_w  zld_mean; zld_cent+bar_w ypmin], 'FaceColor',ccol_zld);
errorbar(zld_cent,zld_mean,zld_std./sqrt(3),'.',...
    'LineWidth',1,'Marker','none','CapSize',10,'Color','k')
 
 
% ylim([0,15])
% xlim([0,1])
xticks([h2b_cent bcd_cent zld_cent])
xticklabels({'H2B','Bicoid','Zelda'})
hold  off

%%
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_bcd_all_together.mat'); 
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_all_together.mat'); 
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Output_struct_h2b.mat'); 

ymin=0.00001;
% for k=1:3 
%     zld_pdff(:,k)=Spoton_zldby_em{k}.merged_data_PDF(2,:)';
%     zld_pdffit(:,k)=Spoton_zldby_em{k}.merged_model_PDF(2,:)';
%     bcd_pdff(:,k)=Spoton_bcdby_em{k}.merged_data_PDF(2,:)';
%     h2b_pdff(:,k)=Spoton_h2bby_em{k}.merged_data_PDF(2,:)';
% end
% pdf_bins=Spoton_zldby_em{k}.r_bins_PDF';
% h2b_pdf=mean(h2b_pdff,2);
% bcd_pdf=mean(bcd_pdff,2);
% zld_pdf=mean(zld_pdff,2);
% zld_pdf_fit=mean(zld_pdffit,2);

delt=3;

pdf_bins=Spoton_zld_all_together.r_bins_PDF';

zld_pdf=Spoton_zld_all_together.merged_data_PDF(delt,:);
zld_pdf_fit=Spoton_zld_all_together.merged_model_PDF(delt,:);

bcd_pdf=Spoton_bcd_all_together.merged_data_PDF(delt,:);
bcd_pdf_fit=Spoton_bcd_all_together.merged_model_PDF(delt,:);

h2b_pdf=Output_struct_h2b.merged_data_PDF(delt,:);
h2b_pdf_fit=Output_struct_h2b.merged_model_PDF(delt,:);


h2b_o=0.03*2;
zld_o=0; %offset
bcd_o=0.03; %offset

figure('Position',[100,100,250,200])
hold on
for k=2:length(pdf_bins)
    patch('Faces',[1 2 3 4],'Vertices',[pdf_bins(k-1) ymin+h2b_o; pdf_bins(k-1) h2b_pdf(k)+h2b_o; pdf_bins(k) h2b_pdf(k)+h2b_o;pdf_bins(k) ymin+h2b_o], 'FaceColor',ccol_h2b); %,'FaceAlpha',.5);     
    patch('Faces',[1 2 3 4],'Vertices',[pdf_bins(k-1) ymin+bcd_o; pdf_bins(k-1) bcd_pdf(k)+bcd_o; pdf_bins(k) bcd_pdf(k)+bcd_o;pdf_bins(k) ymin+bcd_o], 'FaceColor',ccol_bcd); %,'FaceAlpha',.5);
    patch('Faces',[1 2 3 4],'Vertices',[pdf_bins(k-1) ymin+zld_o; pdf_bins(k-1) zld_pdf(k)+zld_o; pdf_bins(k) zld_pdf(k)+zld_o;pdf_bins(k) ymin+zld_o], 'FaceColor',ccol_zld); %,'FaceAlpha',.5);
end

line(pdf_bins(2:end),zld_pdf_fit(2:end)+zld_o,'Color','k','LineWidth',2);
line(pdf_bins(2:end),bcd_pdf_fit(2:end)+bcd_o,'Color','k','LineWidth',2);
line(pdf_bins(2:end),h2b_pdf_fit(2:end)+h2b_o,'Color','k','LineWidth',2);

hold off
xlim([0,1])

ylabel('Probability', 'FontSize',10, 'FontName', 'Calbiri', 'Color', 'k');
xlabel('Displacement \mum', 'FontSize',10, 'FontName', 'Calbiri', 'Color', 'k');
set(gca,'YTickLabel',''); set(gca, 'YTick', []);
print ('E:\Dropbox\Darzacq\Drosophila\Zelda\manuscript\Figures+Movies\fig3disp_hists.eps','-depsc2','-painters');
% figure
% hold on
% plot(pdf_bins,mean(zld_pdf,2));
% plot(pdf_bins,mean(bcd_pdf,2));
% plot(pdf_bins,mean(h2b_pdf,2));
%% load in 10 ms data
clear all
clear data_list pars; load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\datalist_10ms_bcd.mat')
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\pars_10ms.mat');
data_list_10bcd=data_list; pars_10=pars;
load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\datalist_10ms_h2b_zld.mat')
data_list_10=data_list;

data_list_10h2b=get_datasub(data_list_10,'cycle_group',5,'=='); % get the histone data for10 ms
data_list_10zld=get_datasub(data_list_10,'cycle_group',3,'<='); % get the zelda data for 10 ms going from interphase-prophase
data_list_10zld=get_datasub(data_list_10zld,'motion',1,'<'); % no motion
data_list_10bcd=get_datasub(data_list_10bcd,'exclude',1,'<');
data_list_10bcd=get_datasub(data_list_10bcd,'cycle_group',3,'<=');

%% no need to run this again
data_folder='G:\Zelda\'; % path with data folders specified in excel file
Spoton_zld_all_together=call_spoton(data_folder,data_list_10zld,'Zelda');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_all_together.mat','Spoton_zld_all_together')
cdata_list=get_datasub(data_list_10zld,'nuc_cyc',12,'<=');  
Spoton_zld_cyc_le12=call_spoton(data_folder,cdata_list,'Zelda NC <=12');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_cyc_le12.mat','Spoton_zld_cyc_le12')

cdata_list=get_datasub(data_list_10zld,'nuc_cyc',13,'<=');  
Spoton_zld_cyc_le13=call_spoton(data_folder,cdata_list,'Zelda NC <=13');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_cyc_le13.mat','Spoton_zld_cyc_le13')

cdata_list=get_datasub(data_list_10zld,'nuc_cyc',13,'==');  
Spoton_zld_cyc13=call_spoton(data_folder,cdata_list,'Zelda NC 13');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_cyc13.mat','Spoton_zld_cyc13')

cdata_list=get_datasub(data_list_10zld,'nuc_cyc',14,'==');  
Spoton_zld_cyc14=call_spoton(data_folder,cdata_list,'Zelda NC 14');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_cyc14.mat','Spoton_zld_cyc14')

cdata_list=get_datasub(data_list_10zld,'nuc_cyc',14.5,'==');  
Spoton_zld_cyc14p5=call_spoton(data_folder,cdata_list,'Zelda NC 14.5');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_cyc14p5.mat','Spoton_zld_cyc14p5')

cdata_list=get_datasub(data_list_10zld,'nuc_cyc',14,'>=');  
Spoton_zld_cyc_ge14=call_spoton(data_folder,cdata_list,'Zelda NC >=14');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_cyc_ge14.mat','Spoton_zld_cyc_ge14')
 
cdata_list=get_datasub(data_list_10zld,'EL_bin',1,'==');      
Output_struct_Ant=call_spoton(data_folder,cdata_list,'Zld Ant');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\ZldAnt.mat','Output_struct_Ant')


cdata_list=get_datasub(data_list_10zld,'EL_bin',2,'=='); 
Output_struct_Mid=call_spoton(data_folder,cdata_list,'Zld Mid');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\ZldMid.mat','Output_struct_Mid')
  
cdata_list=get_datasub(data_list_10zld,'EL_bin',3,'==');      
Output_struct_Post=call_spoton(data_folder,cdata_list,'Zld Post');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\ZldPost.mat','Output_struct_Post')



%% BCD

data_folder='H:\ZLD_BCDMEOS_2018_04\';  % path with data folders specified in excel file
Spoton_bcd_all_together=call_spoton(data_folder,data_list_10bcd,'Bcd');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_bcd_all_together.mat','Spoton_bcd_all_together')
   
cdata_list=get_datasub(data_list_10bcd,'EL_bin',1,'==');      
Output_struct_Antbcd=call_spoton(data_folder,cdata_list,'Bicoid Ant');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Output_struct_Antbcd.mat','Output_struct_Antbcd')
     
cdata_list=get_datasub(data_list_10bcd,'EL_bin',2,'==');      
Output_struct_Midbcd=call_spoton(data_folder,cdata_list,'Bicoid Mid');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Output_struct_Midbcd.mat','Output_struct_Midbcd')
     
cdata_list=get_datasub(data_list_10bcd,'EL_bin',3,'==');      
Output_struct_Postbcd=call_spoton(data_folder,cdata_list,'Bicoid Post');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Output_struct_Postbcd.mat','Output_struct_Postbcd')
%% H2B 
data_folder='G:\Zelda\'; % path with data folders specified in excel file
Output_struct_h2b=call_spoton(data_folder,data_list_10h2b,'Histones');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Output_struct_h2b.mat','Output_struct_h2b')
%% H2B by EM

data_folder='G:\Zelda\'; % path with data folders specified in excel file
clear cname
for k=1:size(data_list_10h2b,2)
    cname{k,1}=[data_list_10h2b(k).folder_name,data_list_10h2b(k).set_name];
    cname{k,2}=data_list_10h2b(k).folder_name;
    cname{k,3}=data_list_10h2b(k).set_name;
    
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear Spoton_h2bby_em  names_list
for cem=1:length(c)
    cem
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_10h2b,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    Spoton_h2bby_em{cem}=call_spoton(data_folder,cdata_list,'H2B byEM');

end
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_h2bby_em.mat','Spoton_h2bby_em')


%% BCD by EM

data_folder='H:\ZLD_BCDMEOS_2018_04\';  % path with data folders specified in excel file
clear cname
for k=1:size(data_list_10bcd,2)
    cname{k,1}=[data_list_10bcd(k).folder_name,data_list_10bcd(k).set_name];
    cname{k,2}=data_list_10bcd(k).folder_name;
    cname{k,3}=data_list_10bcd(k).set_name;
    
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear Spoton_bcdby_em _em names_list
for cem=1:length(c)
    cem
    clear comp_t
    %     cem=1;
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_10bcd,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    Spoton_bcdby_em{cem}=call_spoton(data_folder,cdata_list,'Bicoid byEM');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_bcdby_em.mat','Spoton_bcdby_em')
end

%%
%% zld by EM

data_folder='G:\Zelda\'; % path with data folders specified in excel file
clear cname
for k=1:size(data_list_10zld,2)
    cname{k,1}=[data_list_10zld(k).folder_name,data_list_10zld(k).set_name];
    cname{k,2}=data_list_10zld(k).folder_name;
    cname{k,3}=data_list_10zld(k).set_name;
    
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear Spoton_zldby_em _em names_list
for cem=1:length(c)
    cem
    clear comp_t
    %     cem=1;
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_10zld,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    Spoton_zldby_em{cem}=call_spoton(data_folder,cdata_list,'Bicoid byEM');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zldby_em.mat','Spoton_zldby_em')
end

%% zld by EM and NC

data_folder='G:\Zelda\'; % path with data folders specified in excel file
clear cname
for k=1:size(data_list_10zld,2)
    cname{k,1}=[data_list_10zld(k).folder_name,data_list_10zld(k).set_name];
    cname{k,2}=data_list_10zld(k).folder_name;
    cname{k,3}=data_list_10zld(k).set_name;
    
end
[c,ia, ic]=unique(cname(:,1));
ctr=1;

clear Spoton_zldby_em_andNC names_list
for cem=1:length(c)
    cem
    clear comp_t
    %     cem=1;
    cfolder_name=cname{ia(cem),2};
    cset_name=cname{ia(cem),3};
    cdata_list=get_datasub(data_list_10zld,'folder_name',cfolder_name,'==');
    cdata_list=get_datasub(cdata_list,'set_name',cset_name,'==');
    cdata_list2=get_datasub(cdata_list,'nuc_cyc',13,'<=');  
    Spoton_zldby_em_andNC{cem,1}=call_spoton(data_folder, cdata_list2,'zld byEM<=13');
    cdata_list2=get_datasub(cdata_list,'nuc_cyc',14,'>=');  
    Spoton_zldby_em_andNC{cem,2}=call_spoton(data_folder, cdata_list2,'zld byEM>=14');
save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zldby_em_andNC.mat','Spoton_zldby_em_andNC')
end
%%
%% bcd all individually

data_folder='H:\ZLD_BCDMEOS_2018_04\'; % path with data folders specified in excel file
clear cname
clear Spoton_bcdindiv
for k=1:size(data_list_10bcd,2)
Spoton_bcd_indiv{k}=call_spoton(data_folder, data_list_10bcd(k),['bcd indiv',num2str(k)]);
    
end

save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_bcd_indiv.mat','Spoton_bcd_indiv')


%% zld all individually

data_folder='G:\Zelda\'; % path with data folders specified in excel file
clear cname
clear Spoton_zld_indiv
for k=1:size(data_list_10zld,2)
Spoton_zld_indiv{k}=call_spoton(data_folder, data_list_10zld(k),['zld indiv',num2str(k)]);
    
end

save('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zld_indiv.mat','Spoton_zld_indiv')

%%
clear fbound
for k=1:size(Spoton_zld_indiv,2)
    fbound(k,1)=Spoton_zld_indiv{k}.merged_model_params(3);
    fbound(k,2)=data_list_10zld(k).EL_bin;
    fbound(k,3)=data_list_10zld(k).nuc_cyc;
end

% fbound(fbound(:,3)<13,3)=13;
% fbound(fbound(:,3)>14,3)=14;
% fbound(fbound(:,3)<12,:)=[];
figure, boxplot(fbound(:,1),fbound(:,2))
% 
% cyc14=fbound;
% cyc14(fbound(:,3)<14,:)=[]; cyc14(cyc14(:,3)>14,:)=[];
% 
% cyc13=fbound;
% cyc13(fbound(:,3)<13 ,:)=[]; cyc13(cyc13(:,3)>13,:)=[];

El1=fbound; El1(fbound(:,2)~=1 ,:)=[];
El2=fbound; El2(fbound(:,2)~=2 ,:)=[];
El3=fbound; El3(fbound(:,2)~=3 ,:)=[];

% cyc13=fbound;
% cyc13(fbound(:,3)<13 ,:)=[]; cyc13(cyc13(:,3)>13,:)=[]

h = ttest2(EL1(:,1),EL2(:,1))
% [p,tbl,stats] = kruskalwallis(fbound(:,1),fbound(:,2));
% c = multcompare(stats)

%%
clear fbound
for k=1:size(Spoton_bcd_indiv,2)
    fbound(k,1)=Spoton_bcd_indiv{k}.merged_model_params(3);
    fbound(k,2)=data_list_10bcd(k).EL_bin;
    fbound(k,3)=data_list_10bcd(k).nuc_cyc;
end

% fbound(fbound(:,3)<13,3)=13;
% fbound(fbound(:,3)>14,3)=14;
% fbound(fbound(:,3)<12,:)=[];
figure, boxplot(fbound(:,1),fbound(:,2))
El1=fbound; El1(fbound(:,2)~=1 ,:)=[];
El2=fbound; El2(fbound(:,2)~=2 ,:)=[];
El3=fbound; El3(fbound(:,2)~=3 ,:)=[];
[h,p] = ttest2(El1(:,1),El2(:,1))
%%
% load('E:\Dropbox\Darzacq\Drosophila\Zelda\Matlab_SPTAnalysis\Spoton_zldby_em_andNC.mat')
% 
% for cem=1:3
%     fbound(cem,1)=Spoton_zldby_em_andNC{cem,1}.merged_model_params(3);
%     fbound(cem,2)=Spoton_zldby_em_andNC{cem,2}.merged_model_params(3);
% end

