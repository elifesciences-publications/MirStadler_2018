for cstack=1:size(data_list,2)
% cstack=5
        load((data_list(cstack).mask_path)
          cmip_img=imread(data_list(cstack).mip_path);
          
          
    if cpoly{1}~=0
        for croi=2:length(cpoly)
            cmask=cpoly{croi};
            if croi==2
                BW = poly2mask(cmask(:,1),cmask(:,2), size(cmip_img,1), size(cmip_img,2));
            else
                BW_temp = poly2mask(cmask(:,1),cmask(:,2), size(cmip_img,1), size(cmip_img,2));
                BW=or(BW,BW_temp);
            end
        end
        BW=uint16(BW);
    end  
  [rows, columns] = find(bwperim(BW)); 
  figure
  hold on
  imagesc(cmip_img,[130,241]), axis image  
  scatter(columns, rows,1,'w.')
  hold off

  colormap gray
end