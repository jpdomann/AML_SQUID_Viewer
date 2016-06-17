function [raw,flag] =  Read_SQUID_RAW(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [TIME]
%
% Example:
%   [raw] = importfile('Ni-NiO_298K_SiO2_PMN-PT_5.0Tprebias_200V_Au_back.rso',22, inf);
%
%    See also TEXTSCAN.

%% Initialize variables.
flag = false;
delimiter = ',';
if nargin<=2
    startRow = 22;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: floating point (%f)
%	column2: text (%s)
%   column3: floating point (%f)
%	column4: floating point (%f)
%   column5: floating point (%f)
%	column6: integer (%d)
%   column7: integer (%d)
%	column8: floating point (%f)
%   column9: floating point (%f)
%	column10: floating point (%f)
%   column11: floating point (%f)
%	column12: floating point (%f)
%   column13: floating point (%f)
%	column14: floating point (%f)
%   column15: floating point (%f)
%	column16: floating point (%f)
%   column17: floating point (%f)
%	column18: floating point (%f)
%   column19: floating point (%f)
%	column20: floating point (%f)
%   column21: floating point (%f)
%	column22: floating point (%f)
%   column23: floating point (%f)
%	column24: floating point (%f)
%   column25: floating point (%f)
%	column26: floating point (%f)
%   column27: floating point (%f)
%	column28: floating point (%f)
%   column29: floating point (%f)
%	column30: floating point (%f)
%   column31: floating point (%f)
%	column32: floating point (%f)
%   column33: floating point (%f)
%	column34: floating point (%f)
%   column35: floating point (%f)
%	column36: floating point (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%s%f%f%f%d%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
%ensure filename has proper extension
if ~strcmp(filename(end-3:end),'.raw')
    filename = [filename,'.raw'];
end
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Prepare to output data structure:
clearvars -except dataArray


names ={'Time'
'Comment'
'Field_Oe_'
'Start_Temperature_K_'
'End_Temperature_K_'
'Scan'
'Rejected'
'Position_cm_'
'Long_Voltage'
'Long_Average_Voltage'
'Long_Detrended_Voltage'
'Long_Demeaned_Voltage'
'Long_Reg_Fit'
'Long_Detrended_Fit'
'Long_Demeaned_Fit'
'Long_Scaled_Response'
'Long_Avg_Scaled_Response'
'Long_Background_Response'
'Long_Response_w_ABS'
'Long_Detrended_Resp_w_ABS'
'Long_Fit_w_ABS'
'Long_Detrended_Fit_w_ABS'
'Trans_Voltage'
'Trans_Average_Voltage'
'Trans_Detrended_Voltage'
'Trans_Demeaned_Voltage'
'Trans_Reg_Fit'
'Trans_Detrended_Fit'
'Trans_Demeaned_Fit'
'Trans_Scaled_Response'
'Trans_Avg_Scaled_Response'
'Trans_Background_Response'
'Trans_Response_w_ABS'
'Trans_Detrended_Resp_w_ABS'
'Trans_Adjusted_Fit'
'Trans_Detrended_Fit_w_ABS'
};

%% Allocate imported array to column variable names
for i = 1:numel(names)
   eval(['raw.',names{i},' = dataArray{:, ',num2str(i),'};'])
end

%indicate success
flag = true;

end