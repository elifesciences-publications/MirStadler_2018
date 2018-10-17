function [protein_data] = eval_traces(frap_data)
%Allows user to examine FRAP traces from individual spots and decide
%whether to include them in the dataset or not, combines all "good" traces
%for a given protein into single data structures, returns as a struct
%containing all the good data sorted by protein. Because of unequal lengths
%of datasets, nFrames hardcoded below.
%  Manually added 'protein' field to frap data to allow combining of
%  datasets

nframes=1000; % Because not all traces are same length across datasets, just setting this here.

% Set up a figure to display traces
f = figure('Visible','on','Position',[100,100,1200,800]);
axes('Units', 'pixels', 'Position', [250,100,700,500]);

% Good button: keep trace
good_button = uicontrol('Style','pushbutton','String','Good','Position',[325,15,200, 40],'BackgroundColor','green',...
       'Callback', {@good_button_callback}); 

% Bad button: dump trace
bad_button = uicontrol('Style','pushbutton','String','Bad','Position',[625,15,200, 40],'BackgroundColor','red',...
       'Callback', {@bad_button_callback});    

protein_data_map=containers.Map; %storing good traces in a Map with protein IDs as key

dataset_num=0; %These are global so I can pass things around to callback
spot_num=0;

% Go through each trace, allow user to decide to keep or dump via gui
for dataset_num=1:length(frap_data)
      for spot_num=1:length(frap_data(dataset_num).norm_FRAP(1,:))
          frap_plot_smoothed(frap_data(dataset_num).norm_FRAP(:,spot_num),1,200)
          legend(frap_data(dataset_num).Protein)
          uiwait
      end
end
close %close figure when done
  % If bad: just pass
function bad_button_callback (hObject, eventdata, handles)  
    uiresume   
end

% If good: add trace to data map and then move on to next trace
function good_button_callback (hObject, eventdata, handles)  
        add_spot(dataset_num, spot_num);
        uiresume
end
 
% Adds a spot chosen by "good" button to the data map
function add_spot (dataset_num, spot_num)
    protein_name = frap_data(dataset_num).Protein;
    protein_name
    if isKey(protein_data_map, protein_name)
       protein_data_map(protein_name) = [protein_data_map(protein_name) frap_data(dataset_num).norm_FRAP(1:nframes,spot_num)]; 
    else
       protein_data_map(protein_name) = frap_data(dataset_num).norm_FRAP(1:nframes,spot_num);
    end
end

protein_data = struct;
proteins = keys(protein_data_map);
for k=1:length(proteins)
    protein_name = char(proteins(k));
    protein_data(k).Protein = protein_name;
    protein_data(k).norm_FRAP = protein_data_map(protein_name);
end
end

