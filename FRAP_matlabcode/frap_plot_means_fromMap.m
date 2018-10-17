function  frap_plot_means_fromMap(frapData,smoothWindowSize, numberofFrames)
%FRAP_PLOT_MEANS Plots the frap_norm_means for our FRAP data
%   Detailed explanation goes here
framerate = 0.0240;
names = keys(frapData);
figure();
colors = ['k','b','r'];
hold on;
for k=1:length(names)
    name=char(names(k));
    sample_matrix = frapData(name);
    num_samples = length(sample_matrix(1,:));
    means = mean(sample_matrix,2);
    std_devs = std(sample_matrix, 0, 2);
    std_err_mean = std_devs ./ sqrt(num_samples);
    %frap_plot_smoothed(means, smoothWindow, numberofframes);
    means_smoothed=smooth(means, smoothWindowSize);

    %ylim([0,1.6])
    %ylim([0.2,2])

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

legend(names);
hold off
end

