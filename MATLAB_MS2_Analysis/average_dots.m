clear all

wsxy=10; % window for calculation
ctrl_dist=25; % window for displacing for ctrl

save_path=['F:\analysis_images\mean_stacks_ws',num2str(wsxy),'_ctrld',num2str(ctrl_dist),'\'];
mkdir(save_path);
%%
cdetailsl{1}=details_2018_03_13_ZLD_HbMS2_cs2em10_1;
sav_namel{1}='ZLD_HbMS2_cs2em10_1';
cdetailsl{2}=details_2018_03_13_ZLD_HbMS2_em8_1;
sav_namel{2}='ZLD_HbMS2_em8_1';
cdetailsl{3}=details_2018_03_13_ZLD_HbMS2_em14_1;
sav_namel{3}='ZLD_HbMS2_em14_1';
cdetailsl{4}=details_2018_03_13_ZLD_HbMS2_em14_2;
sav_namel{4}='ZLD_HbMS2_em14_2';
cdetailsl{5}=details_2018_03_13_ZLD_HbMS2_em14_3;
sav_namel{5}='ZLD_HbMS2_em14_3';
cdetailsl{6}=details_2018_03_13_ZLD_HbMS2_em14_4;
sav_namel{6}='ZLD_HbMS2_em14_4';
% 
% % BCD hb
cdetailsl{7}=details_2018_03_15_bcd_hb_cs2em7_1;
sav_namel{7}='bcd_hb_cs2em7_1';
cdetailsl{8}=details_2018_03_15_bcd_hb_em2_1;
sav_namel{8}='bcd_hb_em2_1';
cdetailsl{9}=details_2018_03_15_bcd_hb_em4_2;
sav_namel{9}='bcd_hb_em4_2';
cdetailsl{10}=details_2018_03_15_bcd_hb_em4_3;
sav_namel{10}='bcd_hb_em4_3';
cdetailsl{11}=details_2018_03_15_bcd_hb_em4_5;
sav_namel{11}='bcd_hb_em4_5';
cdetailsl{12}=details_2018_03_15_bcd_hb_em4_7;
sav_namel{12}='bcd_hb_em4_7';
%

for cd=1:length(cdetailsl)
% for cd=5:length(cdetailsl)
clear compA_ctrl compA compB_ctrl compB
cd
cdetails=cdetailsl{cd};
sav_name=sav_namel{cd};
% cdetails=details_2018_03_15_bcd_hb_cs2em7_1;
% sav_name='2018_03_15_bcd_hb_cs2em7_1_edgeexcl';



cdetails_files=(dir([cdetails.analysispath,'*details*.mat']));
[A,I] = max([cdetails_files(:).datenum]);
cdetails_name=cdetails_files(I).name;
load([cdetails.analysispath,cdetails_name]);

% cdetails.analysispath='F:\2017_12_07_ZLDEVE\em_10_1_analysis\';
% cdetails.dat_path='F:\2017_12_07_ZLDEVE\em_10_1\';

cms2_files=(dir([cdetails.analysispath,'*MS2_list*.mat']));
[A,I] = max([cms2_files(:).datenum]);
cms2_name=cms2_files(I).name;
cdetails.MS2_listpath=[cdetails.analysispath,cms2_name];
load(cdetails.MS2_listpath);

MS2_list(:,6)=0;
MS2_list(:,7)=0;
%
cfilesA=dir(strcat(cdetails.dat_path,'*CamA*.tif'));
cfilesB=dir(strcat(cdetails.dat_path,'*CamB*.tif'));



%%
clear meanA meanB meanActrl meanBctrl

frames=unique(MS2_list(:,5));

fr_ctr=1;
p_ctr=1;
%
for cf=1:length(frames)
% for cf=202:length(frames)
    %
    cf
    cframe=frames(cf);
    cstackA=loadtiff(strcat(cdetails.dat_path,cfilesA(cframe).name));
    cstackB=loadtiff(strcat(cdetails.dat_path,cfilesB(cframe).name));
    cstackBsub=cstackB-mean(cstackB(:));
    
    cMS2=MS2_list(MS2_list(:,5)==cframe,:);
    %
    ctr=1;
%     ctr_excl=1;
    clear cimgA cimgB cimgA_ctrl cimgB_ctrl cpexl
    for cp=1:size(cMS2,1)
        centx=cMS2(cp,1); centy=cMS2(cp,2); 
        centz=cMS2(cp,3);
        
        if centy-wsxy<1 || centy+wsxy>size(cstackA,1)...
            || centx-wsxy<1 || centx+wsxy>size(cstackA,2)                         
          % check if its close to an edge of the image
        else 
         
         
        dogimg=imgaussfilt(cstackB(:,:,centz),25)-imgaussfilt(cstackB(:,:,centz),10);
        T=adaptthresh(dogimg,'ForegroundPolarity','dark');
        BW = imbinarize(dogimg,T);
        BW=imdilate(BW,strel('disk',2));
        cwin=BW(centy-wsxy:centy+wsxy,centx-wsxy:centx+wsxy);
        if max(cwin(:)) < 1 %check if its close an edge of the nucleus
                        
            % now find a control spot
             ctrl_fnd=0;
             while ctrl_fnd==0
               ctrly=centy+ctrl_dist;  ctrlx=centx;  % first try moving in y by ctrl dist
               
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               ctrly=centy-ctrl_dist;  ctrlx=centx;  %try moving in y by -ctrl dist
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               
               ctrly=centy;  ctrlx=centx-ctrl_dist;  %try moving in x by -ctrl dist
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               ctrly=centy;  ctrlx=centx+ctrl_dist;  %try moving in x by ctrl dist
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               ctrly=centy+round(ctrl_dist/2);  ctrlx=centx+round(ctrl_dist/2);  %try moving in x and y by +ctrl dist/2
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               
               ctrly=centy-round(ctrl_dist/2);  ctrlx=centx+round(ctrl_dist/2);  %try moving in x and y by +ctrl dist/2
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               ctrly=centy+round(ctrl_dist/2);  ctrlx=centx-round(ctrl_dist/2);  %try moving in x and y by +ctrl dist/2
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
               ctrly=centy-round(ctrl_dist/2);  ctrlx=centx-round(ctrl_dist/2);  %try moving in x and y by +ctrl dist/2
               if ~(ctrly-wsxy<1 || ctrly+wsxy>size(cstackA,1)...
                    || ctrlx-wsxy<1 || ctrlx+wsxy>size(cstackA,2))  
               cwinctrl=BW(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy);           
               if max(cwinctrl(:)) < 1; ctrl_fnd=1; break;   end
               end
               
                break                           
             end
             
          if ctrl_fnd==0 
        
%             cframe
%             'no ctrl found'
          else
            cimgA_ctrl(:,:,ctr)=cstackA(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy,centz);
            cimgB_ctrl(:,:,ctr)=cstackBsub(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy,centz);
            cimgA(:,:,ctr)=cstackA(centy-wsxy:centy+wsxy,centx-wsxy:centx+wsxy,centz);
            cimgB(:,:,ctr)=cstackBsub(centy-wsxy:centy+wsxy,centx-wsxy:centx+wsxy,centz);
            
            compA_ctrl(:,:,p_ctr)= cstackA(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy,centz);
            compB_ctrl(:,:,p_ctr)= cstackBsub(ctrly-wsxy:ctrly+wsxy,ctrlx-wsxy:ctrlx+wsxy,centz);
            compA(:,:,p_ctr)=cstackA(centy-wsxy:centy+wsxy,centx-wsxy:centx+wsxy,centz);
            compB(:,:,p_ctr)=cstackBsub(centy-wsxy:centy+wsxy,centx-wsxy:centx+wsxy,centz);
      
            ctr=ctr+1;
            p_ctr=p_ctr+1;
            
          end
          
        else
%             cpexl(ctr_excl,1)=cMS2(cp,4);
%             ctr_excl=ctr_excl+1;
        end
            
        end                
    end  
    %
%     sumA(:,:,cf)=sum(cimgA,3);
%     sumB(:,:,cf)=sum(cimgB,3);
if exist('cimgA')
    meanA(:,:,fr_ctr)=mean(cimgA,3);
    meanB(:,:,fr_ctr)=mean(cimgB,3);
    
    meanActrl(:,:,fr_ctr)=mean(cimgA_ctrl,3);
    meanBctrl(:,:,fr_ctr)=mean(cimgB_ctrl,3);
    
    fr_ctr=fr_ctr+1;
end

end


if exist('meanA')
write3Dtiff(uint16(meanA),[save_path,sav_name,'_meanA.tif']);
write3Dtiff(uint16(meanB),[save_path,sav_name,'_meanB.tif']);

write3Dtiff(uint16(meanActrl),[save_path,sav_name,'_meanActrl.tif']);
write3Dtiff(uint16(meanBctrl),[save_path,sav_name,'_meanBctrl.tif']);

write3Dtiff(uint16(compA),[save_path,sav_name,'_compA.tif']);
write3Dtiff(uint16(compB),[save_path,sav_name,'_compB.tif']);
write3Dtiff(uint16(compA_ctrl),[save_path,sav_name,'_compActrl.tif']);
write3Dtiff(uint16(compB_ctrl),[save_path,sav_name,'_compBctrl.tif']);

end
'done'

sav_name
% p_ctr
% fr_ctr

end
