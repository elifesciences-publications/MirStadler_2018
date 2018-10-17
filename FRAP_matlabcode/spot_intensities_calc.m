function [SpotIntensity] = spot_intensities_calc(cstack, spotLabelMatrix, nframes)
%Simple function that takes a label matrix of "spots", a stack of images
%and determines the mean signal in each spot. Returns as a 2x double
%(from TIF)

    for cimg=1:nframes
            cslice=cstack(:, :, cimg);
            for cspot=1:max(max(spotLabelMatrix))          
                SpotIntensity(cimg,cspot)=mean(mean(cslice(spotLabelMatrix==cspot)));          
            end      
    end
    
end