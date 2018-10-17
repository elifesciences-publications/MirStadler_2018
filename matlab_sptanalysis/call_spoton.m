function Output_struct=call_spoton(data_folder,cdata_list,SampleName)

clearvars -global; 

%
data_struct = struct([]);

for cstack=1:size(cdata_list,2)
    
    data_struct(cstack).path= [data_folder, cdata_list(cstack).folder_name,'\',cdata_list(cstack).set_name,'\'];
    data_struct(cstack).workspaces = {[cdata_list(cstack).tracked_name,'_filt_spoton']};
    data_struct(cstack).Include=[1]; 
end

%%
% data_struct(1).path = 'G:\Zelda\2017_11_30_ZLD\his_10\';
% data_struct(1).path = 'G:\Zelda\2017_11_29_ZLD\em1\';
% data_struct(1).workspaces = {'10CamA_MaxD5_Off1_filt_spoton'};
% data_struct(1).Include=[1];
% SampleName = 'Zelda Cycle Group ==4';

%%%%% Acquisition Parameters: 
TimeGap = 10; % delay between frames in milliseconds
dZ = 0.8;% The axial observation slice in micrometers; Rougly 0.7 um for the example data (HiLo)
% dZ = 0.7;% The axial observation slice in micrometers; Rougly 0.7 um for the example data (HiLo)
% dZ = 1;
GapsAllowed = 1; % The number of allowed gaps in the tracking

%%%%% Data Processing Parameters:
TimePoints = 8; % How many delays to consider: N timepoints yield N-1 delays
BinWidth = 0.010; % Bin Width for computing histogram in micrometers (only for PDF; Spot-On uses 1 nm bins for CDF)
UseAllTraj = 0; % If UseAllTraj=1, all data from all trajectories will be used; If UseAllTraj=0, only the first X displacements will be used
JumpsToConsider = 4; % If UseAllTraj=0, the first JumpsToConsiders displacements for each dT where possible will be used. 
MaxJumpPlotPDF = 1.05; % the cut-off for displaying the displacement histograms plots
MaxJumpPlotCDF = 3.05; % the cut-off for displaying the displacement CDF plots
MaxJump = 5.05; % the overall maximal displacements to consider in micrometers
SavePlot = 0; % if SavePlot=1, key output plots will be saved to the folder "SavedPlots"; Otherwise set SavePlot = 0;
DoPlots = 0; % if DoPlots=1, Spot-On will output plots, but not if it's zero. Avoiding plots speeds up Spot-On for batch analysis

%%%%% Model Fitting Parameters:
ModelFit = 2; %Use 1 for PDF-fitting; Use 2 for CDF-fitting
DoSingleCellFit = 0; %Set to 1 if you want to analyse all single cells individually (slow). 
NumberOfStates = 2; % If NumberOfStates=2, a 2-state model will be used; If NumberOfStates=3, a 3-state model will be used 
FitIterations = 5; % Input the desired number of fitting iterations (random initial parameter guess for each)
FitLocError = 1; % If FitLocError=1, the localization error will fitted from the data
FitLocErrorRange = [0.010 0.075]; % min/max for model-fitted localization error in micrometers.
LocError = 0.035; % If FitLocError=0, LocError in units of micrometers will be used. 
UseWeights = 1; % If UseWeights=0, all TimePoints are given equal weights. If UseWeights=1, TimePoints are weighted according to how much data there is. E.g. 1dT will be weighted more than 5dT.
D_Free_2State = [0.15 25]; % min/max Diffusion constant for Free state in 2-state model (units um^2/s)
D_Bound_2State = [0.0005 0.08]; % min/max Diffusion constant for Bound state in 2-state model (units um^2/s)
D_Free1_3State = [0.5 25]; % min/max Diffusion constant #1 for Free state in 3-state model (units um^2/s)
D_Free2_3State = [0.5 25]; % min/max Diffusion constant #2 for Free state in 3-state model (units um^2/s)
D_Bound_3State = [0.0001 0.08]; % min/max Diffusion constant for Bound state in 3-state model (units um^2/s)

%%%%%%%%%%%%%%%%%%%%%%%%% SpotOn core mechanics %%%%%%%%%%%%%%%%%%%%%%%%%%%
Params = struct(); % Use Params to feed all the relevant data/parameters into the relevant functions
Params.TimeGap = TimeGap; Params.dZ = dZ; Params.GapsAllowed = GapsAllowed; Params.TimePoints = TimePoints; Params.BinWidth = BinWidth; Params.UseAllTraj = UseAllTraj; Params.DoPlots = DoPlots; Params.UseWeights = UseWeights;
Params.JumpsToConsider = JumpsToConsider; Params.MaxJumpPlotPDF = MaxJumpPlotPDF; Params.MaxJumpPlotCDF = MaxJumpPlotCDF; Params.MaxJump = MaxJump; Params.SavePlot = SavePlot; Params.ModelFit = ModelFit;
Params.DoSingleCellFit = DoSingleCellFit; Params.FitIterations = FitIterations; Params.FitLocError = FitLocError; Params.FitLocErrorRange = FitLocErrorRange; Params.LocError = LocError; Params.NumberOfStates = NumberOfStates;
Params.D_Free_2State = D_Free_2State; Params.D_Bound_2State = D_Bound_2State; Params.D_Free1_3State = D_Free1_3State; Params.D_Free2_3State = D_Free2_3State; Params.D_Bound_3State = D_Bound_3State;
Params.curr_dir = pwd; Params.SampleName = SampleName; Params.data_struct = data_struct;
% add the relevant paths
addpath(genpath([pwd, filesep, 'spot-on',filesep,'SpotOn_package', filesep])); 
display('Added local paths for Spot-on core mechanics');
[Output_struct] = SpotOn_core(Params);
end
