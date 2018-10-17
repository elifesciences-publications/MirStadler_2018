function [spotlabelmatrix, Spot_circle] = makeSpotLabelMatrix(bleachreg, radius,ImWidth, ImHeight)
% Takes a matrix of bleach regions in the CZI format, which is a list of
% x,y coordinate pairs describing all pixels covered by an ROI. Finds the
% center (mean of hte x and y coordinates, which assumes an oval or
% rectangle or other regular polygon I guess). Using supplied radius, it
% then creates a mask of circles around the spots and then converts this
% into a label matrix, returning said matrix. 
% NOTE: as currently implemented, the input from control and dark spots is
% the centers themselves, but the function works because the means of
% single x and y points are just the points themselves, so it works for
% both input types.
        [rr, cc] = meshgrid(1:ImWidth,1:ImHeight);
        clear Spot_circle Spot_circle2
        for creg=1:size(bleachreg,2)
            clear bleach_plist
            bleach_plist=bleachreg{creg};
            BleachCenter=[mean(bleach_plist(:,1)), mean(bleach_plist(:,2))]; % get center of bleachspot
            if creg==1
                Spot_circle = sqrt((rr-BleachCenter(1,1)).^2+(cc-BleachCenter(1,2)).^2)<=radius; % make circle
            else
                Spot_circle2 = sqrt((rr-BleachCenter(1,1)).^2+(cc-BleachCenter(1,2)).^2)<=radius; % update circle matrix
                Spot_circle=Spot_circle2+Spot_circle;
            end
        end    

        CC = bwconncomp(Spot_circle);  spotlabelmatrix = labelmatrix(CC); %create a label matrix with spots
    end