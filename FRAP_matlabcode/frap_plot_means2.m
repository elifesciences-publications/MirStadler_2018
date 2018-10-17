function  [prebleach_smoothed postbleach_smoothed] = frap_plot_means2(frapData, bleach_frame, smoothWindowSize, numberofFrames)
%FRAP_PLOT_MEANS Plots the frap_norm_means for our FRAP data
%   Detailed explanation goes here
framerate = 0.0240;
figure();
colors = ['k','b','r','y'];
hold on;
for k=1:length(frapData)
    sample_matrix = frapData(k).norm_FRAP;
    num_samples = length(sample_matrix(1,:));
    means = mean(sample_matrix,2);
    std_devs = std(sample_matrix, 0, 2);
    std_err_mean = std_devs ./ sqrt(num_samples);
    prebleach_smoothed = smooth(means(1:bleach_frame), smoothWindowSize);
    postbleach_smoothed = smooth(means((bleach_frame + 1):numberofFrames), smoothWindowSize);
    means_smoothed = vertcat(prebleach_smoothed, postbleach_smoothed);
    
    %means_smoothed = postbleach_smoothed;
    %return
    errorbar(framerate * (1:numberofFrames),means_smoothed(1:numberofFrames),std_err_mean(1:numberofFrames),...
        '-o',...
        'MarkerSize', 5,...
        'LineWidth', 1,...
        'Color',colors(k),...
        'MarkerFaceColor', colors(k),...
        'MarkerSize',5);
end
xlabel('time (s)')
ylabel('Fluorescence (corrected)')

legend(frapData.Protein);
hold off
end

