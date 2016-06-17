function [  ] = selected_a_file( source, event )
%SELECTED_A_FILE Summary of this function goes here
%   Detailed explanation goes here

%% Get user information
hfig = gcf;
h = hfig.UserData;

fname =  h.controls.file_list.String{h.controls.file_list.Value};

% root_dir = h.controls.selected_folder.String;
% root_dir = strrep(root_dir,'Folder: ','');

%% Load Data 
%based on file selected by user

[ overall, test_curve, test_point, error,success_flag ] = SQUID_viewer_load_data( [h.file_dir,'\',fname ]);

%update display to indicate which file extensions were succesfully located
switch success_flag(1)
    case 1
        h.controls.indicator.raw.ForegroundColor = [0 200 0]/255;
    case 0
        h.controls.indicator.raw.ForegroundColor = [200 0 0]/255;
end
switch success_flag(2)
    case 1
        h.controls.indicator.dat.ForegroundColor = [0 200 0]/255;
    case 0
        h.controls.indicator.dat.ForegroundColor = [200 0 0]/255;
end
switch success_flag(3)
    case 1
        h.controls.indicator.ndat.ForegroundColor = [0 200 0]/255;
    case 0
        h.controls.indicator.ndat.ForegroundColor = [200 0 0]/255;
end

if ~all(success_flag)
%     rethrow(error)
    h.controls.slider.Enable = 'off';
    h.warning.Visible = 'on';    
    return
else 
    h.warning.Visible = 'off';
    h.controls.slider.Enable = 'on';
end

nTimes = numel(test_curve); %Number of measurements at each field point
nFields = numel(test_point); %Number of field points

%store data in handle
h.data.overall = overall;
h.data.test_curve = test_curve;
h.data.test_point = test_point;
h.data.nTimes = nTimes;
h.data.nFields = nFields;
hfig.UserData = h;

%% Plot Color Choices
marker_colors = cool(nTimes);

%% Update Plots - MH Curve
%average MH curve
h.lines.MH_avg.XData = overall.H;
h.lines.MH_avg.YData = overall.M_avg;

%nTimes MH data
%need to replicate figure handle if nTimes handles don't already exist
if numel(h.lines.MH_all) < nTimes+1
    for i = 2:nTimes+1
        h.lines.MH_all(i) = copyobj(h.lines.MH_all(1),h.axes.MH);
    end
end

for i = 1:nTimes
    h.lines.MH_all(i).XData = test_curve(i).H;
    h.lines.MH_all(i).YData = test_curve(i).M;
    h.lines.MH_all(i).Marker = '.';
    h.lines.MH_all(i).MarkerFaceColor = marker_colors(i,:);
    h.lines.MH_all(i).MarkerEdgeColor = marker_colors(i,:);
    h.lines.MH_all(i).LineStyle = 'none';   
end

%highlight a single point 
h.lines.MH_all(end).XData = overall.H(1);
h.lines.MH_all(end).YData = overall.M_avg(1);
h.lines.MH_all(end).Marker = 'o';
h.lines.MH_all(end).MarkerFaceColor = 'none';
h.lines.MH_all(end).MarkerEdgeColor = 'r';

%include legend
leg_str = {'Average'};
for i = 1:nTimes
   leg_str{i+1} = ['Loop ', num2str(i)]; 
end
leg_str{end+1} = 'Current Point';

h.legends.MH = legend([h.lines.MH_avg, h.lines.MH_all],leg_str,'Location','SouthEast');

%% Std M vs H
%plot initial graph
h.lines.stdMH(1).XData = overall.H;
h.lines.stdMH(1).YData = overall.M_std;
h.lines.stdMH(1).Marker = '.';
 
%ensure that a second handle exists to plot the location of the current
%point
if numel(h.lines.stdMH) ~= 2
    h.lines.stdMH(2) = copyobj(h.lines.stdMH(1),h.axes.StdMH);
end

%update current point
h.lines.stdMH(2).XData = overall.H(1);
h.lines.stdMH(2).YData = overall.M_std(1);
h.lines.stdMH(2).Marker = 'o';
h.lines.stdMH(2).MarkerEdgeColor = 'r';

%% Voltage vs Position
%plot initial graph
if numel(h.lines.VP) ~= nTimes
    for i = 2:nTimes
        h.lines.VP(i) = copyobj(h.lines.VP(1),h.axes.VP);
    end
end

for i = 1:nTimes
    h.lines.VP(i).XData = test_point(1).centering(i).position;
    h.lines.VP(i).YData = test_point(1).centering(i).voltage;
    h.lines.VP(i).Marker = '.';
    h.lines.VP(i).Color = marker_colors(i,:);
end

%create legend
legend(h.lines.VP,leg_str(2:end-1))

%% Update basic slider information
h.controls.slider.Max = nFields;
h.controls.slider.Min = 1;
h.controls.slider.SliderStep = [1/(nFields-1),10/(nFields-1)]; %[min step, max step]
h.controls.slider.Value = 1;
h.controls.slider.Enable = 'on';

%update labels
h.controls.slider_point_label.String = ['Point Number: ',...
    num2str(h.controls.slider.Value),' / ',...
    num2str(nFields)];

%% return handles to figure
hfig.UserData = h;


end

