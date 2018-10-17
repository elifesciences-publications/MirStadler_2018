%uses tiff files first use czi_to_tiff.m to convert if needed and run
%read_meta.m as well
clear all
dat_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_test/tiffs/';
anal_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_test/analysis/';



mkdir(anal_path);
cfiles=dir([dat_path,'*.tif']);%get list of czi filees

min_disp=200; max_disp=2000;
CircleRadius = 4;  % radius of spot for analysis
DarkRadius=4; % radius of dark spots for background


%%
% figure
% hold on
for c=1:length(cfiles)
    clear bsSpotIntensity  corrSpotIntensity InitSpotIntensity norm_FRAP

%     c=4; 
%     c=1;
    cstack=loadtiff([dat_path,cfiles(c).name]);
    cname=cfiles(c).name(1:end-4);
    
    nframes=size(cstack,3);
    ImWidth=size(cstack,2);
    ImHeight=size(cstack,1);
    
    
    meta_path=[anal_path,cname,'_meta.mat']; %polygon path
    load(meta_path);
    
    BleachFrame=meta_data.BleachTime+1;
    % make a mask with the bleach regions
    [rr, cc] = meshgrid(1:ImWidth,1:ImHeight);
    clear Spot_circle Spot_circle2
    for creg=1:size(meta_data.BleachReg,2)
        clear bleach_plist
        bleach_plist=meta_data.BleachReg{creg};
        BleachCenter=[mean(bleach_plist(:,1)), mean(bleach_plist(:,2))]; % get center of bleachspot
        if creg==1
            Spot_circle = sqrt((rr-BleachCenter(1,1)).^2+(cc-BleachCenter(1,2)).^2)<=CircleRadius; % make circle
        else
            Spot_circle2 = sqrt((rr-BleachCenter(1,1)).^2+(cc-BleachCenter(1,2)).^2)<=CircleRadius; % update circle matrix
            Spot_circle=Spot_circle2+Spot_circle;
        end
    end    
    
    CC = bwconncomp(Spot_circle);  Bleach_L = labelmatrix(CC); %create a label matrix with spots
  
    clear SpotIntensity NucMean Spot_vals Dark_vals DarkIntensity FrameMean
    
    mip=max(cstack, [], 3);

    dark_path=[anal_path,cname,'_dark_center.mat']; %save dark point
    if exist(dark_path,'file')==0 %dark spot region doesn't exist 
        DarkCenter=click_cell(mip,DarkRadius,min_disp, max_disp);
        save(dark_path,'DarkCenter') % save it to the directory    
    else
        load(dark_path);
    end    
    Dark_circle = sqrt((rr-DarkCenter(1,1)).^2+(cc-DarkCenter(1,2)).^2)<=DarkRadius;

    for cimg=1:nframes

        cslice=cstack(:, :, cimg);
        for cspot=1:max(max(Bleach_L))          
            SpotIntensity(cimg,cspot)=mean(mean(cslice(Bleach_L==cspot)));          
        end
        
        DarkIntensity(cimg,1)=mean(mean(cslice(Dark_circle)));   
                  
        FrameMean(cimg,1)=mean(mean(cslice));


        % overlay spot circles
        cslice2=cslice;
        cslice2(bwperim(Spot_circle))=60000;
        cslice2(bwperim(Dark_circle))=60000;
        labelled_img(:,:,cimg)=cslice2;

    end
    
    if exist([anal_path,cname,'_labelled.tif'],'file')==0 
        write3Dtiff(labelled_img,[anal_path,cname,'_labelled.tif']);
    end
    
%      figure
%     hold on
%     for k=1:size(SpotIntensity,2)
%         plot(SpotIntensity(:,k));
%     end
%     hold off
    
    
%     figure
%     hold on
    bsFrameMean = FrameMean - DarkIntensity; %1. SUBTRACT BLACK BACKGROUND from Frame mean
    for k=1:size(SpotIntensity,2)
        %1. SUBTRACT BLACK BACKGROUND
        bsSpotIntensity(:,k) = SpotIntensity(:,k) - DarkIntensity;
        corrSpotIntensity(:,k) = bsSpotIntensity(:,k) ./bsFrameMean; %2. ADJUST FOR PHOTOBLEACHING
        InitSpotIntensity(:,k)=mean(corrSpotIntensity(1:BleachFrame-1,k)); %3. Normalize for Initial Spot Intensity 
        norm_FRAP(:,k) = corrSpotIntensity(:,k)./mean(InitSpotIntensity(:,k)); 
%         plot(norm_FRAP(:,k));
    end
%     hold off
    
    FRAP_data(c).name=cname;
    FRAP_data(c).norm_FRAP=norm_FRAP;   
    FRAP_data(c).SpotIntensity=SpotIntensity;
    FRAP_data(c).bsSpotIntensity=bsSpotIntensity;
    FRAP_data(c).corrSpotIntensity=corrSpotIntensity;
    FRAP_data(c).FrameMean=FrameMean;
    FRAP_data(c).bsFrameMean=bsFrameMean;
    FRAP_data(c).DarkIntensity=DarkIntensity;
    FRAP_data(c).InitSpotIntensity=InitSpotIntensity;
    FRAP_data(c).BleachFrame=BleachFrame;
    FRAP_data(c).FrameRate=meta_data.FrameTime;
%     FRAP_data(c).BleachCenter=BleachCenter;
%     FRAP_data(c).DarkCenter=DarkCenter;
%     FRAP_data(c).DarkRadius=DarkRadius;
%     FRAP_data(c).CircleRadius=CircleRadius ;
   
end
   



    
%%
save([anal_path,'FRAP_anal.mat'],'FRAP_data') % save it to the directory    




