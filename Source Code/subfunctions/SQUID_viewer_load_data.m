function [ overall, test_curve, test_point, error, success_flag ] = SQUID_viewer_load_data( fname )
%SQUID_VIEWER_LOAD_DATA Summary of this function goes here
%   Detailed explanation goes here

%% Handle input fname
%if a folder is included, include directory, and strip from fname
%when done, remove directory from path
[pathstr,name,ext] = fileparts(fname);
switch isempty(pathstr)
    case 0
        addpath(pathstr)
        fname = [name, ext];
        if isempty(strfind(fname,'.rso'))
            fname = [fname, '.rso'];
        end
end

%% Load Raw Data
success_flag = false(1,3);
error = cell(1,3);
try
    [raw,success_flag(1)] =  Read_SQUID_Raw(fname);
catch ME
    error{1} = ME;
end
try
    [dat,success_flag(2)] =  Read_SQUID_Dat(fname);
catch ME
    error{2} = ME;
end
try
    [ndat,success_flag(3)] =  Read_SQUID_NDat(fname);
catch ME
    error{3} = ME;
end

if all(success_flag)
   error = [];
else
    %pull out first error message
    error = error{find(~success_flag==1,1)};
    %set output 
    overall = [];
    test_curve = [];
    test_point = []; 
    return
end

%% Group Data Based on Time of Acquisition
nTimes = unique(ndat.Number_of_Measurements); %number of times data is collected at a single H point

%Unique test points (group based on time variable)
computed.Time_unique = unique(raw.Time);

%field points are tested nTImes. Label data with group number
Test_Points = repmat(1:numel(computed.Time_unique)/nTimes, nTimes, 1);
computed.Test_Points = Test_Points(:);
computed.nFields = numel(unique(computed.Test_Points));
clear Test_Points

%% Assemble data for each test point
%initialize storage struct
test_point(computed.nFields) = struct('times',[],'centering',[],'H',[],'M',[]);

for i = 1:computed.nFields
    %time of data average (ndat) data set
    time_temp = computed.Time_unique(computed.Test_Points == i);
    %index for ndat
    time_index_ndat = ndat.Time == time_temp(1);
    
    %field points
    field_ndat = ndat.Field_Oe_(time_index_ndat);
    
    
    for j = 1:nTimes
        %Determine test point time
        test_point(i).times(j) = time_temp(j);
        
        %index for raw and dat files
        time_index_raw  = raw.Time  == test_point(i).times(j);
        time_index_dat  = dat.Time  == test_point(i).times(j);
        
        %Field points
        field_raw = raw.Field_Oe_(time_index_raw);
        field_dat = dat.Field_Oe_(time_index_dat);
        
        
        %Position vs Voltage (raw)
        test_point(i).centering(j).position = raw.Position_cm_(time_index_raw);
        test_point(i).centering(j).voltage = raw.Long_Average_Voltage(time_index_raw);
        
        %MH Loop x nTimes (dat)
        test_point(i).H(j) = dat.Field_Oe_(time_index_dat);
        test_point(i).M(j) = dat.Long_Moment_emu_(time_index_dat);                
        
    end
end

%% Multiple MH Loops (dat)
%Initialize storage structure
test_curve(nTimes) = struct('H',[],'M',[]);

for i = 1:nTimes
    index = i:nTimes:length(dat.Field_Oe_);
    test_curve(i).H = dat.Field_Oe_(index);
    test_curve(i).M = dat.Long_Moment_emu_(index);
end

%% Overall MH loop (ndat)
overall.H = ndat.Field_Oe_;
overall.M_avg = ndat.Avg_Moment_emu_;
overall.M_std = ndat.Standard_Error;

%% Remove input directory (if any)
switch isempty(pathstr)
    case 0
        rmpath(pathstr)
end

end

