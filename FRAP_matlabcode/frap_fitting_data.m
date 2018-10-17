function [time_series, means] = frap_fitting_data(frap_data,sample_num, bleach_frame, curvelength)
%FRAP_FITTING_DATA Summary of this function goes here
%   Detailed explanation goes here
    time_interval = 0.0218;
    means = mean(frap_data(sample_num).norm_FRAP(bleach_frame+1:curvelength+bleach_frame+1,:), 2);
    time_series = 0:time_interval:(time_interval * curvelength);
end

