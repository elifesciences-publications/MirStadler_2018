function [Reg] = ROIs_get_centers(roi_path)
%Takes a folder of ROI files 
%   Detailed explanation goes here

roi_files = dir([roi_path,'*.roi']);
for roi_file=1:length(roi_files)
        roi_files(roi_file).name;
        ROI = ReadImageJROI([roi_path,roi_files(roi_file).name]);
        roi_center_y = mean([ROI.vnRectBounds(3), ROI.vnRectBounds(1)]);
        roi_center_x = mean([ROI.vnRectBounds(4), ROI.vnRectBounds(2)]);
        if roi_file == 1
            %Control_circles = sqrt((rr-croi_center_x).^2+(cc-croi_center_y).^2)<=CircleRadius;
            Reg{1}=[roi_center_x, roi_center_y];
        else
            Reg{roi_file}=[roi_center_x, roi_center_y];
        end

    end
end

