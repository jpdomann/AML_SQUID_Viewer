function [ files,folders,rootDir ] = FilesAndFolders( varargin )
%FILESANDFOLDERS Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    rootDir = varargin{1};
else
    rootDir = pwd;
end

flag = true;                %continue while loop until no directories left
directories = {rootDir};  %initial directory
checkedDirs = false;        %history indicating directories that have been checked
files = [];                 %initialize file list

while flag
    ind = find(checkedDirs==false,1);    %index of unchecked directories        
%     if isempty(ind)
%         checkedDirs(ind) = true;
%        continue 
%     end
    direc = directories{ind};   %directory to check  (only returns first)       
    listing = dir(direc);       %contents of directory   
    
    %sort out directories and files 
    newFiles = {listing(~[listing.isdir]).name}';  %files list
    dirs = {listing([listing.isdir]).name}';    %directory list
    dirs(strcmp(dirs,'.'))=[];  %Cancel out current and prior directory
    dirs(strcmp(dirs,'..'))=[]; %Cancel out current and prior directory
          
    %Convert files to full path
    if ~isempty(newFiles)
        newFiles = cellfun(@fullfile,repmat({direc},numel(newFiles),1),newFiles,'UniformOutput',false);        
    end
    
    %Convert directories to full paths 
    if isempty(dirs)
        newDirecs = [];       
    else
        newDirecs = cellfun(@fullfile,repmat({direc},numel(dirs),1),dirs,'UniformOutput',false);        
    end
    newChecks = false(size(newDirecs));
    
    %Append new directories to current directories
    directories = [directories;newDirecs];
    checkedDirs(ind) = true;
    checkedDirs = [checkedDirs;newChecks];
    files = [files;newFiles];
    
    %if all directories have been checked, move on
    if all(checkedDirs) 
        flag = false;    
    end
end

%Remove the root directory from all files / folder
pattern = [rootDir,'\'];
files = strrep(files,pattern,'');
folders = strrep(directories,pattern,'');
folders = setdiff(folders,rootDir);
end

