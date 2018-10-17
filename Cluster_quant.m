function [coefficients] = Cluster_quant(tif_folder,roi_folder, shuffle_bool)
%CLUSTER_TIME_DECAY Summary of this function goes here
%   Detailed explanation goes here
frames_spacer = 20; %20 or 2
frames_duration = 500; %200 or 35
sigma = 2;

stack = load_tiffstack(tif_folder, 'CamB');
stack = imgaussfilt(stack, sigma);
L = get_regions_from_ROIs(roi_folder, stack);
L_binary = L_matrix_binarize(L);
stack_norm = allFrames_stack_normalize_bynucleus(stack, L);

nuclei = unique(L);
nuclei = nuclei(2:end); %drop 0
nuclei_shuffled = vertcat(nuclei(2:end), nuclei(1)); %scramble order of nuclei IDs
stack_count = 0;
coefficients = [];
%imagesc(stack_norm(:,:,:,6));

for nframe1 = 1:frames_spacer:size(stack, 4) %start every frames_spacer frames
    if (nframe1 + frames_duration) <= size(stack, 4)
        stack_count = stack_count + 1
        frame1 = stack_norm(:,:,:,nframe1);
        frame1 = frame1(L_binary > 0);
        frame_count = 0;
        for nframe2 = (nframe1 + 1):(nframe1 + frames_duration)
            frame_count = frame_count + 1;
            frame2 = stack_norm(:,:,:,nframe2);
            if (shuffle_bool)
                newframe2 = frame2;
                for k = 1:length(nuclei)
                    newframe2(L == nuclei(k)) = frame2(L == nuclei_shuffled(k));
                    %newframe2(L == nuclei(k)) = frame2(L == nuclei(k));
                end
                frame2 = newframe2;
            end
            frame2 = frame2(L_binary > 0); 
            r_matrix = corrcoef(double(frame1), double(frame2));
            coefficients(frame_count, stack_count) = r_matrix(2);
        end
    end
end

end

function [binarymask] = L_matrix_binarize(inmatrix);
    binarymask = inmatrix;
    binarymask(binarymask > 0) = 1;
end

function [L] = get_regions_from_ROIs(roi_path, stack)
%Takes a folder of ROI files 
%   Detailed explanation goes here
L = zeros(size(stack, 1), size(stack, 2));
if (roi_path(end) ~= '/')
   roi_path = strcat(roi_path, '/'); 
end
roi_files = dir([roi_path,'*.roi']);
for roi_file=1:length(roi_files)
        %roi_file
        roi_files(roi_file).name;
        ROI = ReadImageJROI([roi_path,roi_files(roi_file).name]);
        %{
        ROI.vnRectBounds(1)
        ROI.vnRectBounds(2)
        ROI.vnRectBounds(3)
        ROI.vnRectBounds(4)
        %}
        L(ROI.vnRectBounds(1):ROI.vnRectBounds(3), ROI.vnRectBounds(2):ROI.vnRectBounds(4)) = roi_file;
    end
end

function [outstack] = allFrames_stack_normalize_bynucleus(instack, L_in)
    outstack = instack;
    for k = 1:size(instack,4)
        outstack(:,:,:,k) = stack_normalize_bynucleus(instack(:,:,:,k), L_in);
    end
end