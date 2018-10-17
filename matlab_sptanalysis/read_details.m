function data_list=read_details (details_path)
% reads the excel file containing details for each data set and other
%% parameters

%excel sheet details.xlsx format, should contain a single sheet:
%1st row is headers: folder name (txt), set name (txt), 
%stack name (num), nucleus cycle (num),cell cycle phsae start and end (txt)
%%mitosis/movement (num): 0 none, 0.5 some, 1 alot or miosis
%EL(x/L) 0-1 A-p 0 if none marked
%exclude reference image, comments
%frame start frame end (num)
[num,txt] = xlsread(details_path);

%%
folder_name=txt(2:end,1); % read in set (folder) name
set_name=txt(2:end,2); % read in embryo name
stack_name=num(1:end,1); % read in names of stacks within folder to run analysis on
nuc_cyc=num(1:end,2); %nuclear cycle
phase_s=txt(2:end,5); %cell cycle phase start
phase_e=txt(2:end,6); %cell cycle phase end
motion=num(1:end,5); % motion
EL=num(1:end,6); %EL position
frame_s=num(1:end,7); %start frame
frame_e=num(1:end,8);% end frame
excl=num(1:end,9); % exclude
analyzed=num(1:end,10); % analyzed
num_nuclei=num(1:end,11); % analyzed
total_dets=num(1:end,12); % analyzed
total_traj=num(1:end,13); % analyzed
total_traj_nuc=num(1:end,14); % analyzed
%%

for cstack=1:size(stack_name,1)
    
    data_list(cstack).folder_name=folder_name{cstack}; % read in set (folder) name
    data_list(cstack).set_name=set_name{cstack}; % read in embryo name
    data_list(cstack).stack_name=stack_name(cstack); % read in names of stacks within folder to run analysis on
    data_list(cstack).nuc_cyc=nuc_cyc(cstack); %nuclear cycle
    data_list(cstack).phase_s=phase_s{cstack}; %cell cycle phase start
    data_list(cstack).phase_e=phase_e{cstack}; %cell cycle phase end
    data_list(cstack).motion=motion(cstack); % motion
    data_list(cstack).EL=EL(cstack); %EL position
    data_list(cstack).frame_s=frame_s(cstack); %start frame
    data_list(cstack).frame_e=frame_e(cstack);% end frame
    data_list(cstack).exclude=excl(cstack); % exclude
    data_list(cstack).analyzed=analyzed(cstack); % analyzed
    data_list(cstack).num_nuclei=num_nuclei(cstack); % analyzed
    data_list(cstack).total_dets=total_dets(cstack); % analyzed
    data_list(cstack).total_traj=total_traj(cstack); % analyzed
    data_list(cstack).total_traj_nuc=total_traj_nuc(cstack); % analyzed
        
end


end