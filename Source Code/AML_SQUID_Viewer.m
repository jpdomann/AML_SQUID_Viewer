clear
clc
addpath('subfunctions')


%% Create GUI
h = create_gui( 1 );

%% Define Starting Directory
% load starting dir from txt file
filename = 'subfunctions\starting_dir.txt';
delimiter = '*';
formatSpec = '%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);
fclose(fileID);
if isempty(dataArray{:,1})
    h.starting_dir = pwd;   %set to pwd if txt file is empty
else
    h.starting_dir = dataArray{:, 1}{1};
end

%ensure starting directory exists on computer
if ~exist(h.starting_dir,'dir')
    h.starting_dir = pwd;
end

% Store starting dir in figure data
fig = gcf;
fig.UserData = h;

%% Get Data Folder and Update GUI
pick_folder();

%% Set Callback Functions
h.controls.select_folder.Callback = @pick_folder;
h.controls.file_list.Callback = @selected_a_file;
h.controls.slider.Callback = @moved_slider;
addlistener(h.controls.slider, 'Value', 'PostSet',@moved_slider);

%% Halt Program Until User Terminates Figure Window
uiwait

%RAW file - position vs voltage (64 points at fixed H)
%DAT file - 3 field / magnetization readings - from RAW voltages
%NDAT file - avg and std for field / magnetization from DAT file

