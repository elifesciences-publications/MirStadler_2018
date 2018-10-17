function data_list=mask_trajs(data_list, redo_mask)
    %% reject points that are outside of the nucleus defined by the polygon
    for cstack=1:size(data_list,2)
        cstack
        clear ctrajs ctraj_filt ctr ctrack cpoly data
        data_list(cstack).tracked_path_filt=[data_list(cstack).tracked_path(1:end-4),'_filt.mat'];
        if exist(data_list(cstack).tracked_path_filt,'file')==0 || redo_mask
        load(data_list(cstack).tracked_path)
%         load(data_list(cstack).mask_path)
            if isstruct(data)                    
                load(data_list(cstack).mask_path) %load in mask polys
                frame_s=data_list(cstack).frame_s; frame_e=data_list(cstack).frame_e;
                cmip=loadtiff(data_list(cstack).mip_path);
                if cpoly{1}~=0
                    for croi=2:length(cpoly)
                        cmask=cpoly{croi};
                        if croi==2
                            BW = poly2mask(cmask(:,1),cmask(:,2), size(cmip,1), size(cmip,2));
                        else
                            BW_temp = poly2mask(cmask(:,1),cmask(:,2), size(cmip,1), size(cmip,2));
                            BW=or(BW,BW_temp);
                        end
                    end
                    BW=uint16(BW);
                end                               
                ctrajs=data.tr;
                ctr=1;
                ctraj_filt={};
                for ctrj=1:size(ctrajs,2)
%                     if size(ctrajs{ctrj},1) > 1 % if more than 1 point in trajectory
                        ctrack=ctrajs{ctrj};
                        isout=0;
                        for k=1:size(ctrack,1)
                            if BW(round(ctrack(k,2)),round(ctrack(k,1)))==0                                
                                isout=1;
                            end               
                        end
                        
                        if ctrack(1,3)<frame_s || ctrack(end,3) > frame_e
                            isout=1;
                        end
                        
                        if isout==0
                            ctraj_filt{ctr}=ctrack;
                            ctr=ctr+1;
                        end            
%                     end
                end

            data.tr_filt=ctraj_filt;            
            save(data_list(cstack).tracked_path_filt,'data')  
            end
        end
    end            
end