% save bleaching metadata

% need to have bioformats installed to open czi files
% dat_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per\';
% save_path='F:\2017-01-23\rd2_256x256x_58msx40bleach_100per_tiffs_anal\';

% dat_path='F:\2017-01-23\rd2_256x256_58msx40bleach_100per_histones\';
% save_path='F:\2017-01-23\rd2_256x256_58msx40bleach_100per_histones_tiffs_anal\';

dat_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/czi/';
save_path='/Users/MStadler/Bioinformatics/Projects/Zelda/FRAP/FRAP_analysis_20180626/analysis/';
cfiles=dir([dat_path,'*.czi']);%get list of czi files

mkdir(save_path);
%%
for c=1:length(cfiles)
    %%
    clear data meta_data 
    c

    data = bfopen([dat_path,cfiles(c).name]);
    cname=cfiles(c).name(1:end-4)
    metadata = data{1, 2};
    % find all bleach regions
    %
    find_reg=1;
    creg=1;
    while find_reg==1
        bregion=['Global Information|TimelineTrack|TimelineElement|EventInformation|Bleaching|BleachRegion|BleachRegionGeometryString #',num2str(creg)]';
        blch_list = metadata.get(bregion);
        if isempty(blch_list)
            find_reg=0;
        else
            %%
            clear B plist p pl
            B = regexp(blch_list,'\d*','Match'); % get all digits in the string
            l=1; ctr=1;
            for k=2:length(B) % go through list and make an array of numbers
                if l==1
                    fpart=B(k);
                    l=2;
                elseif l==2
                    spart=B(k);
                    l=1;
                    p=strcat(fpart,'.',spart);
                    plist(ctr)=str2num(p{1});
                    ctr=ctr+1;
                end
            end
            %%
            % now format into a point list
            l=1;
            ctr=1;
            for m=1:length(plist)
                if l==1
                    pl(ctr,l)=plist(m);
                    l=2;
                elseif l==2
                    pl(ctr,l)=plist(m);
                    l=1;
                    ctr=ctr+1;
                end
            end
            meta_data.BleachReg{creg}=pl;
           
        end        
        creg=creg+1;
    end

     meta_data.BleachTime=str2num(metadata.get('Global Information|TimelineTrack|TimelineElement|Bounds|StartT #1'));
     meta_data.BleachDuration=str2num(metadata.get('Global Information|TimelineTrack|TimelineElement|Duration #1'));
     meta_data.FrameTime=str2num(metadata.get('Global Information|Image|Channel|LaserScanInfo|FrameTime #1'));

    %%
   

%     btime='Global Information|TimelineTrack|TimelineElement|Bounds|StartT #1';
%     blch_time = metadata.get(btime);
%     
%     meta_data.BleachTime=str2num(blch_time);
    
    meta_path=[save_path,cname,'_meta.mat']; %polygon path
    save(meta_path,'meta_data') % save it to the directory
    

end

%%



