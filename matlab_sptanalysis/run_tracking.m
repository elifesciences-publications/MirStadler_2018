function data_list=run_tracking(data_folder,data_list,redo_track,pars)
%%
    for cstack=1:size(data_list,2)
        %%
        cstack
        
%         tracked_name=['_MaxD',num2str(pars.trackpars.Dmax),'_Off',num2str(pars.trackpars.maxOffTime)]; %change name when changing parameters
        tracked_name=['er',num2str(pars.locpars.errorRate),'wn',num2str(pars.locpars.wn),'_MaxD',num2str(pars.trackpars.Dmax),'_Off',num2str(pars.trackpars.maxOffTime)]; %change name when changing parameters
        cdir_path=[data_folder, data_list(cstack).folder_name,'\',data_list(cstack).set_name,'\'];
        cname=[num2str(data_list(cstack).stack_name),'CamA'];
        tracked_path=[cdir_path,cname,tracked_name,'.mat']; %tracking mat path
%         data_list(cstack).zld_path=[cdir_path,cname,'.tif'];
        data_list(cstack).tracked_name=[cname,tracked_name];
        
        data_list(cstack).tracked_path=tracked_path;
        
        pars.impars.name=cname;    
        if exist(tracked_path,'file')==0 || redo_track %tracking doesnt exist  so do it
            clear data
            data = localizeParticles(cdir_path,pars.impars, pars.locpars);
            data=buildTracks2(cdir_path, data,pars.impars, pars.locpars, pars.trackpars, data.ctrsN);
            save(tracked_path,'data') % save data     
        end
        
    end


end

