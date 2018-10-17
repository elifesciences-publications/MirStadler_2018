function data_list=crop_nuclei(data_folder, data_list, redo_crop)

    for cstack=1:size(data_list,2)
        %%
        clear cpoly
        cstack
        cdir_path=[data_folder, data_list(cstack).folder_name,'\',data_list(cstack).set_name,'\'];
        cname=[num2str(data_list(cstack).stack_name),'CamA'];
        mask_path=[cdir_path,cname,'_masks.mat']; %tracking mat path
        data_list(cstack).mask_path=mask_path;
        if exist(mask_path,'file')==0 || redo_crop %mip doesnt exist  so make it
            cmip=loadtiff(data_list(cstack).mip_path);
%             h = msgbox('Adjust the image scaling and hit enter to start segmentation','Yo momma so fat..','modal');
%             figure(1),imagesc(cmip,[130,241]), axis image %display the image  500 ms   
%              figure(1),imagesc(cmip,[110,190]), axis image %display the image  100 ms   
            figure(1),imagesc(imgaussfilt(cmip,1),[120,145]), axis image %display the image   10 ms
            colormap gray %change the colormap to gray     
            
            
            key=waitforbuttonpress; % press enter after adjusting the scale if needed
            while (key == 0)      
                key=waitforbuttonpress;
            end
            
            choice = questdlg('What are you segmenting?', ...
            'What are you segmenting?', ...
            'Clear Nuclei','Regions with detections','Nothing','Nothing');
            switch choice
                case 'Clear Nuclei'
                    havenuc = 1;
                    cpoly{1}=1; 
                case 'Regions with detections'
                    havenuc  = -1;
                    cpoly{1}=-1; 
                case 'Nothing'
                    havenuc  = 0;
                    cpoly{1}=0;
            end
            
            if havenuc==1 || havenuc==-1 % if drwaing a region
                draw=1; % set while variable to 1
                ctr=2; % start writing in second part of cell
                cpoly{ctr}=draw_poly; % call draw poly function             
                while draw                   
                choice = questdlg('draw another?','draw more?','Yes','No','No');
                    switch choice
                    case 'Yes'
                        ctr=ctr+1;
%                         cpoly(:,:,ctr)=draw_poly
                        cpoly{ctr}=draw_poly;
                    case 'No'
                        draw=0;
                    end
                end
            else
%                 cpoly={};
            end
            save(mask_path,'cpoly') % save it to the directory      
            close all   

%             cstack
        end
        
    end
end

function cpoly=draw_poly
%     h = imellipse; %ask the user to draw a polygon 
    h = impoly; %ask the user to draw a polygon     
%     cpoly=getPosition(h); %get the polygon
    cpoly = wait(h);
end

%%
% for croi=2:length(cpoly)
%     cmask=cpoly{croi};
%     if croi==2
%         BW = poly2mask(cmask(:,1),cmask(:,2), size(cmip,1), size(cmip,2));
%     else
%         BW_temp = poly2mask(cmask(:,1),cmask(:,2), size(cmip,1), size(cmip,2));
%         BW=uint16(or(BW,BW_temp));
%     end
% end
    
%     
% % BW = uint16(poly2mask(cmask(:,1),cmask(:,2), size(cmip,1), size(cmip,2)));
% figure, imagesc(BW), axis image
% figure, imagesc(cmip), axis image
% colormap gray
% figure, imagesc(BW.*cmip), axis image
% colormap gray

