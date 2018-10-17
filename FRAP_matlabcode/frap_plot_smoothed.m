%{
Takes a matrix where columns are each the corrected output of a FRAP
experiment. Smooths each and plots the individual curves in multiple colors
%}

function frap_plot_smoothed(FrapTable, smoothWindowSize, numberofFrames)
framerate = 0.0240;
for i=1:size(FrapTable,2)
  
    Frapsmooth(:,i)=smooth(FrapTable(1:numberofFrames,i), smoothWindowSize);
    plot(framerate * (1:numberofFrames),Frapsmooth,'-o',...
        'MarkerSize', 5,...
        'LineWidth', 2,...
        'MarkerSize',3);
    %ylim([0,1.6])
    %ylim([0.2,2])
end
xlabel('time (s)')
ylabel('Fluorescence (corrected)')
end