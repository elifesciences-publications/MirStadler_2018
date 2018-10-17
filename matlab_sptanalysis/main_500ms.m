clear all

pars=pars_500ms; % reads in parameters specified in pars_xxxms.m file change things here for frame rate, tracking, localization etc
% 
details_path='E:\Dropbox\Darzacq\Drosophila\Zelda\details_500msanalysis.xlsx'; % path for excel file
data_list=read_details(details_path); % read in details file see specifications in function
data_folder='G:\Zelda\'; % path with data folders specified in excel file
% % 

% details_path='E:\Dropbox\Darzacq\Drosophila\Zelda\details_500msanalysis_BCD.xlsx'; % path for excel file
% data_list=read_details(details_path); % read in details file see specifications in function
% data_folder='H:\ZLD_BCDMEOS_2018_04\'; % path with data folders specified in excel file


redo_crop=0;
redo_track=0; % set to 1 to redo tracking
redo_mask=0;

% parse cell cycle phase and assign to an EL group
data_list=parse_cycle_phase(data_list);
% save mips
data_list=save_mips(data_folder, data_list);
% segment regions or nuclei
data_list=crop_nuclei(data_folder,data_list,redo_crop);
% run tracking
data_list=run_tracking(data_folder,data_list,redo_track,pars);
% %mask trajectories according to masks and frame_s and frame_e
data_list=mask_trajs(data_list,redo_mask);


