function particle_list=autodetect_parts(cstackA, dog1, dog2, thresh, bigsz, smallsz, cslice, check_surr,...
    wsurrxy, wssurrz, surr_thresh, disp)
    
    cstack1=imgaussfilt3(cstackA,dog1); %apply median filter (figure 2) 
    cstack2 = imgaussfilt3(cstackA,dog2); %apply gaussian filter
    cstack3 = cstack2-cstack1; %apply gaussian filter
    thresh_int  = prctile(cstack3(:),thresh); % set a treshold
    BW2 = cstack3 > thresh_int;

    BW3 = BW2 - bwareaopen(BW2, bigsz); %clear big
    BW4 = bwareaopen(BW3, smallsz); %clear small
    BW5 = imclearborder(BW4);
    CC = bwconncomp(BW5); %finds connected components in a binary image  
    L = labelmatrix(CC); %creates a label matrix from the connected components structure CC returned by bwconncomp. The size of L is CC. 

    clear particle_list

    if sum(L(:))~=0
        stats=regionprops3(L,cstackA,'WeightedCentroid','MinIntensity','MaxIntensity','MeanIntensity','Volume');  
        stats=table2struct(stats);
        pctr=1;
        particle_list(1,1:4)=0; %initialize
        for s=1:size(stats,1)
            if check_surr==1 % check the surrounding to see if the particle stands out from its background
                
                if round(stats(s).WeightedCentroid(2))-wsurrxy < 1 ...
                    ||round(stats(s).WeightedCentroid(2))+wsurrxy > size(cstackA,1) ...
                    ||round(stats(s).WeightedCentroid(1))-wsurrxy < 1 ...
                    || round(stats(s).WeightedCentroid(1))+wsurrxy > size(cstackA,2)...
                    ||round(stats(s).WeightedCentroid(3))-wssurrz < 1 ...
                    || round(stats(s).WeightedCentroid(3))+wssurrz > size(cstackA,3) % if too close to edge then ignore
                                 
                else
                
                    cdotI = max(cstackA(round(stats(s).WeightedCentroid(2))-wsurrxy:round(stats(s).WeightedCentroid(2))+wsurrxy,...
                        round(stats(s).WeightedCentroid(1))-wsurrxy:round(stats(s).WeightedCentroid(1))+wsurrxy,...
                        round(stats(s).WeightedCentroid(3))-wssurrz:round(stats(s).WeightedCentroid(3))+wssurrz),[],3); % max projection
                    cdotProf=mean(cdotI,1); %mean intensity profile
                    ratio_to_surr=(max(cdotProf)-min(cdotProf))/max(cdotProf); %compare max and min of profile
%                    figure('Position',[100,100,300,300]),plot(cdotProf)
                    if ratio_to_surr>surr_thresh
                        particle_list(pctr,1)=stats(s).WeightedCentroid(1); %xpos
                        particle_list(pctr,2)=stats(s).WeightedCentroid(2); %ypos
                        particle_list(pctr,3)=stats(s).WeightedCentroid(3); %zpos
                        particle_list(pctr,4)=s; %index 
                        pctr=pctr+1;
                    end
                end
            else                       
                particle_list(s,1)=stats(s).WeightedCentroid(1); %xpos
                particle_list(s,2)=stats(s).WeightedCentroid(2); %ypos
                particle_list(s,3)=stats(s).WeightedCentroid(3); %zpos
                particle_list(s,4)=s; %index
            end
        end
    else
            particle_list(1,1:4)=0; %return empty
    end
    
    

    if disp==1
        cmip=max(cstackA,[],3);
        figure('Position',[100,100,1550,800])
        figr=2; figc=6;
        subplot(figr,figc,1),imagesc(cstackA(:,:,cslice)), axis image, colormap gray, title('Original')
        subplot(figr,figc,2),imagesc(cstack1(:,:,cslice)), axis image, colormap gray, title('gaussian filter 1')
        subplot(figr,figc,3),imagesc(cstack2(:,:,cslice)), axis image, colormap gray, title('gaussian filter 2')
        subplot(figr,figc,4),imagesc(cstack3(:,:,cslice)), axis image, colormap gray, title('DOG')
        subplot(figr,figc,5),imagesc(BW2(:,:,cslice)), axis image, colormap gray, title('Threshold')
        subplot(figr,figc,6),imagesc(BW3(:,:,cslice)), axis image, colormap gray, title('remove large structures')
        subplot(figr,figc,7),imagesc(BW4(:,:,cslice)), axis image, colormap gray, title('remove small structures')
        subplot(figr,figc,8),imagesc(BW5(:,:,cslice)), axis image, colormap gray, title('clear border')
        subplot(figr,figc,9),imagesc(cmip),axis image; title('Original max proj and dets')
        
%         figure('Position',[100,100,300,300]),imagesc(cstackA(:,:,cslice)), axis image, colormap gray, axis off, box off %title('Original')
%         figure('Position',[100,100,300,300]),imagesc(cstack1(:,:,cslice)), axis image, colormap gray, axis off, box off %title('gaussian filter 1')
%         figure('Position',[100,100,300,300]),imagesc(cstack2(:,:,cslice)), axis image, colormap gray,axis off, box off %title('gaussian filter 2')
%         figure('Position',[100,100,300,300]),imagesc(cstack3(:,:,cslice)), axis image, colormap gray,axis off, box off %title('DOG')
%         figure('Position',[100,100,300,300]),imagesc(BW2(:,:,cslice)), axis image, colormap gray,axis off, box off %title('Threshold')
%         figure('Position',[100,100,300,300]),imagesc(BW3(:,:,cslice)), axis image, colormap gray, axis off, box off%title('remove large structures')
%         figure('Position',[100,100,300,300]),imagesc(BW4(:,:,cslice)), axis image, colormap gray,axis off, box off %title('remove small structures')
%         figure('Position',[100,100,300,300]),imagesc(BW5(:,:,cslice)), axis image, colormap gray,axis off, box off %title('clear border')
%         figure('Position',[100,100,300,300]),imagesc(cmip),axis image; %title('Original max proj and dets')
%           figure('Position',[100,100,300,300]),imagesc(L(:,:,cslice)),axis off, box off
        
        colormap gray
        hold on
            scatter(particle_list(:,1),particle_list(:,2),1,'.r')
            text(particle_list(:,1),particle_list(:,2)+3,num2str(particle_list(:,4)))
        hold off
        subplot(figr,figc,10), imagesc(cstackA(:,:,cslice)),axis image;title('Original cslice and dets')
%          figure, imagesc(cstackA(:,:,cslice)),axis image,axis off, box off; %title('Original cslice and dets')
        colormap gray
        hold on
%         cpartlist=particle_list;
%         cpartlist(round(particle_list(:,3))<cslice-2,:)=[]; cpartlist(round(cpartlist(:,3))>cslice+2,:)=[];
%         scatter(cpartlist(:,1),cpartlist(:,2),25,'+g')
%         text(cpartlist(:,1),cpartlist(:,2)+3,num2str(cpartlist(:,4)))
        scatter(particle_list(:,1),particle_list(:,2),1,'.r')
        text(particle_list(:,1),particle_list(:,2)+3,num2str(particle_list(:,4)))
        hold off   
    end
  
end
