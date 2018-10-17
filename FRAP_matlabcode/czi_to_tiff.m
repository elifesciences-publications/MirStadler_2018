% need to have bioformats installed to open czi files
% dat_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per\';
% save_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per_tiffs\';
dat_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/czi/';
save_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/TIFFs/';
cfiles=dir([dat_path,'*.czi']);%get list of czi files
mkdir(save_path);
%%
for c=1:length(cfiles)
    %%
    clear data
    c
    cname=cfiles(c).name;
    data = bfopen([dat_path,cname]);
    
    %%
    imgs=data{1,1};
    clear cstack
    parfor cimg=1:length(imgs)
%         cimg=1;
        I=imgs{cimg,1};
        cstack(:,:,cimg)=I;
%         imagesc(I);
    end
    write3Dtiff(cstack,[save_path,cname(1:end-3),'tif']);
end