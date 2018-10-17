clear all
dat_path='F:\2018_03_13_ZLD_HbMS2\zld_hb\em8\1_eq_imadjust99\';
sav_path='F:\2018_03_13_ZLD_HbMS2\zld_hb\em8\';

cfiles=dir([dat_path,'*CamB*.tif'])';
%%
parfor c=1:size(cfiles,2)
% for c=1:2    
    c
    cstack=loadtiff(strcat(dat_path,cfiles(c).name));
    mip(:,:,c)=max(cstack,[],3);

end

 write3Dtiff(mip,strcat(sav_path,'em8_CamB_imadjust99.tif'));