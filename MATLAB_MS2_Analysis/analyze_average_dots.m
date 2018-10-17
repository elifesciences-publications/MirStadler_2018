clear all
dat_path='F:\analysis_images\mean_stacks_ws10_ctrld25\'

% do zld
cZldnm=dir([dat_path,'*ZLD*meanActrl*.tif']);
for c=1:size(cZldnm,1)
    cname=cZldnm(c).name;
    cZldnames{c}=cname(1:end-13);
end
ctr=1;
%
for c=1:size(cZldnames,2)
    A_zld=double(loadtiff([dat_path,cZldnames{c},'meanA.tif']));
    A_zld_ctrl=double(loadtiff([dat_path,cZldnames{c},'meanActrl.tif']));
    B_zld=double(loadtiff([dat_path,cZldnames{c},'meanB.tif']));
    B_zld_ctrl=double(loadtiff([dat_path,cZldnames{c},'meanBctrl.tif']));
    
    ccompA_zld=double(loadtiff([dat_path,cZldnames{c},'compA.tif']));
    ccompA_zldctrl=double(loadtiff([dat_path,cZldnames{c},'compActrl.tif']));
    ccompB_zld=double(loadtiff([dat_path,cZldnames{c},'compB.tif']));
    ccompB_zldctrl=double(loadtiff([dat_path,cZldnames{c},'compBctrl.tif']));
    
    [Zr_zld(c,:), R] = radialavg(mean(ccompB_zld,3),11,0,0);
    [Zr_zldctrl(c,:), R] = radialavg(mean(ccompB_zldctrl,3),11,0,0);
    
    
    
    for k=1:size(ccompA_zld,3)
    compA_zld(:,:,ctr)=ccompA_zld(:,:,k);
    compA_zldctrl(:,:,ctr)=ccompA_zldctrl(:,:,k);
    compB_zld(:,:,ctr)=ccompB_zld(:,:,k);
    compB_zldctrl(:,:,ctr)=ccompB_zldctrl(:,:,k);
    ctr=ctr+1;
    end
      
end

% bcd
cbcdnm=dir([dat_path,'*bcd*meanActrl*.tif']);
for c=1:size(cbcdnm,1)
    cname=cbcdnm(c).name;
    cbcdnames{c}=cname(1:end-13);
end
%
ctr=1;

for c=1:size(cbcdnames,2)
    A_bcd=double(loadtiff([dat_path,cbcdnames{c},'meanA.tif']));
    A_bcd_ctrl=double(loadtiff([dat_path,cbcdnames{c},'meanActrl.tif']));
    B_bcd=double(loadtiff([dat_path,cbcdnames{c},'meanB.tif']));
    B_bcd_ctrl=double(loadtiff([dat_path,cbcdnames{c},'meanBctrl.tif']));
    
    ccompA_bcd=double(loadtiff([dat_path,cbcdnames{c},'compA.tif']));
    ccompA_bcdctrl=double(loadtiff([dat_path,cbcdnames{c},'compActrl.tif']));
    ccompB_bcd=double(loadtiff([dat_path,cbcdnames{c},'compB.tif']));
    ccompB_bcdctrl=double(loadtiff([dat_path,cbcdnames{c},'compBctrl.tif']));
    
    for k=1:size(ccompA_bcd,3)
    compA_bcd(:,:,ctr)=ccompA_bcd(:,:,k);
    compA_bcdctrl(:,:,ctr)=ccompA_bcdctrl(:,:,k);
    compB_bcd(:,:,ctr)=ccompB_bcd(:,:,k);
    compB_bcdctrl(:,:,ctr)=ccompB_bcdctrl(:,:,k);
    ctr=ctr+1;
    end
   
end


%% plot Normalized

ccol_bcd= [72/255, 143/255, 208/255];
ccol_zld= [255/255, 148/255, 5/255]; 

rvec=0:0.104:0.104*10;
figure('Position',[100,100,210,150])
hold on
clear Zr_norm
for c=1:size(compB_zld,3)
    [Zr, R] = radialavg(compB_zld(:,:,c),11,0,0);
    norm_r=1/Zr(end);
    Zr_norm(c,:)=Zr.*norm_r;
%     line(R,Zr_norm(c,:))
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color',ccol_zld)
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

clear Zr_norm
for c=1:size(compB_zldctrl,3)
    [Zr, R] = radialavg(compB_zldctrl(:,:,c),11,0,0);
    norm_r=1/Zr(end);
    Zr_norm(c,:)=Zr.*norm_r;
%     line(R,Zr_norm(c,:))
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color','k')
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

hold off
xlim([0,1.1])
ylim([1,1.3])
%
figure('Position',[100,100,210,150])
hold on
clear Zr_norm
for c=1:size(compB_bcd,3)
    [Zr, R] = radialavg(compB_bcd(:,:,c),11,0,0);
    norm_r=1/Zr(end);
    Zr_norm(c,:)=Zr.*norm_r;
%     line(R,Zr_norm(c,:))
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color',ccol_bcd)
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

clear Zr_norm
for c=1:size(compB_bcdctrl,3)
    [Zr, R] = radialavg(compB_bcdctrl(:,:,c),11,0,0);
    norm_r=1/Zr(end);
    Zr_norm(c,:)=Zr.*norm_r;
%     line(R,Zr_norm(c,:))
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color','k')
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

hold off
xlim([0,1.1])
ylim([1,1.3])

%%

figure,imagesc(mean(compB_zld,3)), axis image; colormap gray;axis off; box off;
figure,imagesc(mean(compB_zldctrl,3)), axis image; colormap gray;axis off; box off;
% figure,imagesc(mean(compB_zld,3)-mean(compB_zldctrl,3)), axis image; axis off; box off;

%
figure,imagesc(mean(compB_bcd,3)), axis image; colormap gray; axis off; box off;
figure,imagesc(mean(compB_bcdctrl,3)), axis image; colormap gray; axis off; box off;
% figure,imagesc(mean(compB_bcd,3)-mean(compB_bcdctrl,3)), axis image; colormap gray; axis off; box off;

%%
figure,imagesc(mean(compB_zld,3)/max(compB_zld(:))), axis image; colormap gray;axis off; box off;
figure,imagesc(mean(compB_zldctrl,3)/max(compB_zld(:))), axis image; colormap gray;axis off; box off;
% figure,imagesc(mean(compB_zld,3)-mean(compB_zldctrl,3)), axis image; axis off; box off;

%
figure,imagesc(mean(compB_bcd,3)/max(compB_zld(:))), axis image; colormap gray; axis off; box off;
figure,imagesc(mean(compB_bcdctrl,3)/max(compB_zld(:))), axis image; colormap gray; axis off; box off;
% figure,imagesc(mean(compB_bcd,3)-mean(compB_bcdctrl,3)), axis image; colormap gray; a
%%

%% Plot Unnormalized

ccol_bcd= [72/255, 143/255, 208/255];
ccol_zld= [255/255, 148/255, 5/255]; 

rvec=0:0.104:0.104*10;
figure('Position',[100,100,210,150])
hold on
clear Zr_norm
for c=1:size(compB_zld,3)
    [Zr, R] = radialavg(compB_zld(:,:,c),11,0,0);
    Zr_norm(c,:)=Zr;
%     line(R,Zr_norm(c,:))
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color',ccol_zld)
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

clear Zr_norm
for c=1:size(compB_zldctrl,3)
    [Zr, R] = radialavg(compB_zldctrl(:,:,c),11,0,0);
    Zr_norm(c,:)=Zr;
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color','k')
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

hold off
xlim([0,1.1])
ylim([40,56])

figure('Position',[100,100,210,150])
hold on
clear Zr_norm
for c=1:size(compB_bcd,3)
    [Zr, R] = radialavg(compB_bcd(:,:,c),11,0,0);
    Zr_norm(c,:)=Zr;
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color',ccol_bcd)
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');
%
clear Zr_norm
for c=1:size(compB_bcdctrl,3)
    [Zr, R] = radialavg(compB_bcdctrl(:,:,c),11,0,0);
    norm_r=1;
    Zr_norm(c,:)=Zr;
end

line(rvec,mean(Zr_norm,1),'LineWidth',2,'Color','k')
errorbar(rvec,mean(Zr_norm,1),std(Zr_norm,0,1)./sqrt(size(Zr_norm,1)),'LineStyle','none','Marker','none','CapSize',5,'Color','k');

hold off
xlim([0,1.1])
ylim([40,56])

