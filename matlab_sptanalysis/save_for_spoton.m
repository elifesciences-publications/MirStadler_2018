function data_list=save_for_spoton(data_list,pars,redo_save)
%frame,t,trajectory,x,y,

frate=pars.fr; %frame rate
um_px=pars.um_px; %um_pixel

%%
for cstack=1:size(data_list,2)
    %%
%     cstack=9
    cstack
    
    
    
%     sav_path=[dir_path,dat_name,'_spoton.mat'];
    data_list(cstack).tracked_path_spot_on=[data_list(cstack).tracked_path(1:end-4),'_filt_spoton.mat'];
    if exist( data_list(cstack).tracked_path_spot_on,'file')==0 || redo_save %tracking doesnt exist  so do it
        clear data
        load(data_list(cstack).tracked_path_filt);
        ctrajs=data.tr_filt;
        ctr=1;
        for ctrj=1:size(ctrajs,2)
            clear ctemp ctrack
            if size(ctrajs{ctrj},1) > 1 % if more than 1 point in trajectory
                ctemp=ctrajs{ctrj};
                ctrack(:,1)=ctemp(:,3); % frame
                ctrack(:,2)=(ctemp(:,3)-1).*frate; %time
                ctrack(:,3)=ctemp(:,4);
                ctrack(:,4)=ctemp(:,1).*um_px;
                ctrack(:,5)=ctemp(:,2).*um_px;
    %             if isempty(comp_tracks)
    %                 comp_tracks=ctrack;
    %             else
    %                 comp_tracks=vertcat(comp_tracks,ctrack);
    %             end
               % for matlab version
                trackedPar(ctr).xy=horzcat(ctrack(:,4),ctrack(:,5));
                trackedPar(ctr).Frame=ctrack(:,1); 
                trackedPar(ctr).TimeStamp=ctrack(:,2); 
                ctr=ctr+1;
            end
        end     
        save(data_list(cstack).tracked_path_spot_on,'trackedPar') % save data  
    end
end








