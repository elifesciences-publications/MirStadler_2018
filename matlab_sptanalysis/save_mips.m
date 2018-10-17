function data_list=save_mips(data_folder, data_list)
%%
    for cstack=1:size(data_list,2)
        %%
%         cstack=1;
        cdir_path=[data_folder, data_list(cstack).folder_name,'\',data_list(cstack).set_name,'\'];
        cname=[num2str(data_list(cstack).stack_name),'CamA'];
         data_list(cstack).zld_path=[cdir_path,cname,'.tif'];
        mip_path=[cdir_path,cname,'_mipc.tif']; %tracking mat path

        data_list(cstack).mip_path=mip_path;
        if exist(mip_path,'file')==0 %mip doesnt exist  so make it
            cimg=loadtiff(data_list(cstack).zld_path);
            frame_s=data_list(cstack).frame_s; frame_e=data_list(cstack).frame_e; 
            mip = max(cimg(:,:,frame_s:frame_e), [], 3);
            write3Dtiff(mip,mip_path);
%             figure 
%             imagesc(mip), axis image
%             colormap gray
            cstack
        end
        
    end
end