function [ root_dir ] = pick_folder( source, event)
%PICK_FOLDER Summary of this function goes here
%   Detailed explanation goes here

%get new root folder
fig = gcf;
h = fig.UserData;
starting_dir = [h.starting_dir,'\..'];

root_dir = uigetdir(starting_dir);

%update starting_dir to root_dir
if any(root_dir ~= 0)
    filename = 'subfunctions\starting_dir.txt';
    fileID = fopen(filename,'w+');
    fwrite(fileID,root_dir);
    fclose(fileID);
    %update starting_dir in figure handle
    h.starting_dir = root_dir;
else
    root_dir = h.starting_dir;
end

%get new file list
[ files ] = unique_files( root_dir );

%update gui
[~,root_name] = fileparts(root_dir);

h.controls.selected_folder.String = ['Folder: ',root_name];
h.controls.file_list.Value = 1; 
h.controls.file_list.String = [files];
h.controls.file_list.Enable = 'on';

%reset slider position
h.controls.slider.Value = 1;

%return data to figure 
h.file_dir = root_dir;
fig.UserData = h;

%Activate the first file
try
    selected_a_file( )
catch error
    h.controls.file_list.Enable = 'off';
end

end

