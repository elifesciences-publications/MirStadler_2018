%{
Using FRAP_data structure, gets mean of selected columns for a given
dataset, writes that to the field mean_norm_FRAP. The reason for the column
selection is occasionally one of the spots is bad.
Maybe usage: FRAP_data(3).mean_norm_FRAP=get_selected_means(FRAP_data, 3, [1:5])
%}

function means=get_selected_means(frapData, samplenumber, columns)
    means = mean(frapData(samplenumber).norm_FRAP(:,columns),2)
end