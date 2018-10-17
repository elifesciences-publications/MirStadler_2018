% 1. Create ROIs for control and dark regions in ImageJ. I load the movie and
% do a sum projection. I choose control regions in the nuclei and dark
% regions between nuclei. The shape and size of ROIs don't matter, just
% their center, as this script is going to grab their center and then build
% regions of some radius from them. ROIs need to be saved (unzipped) in
% folders with names that match the TIFF name with '_controlROIs' and
% '_darkROIs' appended.
% 2. Convert czi files to TIFF using Mustafa's czi_to_tiff.m
% 3. Read metadata using read.meta.m, puts critical file meta_data.m in
% 'analysis' folder
% 4. Run this code.
% 5. Manually ad a "protein" category to output data structure to match
% datasets on the protein measured (this could be improved but meh).
% 6. Review individual traces using "eval_traces" to decide which to
% include in making plots/fitting.
% 7. Plot resulting data structure with frap_plot_means2
% 8. Fit using fitting toolbox
%Start with czi to tiff conversion
%Must have control ROI folders with names that match the TIFF name with '_controlROIs' appended
%Also must have read_meta.m, get this from read.meta.m
clear all
dat_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/TIFFs_zelda2/'; %location of TIFFs
anal_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/analysis/';
roi_folder='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/ROIs_zelda2/';

mkdir(anal_path);
cfiles=dir([dat_path,'*.tif']);%get list of tif filees

min_disp=200; max_disp=2000;
CircleRadius = 4;  % radius of spot for analysis
DarkRadius=4; % radius of dark spots for background

%% Loads each TIFF one by one, gets its control ROIs
for c=1:length(cfiles)
    clear bsBleachSpotIntensity  corrBleachSpotIntensity InitBleachSpotIntensity norm_FRAP controlROI_files
    
    cstack=loadtiff([dat_path,cfiles(c).name]); %load our image stack
    cname=cfiles(c).name(1:end-4)
    meta_path=[anal_path,cname,'_meta.mat']; %load metadata
    load(meta_path);
    
    %get a bunch of useful info into variables
    cname=cfiles(c).name(1:end-4);
    nframes=size(cstack,3);
    ImWidth=size(cstack,2);
    ImHeight=size(cstack,1);
    BleachFrame=meta_data.BleachTime+1;
    [rr, cc] = meshgrid(1:ImWidth,1:ImHeight); %This is just a useful blank mask that comes in handy a few times
    
    %Get the centers of control and dark ROIs in the right format to put
    %into label matrix maker
    controlROI_path = [roi_folder,cname,'_controlROIs/'];
    darkROI_path = [roi_folder,cname,'_darkROIs/'];
    if exist(controlROI_path, 'file') && exist(darkROI_path, 'file')
        ControlReg = ROIs_get_centers(controlROI_path);
        DarkReg = ROIs_get_centers(darkROI_path);
    
        % make label matrices for the bleach control, and dark regions
        [Bleach_L, Spot_circle] = makeSpotLabelMatrix(meta_data.BleachReg, CircleRadius, ImWidth, ImHeight);
        [Control_L, Control_circle] = makeSpotLabelMatrix(ControlReg, CircleRadius, ImWidth, ImHeight);
        [Dark_L, Dark_circle] = makeSpotLabelMatrix(DarkReg, CircleRadius, ImWidth, ImHeight);
        clear BleachSpotIntensity ControlSpotIntensity DarkSpotIntensity NucMean Spot_vals Dark_vals DarkIntensity ControlSpotMean;

        %Get mean intensities for each spot
        BleachSpotIntensity=spot_intensities_calc(cstack, Bleach_L, nframes);
        ControlSpotIntensity=spot_intensities_calc(cstack, Control_L, nframes);
        DarkSpotIntensity=spot_intensities_calc(cstack, Dark_L, nframes);
        ControlSpotMean = mean(ControlSpotIntensity, 2);
        DarkSpotMean = mean(DarkSpotIntensity, 2);

        bsControlSpotMean = ControlSpotMean - DarkSpotMean; %1. SUBTRACT BLACK BACKGROUND from control mean to get background-subtracted control spot mean
        for k=1:size(BleachSpotIntensity,2)
            % Subtract black background from bleach spot intensities to yield
            % background-subtracted intensities
            bsBleachSpotIntensity(:,k) = BleachSpotIntensity(:,k) - DarkSpotMean;
            % Divide by mean control spot intensity (both
            % background-subtracted) to correct for photobleaching
            corrBleachSpotIntensity(:,k) = bsBleachSpotIntensity(:,k) ./bsControlSpotMean;
            % Normalize each spot intensity value to the mean of the first n
            % frames before bleaching
            InitBleachSpotIntensity(:,k)=mean(corrBleachSpotIntensity(1:BleachFrame-1,k));  
            norm_FRAP(:,k) = corrBleachSpotIntensity(:,k)./mean(InitBleachSpotIntensity(:,k)); 
        end

        % Put everything into our FRAP_data structure
        FRAP_data(c).name=cname;
        FRAP_data(c).norm_FRAP=norm_FRAP;   
        FRAP_data(c).BleachSpotIntensity=BleachSpotIntensity;
        FRAP_data(c).bsBleachSpotIntensity=bsBleachSpotIntensity;
        FRAP_data(c).corrBleachSpotIntensity=corrBleachSpotIntensity;
        FRAP_data(c).ControlSpotMean=ControlSpotMean;
        FRAP_data(c).bsControlSpotMean=bsControlSpotMean;
        FRAP_data(c).DarkSpotMean=DarkSpotMean;
        FRAP_data(c).InitBleachSpotIntensity=InitBleachSpotIntensity;
        FRAP_data(c).BleachFrame=BleachFrame;
        FRAP_data(c).FrameRate=meta_data.FrameTime;
    %     FRAP_data(c).BleachCenter=BleachCenter;
    %     FRAP_data(c).DarkCenter=DarkCenter;
    %     FRAP_data(c).DarkRadius=DarkRadius;
    %     FRAP_data(c).CircleRadius=CircleRadius ;
end
end
     
%%
save([anal_path,'FRAP_anal.mat'],'FRAP_data') % save it to the directory    




