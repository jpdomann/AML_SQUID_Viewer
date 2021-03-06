function [dat,flag] =  Read_SQUID_RAW(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [TIME,COMMENT,FIELD_OE_,STARTTEMPERATURE_K_,ENDTEMPERATURE_K_,SCAN,REJECTED,POSITION_CM_,LONGVOLTAGE,LONGAVERAGEVOLTAGE,LONGDETRENDEDVOLTAGE,LONGDEMEANEDVOLTAGE,LONGREGFIT,LONGDETRENDEDFIT,LONGDEMEANEDFIT,LONGSCALEDRESPONSE,LONGAVG_SCALEDRESPONSE,LONGBACKGROUNDRESPONSE,LONGRESPONSE_W_ABS_,LONGDETRENDEDRESP__W_ABS_,LONGFIT_W_ABS_,LONGDETRENDEDFIT_W_ABS_,TRANSVOLTAGE,TRANSAVERAGEVOLTAGE,TRANSDETRENDEDVOLTAGE,TRANSDEMEANEDVOLTAGE,TRANSREGFIT,TRANSDETRENDEDFIT,TRANSDEMEANEDFIT,TRANSSCALEDRESPONSE,TRANSAVG_SCALEDRESPONSE,TRANSBACKGROUNDRESPONSE,TRANSRESPONSE_W_ABS_,TRANSDETRENDEDRESP__W_ABS_,TRANSADJUSTEDFIT,TRANSDETRENDEDFIT_W_ABS_]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [TIME,COMMENT,FIELD_OE_,STARTTEMPERATURE_K_,ENDTEMPERATURE_K_,SCAN,REJECTED,POSITION_CM_,LONGVOLTAGE,LONGAVERAGEVOLTAGE,LONGDETRENDEDVOLTAGE,LONGDEMEANEDVOLTAGE,LONGREGFIT,LONGDETRENDEDFIT,LONGDEMEANEDFIT,LONGSCALEDRESPONSE,LONGAVG_SCALEDRESPONSE,LONGBACKGROUNDRESPONSE,LONGRESPONSE_W_ABS_,LONGDETRENDEDRESP__W_ABS_,LONGFIT_W_ABS_,LONGDETRENDEDFIT_W_ABS_,TRANSVOLTAGE,TRANSAVERAGEVOLTAGE,TRANSDETRENDEDVOLTAGE,TRANSDEMEANEDVOLTAGE,TRANSREGFIT,TRANSDETRENDEDFIT,TRANSDEMEANEDFIT,TRANSSCALEDRESPONSE,TRANSAVG_SCALEDRESPONSE,TRANSBACKGROUNDRESPONSE,TRANSRESPONSE_W_ABS_,TRANSDETRENDEDRESP__W_ABS_,TRANSADJUSTEDFIT,TRANSDETRENDEDFIT_W_ABS_]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [Time,Comment,Field_Oe_,StartTemperature_K_,EndTemperature_K_,Scan,Rejected,Position_cm_,LongVoltage,LongAverageVoltage,LongDetrendedVoltage,LongDemeanedVoltage,LongRegFit,LongDetrendedFit,LongDemeanedFit,LongScaledResponse,LongAvg_ScaledResponse,LongBackgroundResponse,LongResponse_w_ABS_,LongDetrendedResp__w_ABS_,LongFit_w_ABS_,LongDetrendedFit_w_ABS_,TransVoltage,TransAverageVoltage,TransDetrendedVoltage,TransDemeanedVoltage,TransRegFit,TransDetrendedFit,TransDemeanedFit,TransScaledResponse,TransAvg_ScaledResponse,TransBackgroundResponse,TransResponse_w_ABS_,TransDetrendedResp__w_ABS_,TransAdjustedFit,TransDetrendedFit_w_ABS_] = importfile('Ni-NiO_298K_SiO2_PMN-PT_5.0Tprebias_200V_Au_back.rso.raw',22, 9429);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2016/05/26 14:19:51

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
%	column6: floating point (%f)
%   column7: floating point (%f)
%	column8: floating point (%f)
%   column9: integer (%d)
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
%	column32: integer (%d)
%   column33: integer (%d)
%	column34: floating point (%f)
%   column35: integer (%d)
%	column36: floating point (%f)
%   column37: integer (%d)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%s%f%f%f%f%f%f%d%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%d%d%f%d%f%d%[^\n\r]';

%% Open the text file.
%ensure filename has proper extension
if ~strcmp(filename(end-3:end),'.dat')
    filename = [filename,'.dat'];
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
names = {   
    'Time'
    'Comment'	
    'Field_Oe_'	
    'Temperature_K_'
    'Long_Moment_emu_'
    'Long_Scan_Std_Dev'
    'Long_Offset_cm_'
    'Long_Offset_Std_Dev'
    'Long_Algorithm'
    'Long_Reg_Fit'	
    'Long_Reg_Factor'
    'Trans_Moment_emu_'
    'Trans_Scan_Std_Dev'
    'Trans_Offset_cm_'
    'Trans_Offset_Std_Dev'	
    'Trans_Algorithm'
    'Trans_Reg_Fit'
    'Trans_Reg_Factor'
    'Long_Moment_wo_ABS_emu_'
    'Long_Scan_Std_Dev_wo_ABS'
    'Long_Offset_wo_ABS_cm_'
    'Long_Offset_Std_Dev_wo_ABS'
    'Long_Reg_Fit_wo_ABS'
    'Trans_Moment_wo_ABS_emu_'
    'Trans_Scan_Std_Dev_wo_ABS'	
    'Trans_Offset_wo_ABS_cm_'
    'Trans_Offset_Std_Dev_wo_ABS'
    'Trans_Reg_Fit_wo_ABS'	
    'RSO_Position_deg_'
    'Amplitude_cm_'
    'Frequency'
    'Cycles_to_Average'
    'Scans_per_Measurement'
    'Delta_Temp_K_'
    'Error'
    'EC_Comp_Running'
    'Using_ABS'
};
%% Allocate imported array to column variable names
for i = 1:numel(names)
   eval(['dat.',names{i},' = dataArray{:, ',num2str(i),'};'])
end
%indicate success
flag = true;

end