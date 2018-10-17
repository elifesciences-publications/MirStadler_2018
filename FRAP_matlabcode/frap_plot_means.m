function  frap_plot_means(frapData,smoothWindow, numberofframes)
%FRAP_PLOT_MEANS Plots the frap_norm_means for our FRAP data
%   Detailed explanation goes here
numberofsamples = size(frapData, 2);
figure();
hold on;
for i=1:numberofsamples
    frap_plot_smoothed(frapData(i).mean_norm_FRAP, smoothWindow, numberofframes);
end
legend(frapData(:).shortName);
hold off
end

