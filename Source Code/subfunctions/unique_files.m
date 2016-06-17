function [ files ] = unique_files( root_dir )
%UNIQUE_FILES Summary of this function goes here
%   Detailed explanation goes here

%Assemble list of all files in the included folders.
[ files ] = FilesAndFolders( root_dir );

for i = 1:numel(files)
    temp_file = files{i};
    cutoff = strfind(temp_file,'.rso');
    switch isempty(cutoff)
        case 1
            files{i} = [];
        case 0
            files{i} = temp_file(1:cutoff-1);
    end
end
%eliminate blank entries
files = files(~cellfun(@isempty,files));

%keep only unique file names
files = unique(files);
end

