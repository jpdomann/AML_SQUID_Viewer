function [  ] = moved_slider( source,eventdata )
%MOVED_SLIDER Summary of this function goes here
%   Detailed explanation goes here

%% Get user information
hfig = gcf;
h = hfig.UserData;

%% Get current slider position
point_no = round(h.controls.slider.Value);
h.controls.slider.Value = point_no; %ensure it is an integer
nTimes = h.data.nTimes;

%% Update Plots 
%MH Curve
h.lines.MH_all(end).XData = h.data.overall.H(point_no);
h.lines.MH_all(end).YData = h.data.overall.M_avg(point_no);

%MH Std dev Curve
h.lines.stdMH(2).XData = h.data.overall.H(point_no);
h.lines.stdMH(2).YData = h.data.overall.M_std(point_no);

%Voltage vs Position
for i = 1:nTimes
    h.lines.VP(i).XData = h.data.test_point(point_no).centering(i).position;
    h.lines.VP(i).YData = h.data.test_point(point_no).centering(i).voltage;    
end

%% Update Controls
%slider label
h.controls.slider_point_label.String = ['Point Number: ',...
    num2str(h.controls.slider.Value),' / ',...
    num2str(h.data.nFields)];

%% return handles to figure
hfig.UserData = h;

end

