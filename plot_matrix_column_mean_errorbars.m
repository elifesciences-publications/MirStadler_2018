function  plot_matrix_column_mean_errorbars(inmatrix, smoothWindowSize, numberofFrames, color, frame_duration)
%PLOT_MATRIX_COLUMN_MEAN_ERRORBARS Summary of this function goes here
%   Detailed explanation goes here
    framerate = frame_duration;
    num_samples = length(inmatrix(1,:));
    means = mean(inmatrix,2);
    std_devs = std(inmatrix, 0, 2);
    std_err_mean = std_devs ./ sqrt(num_samples);
    means_smoothed = smooth(means, smoothWindowSize);    
    %means_smoothed = postbleach_smoothed;
    %return
   % shadedErrorBar(framerate * (1:numberofFrames),means_smoothed(1:numberofFrames),std_err_mean(1:numberofFrames), 'lineprops',{'markerfacecolor',colors{k}, 'color', colors{k}, 'linewidth', 2.5});
    shadedErrorBar(framerate * (1:numberofFrames),means_smoothed(1:numberofFrames),std_err_mean(1:numberofFrames), 'lineprops',{'markerfacecolor',color, 'color', color, 'linewidth', 2.5});
    xlabel('Time (ms)')
    ylabel('Mean Correlation')
end

