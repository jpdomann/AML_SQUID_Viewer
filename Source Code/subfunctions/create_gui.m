function [ h ] = create_gui( varargin )
%CREATE_GUI Creates a GUI for use in viewing SQUID data files
%   varargin optionally contains:
%       {1} - figure number to create gui 

%% Sort input properties
switch nargin
    case 1
        fig_num = varargin{1};
    otherwise
        fig_num = 1;
end

control_font_size = 12;

%% Setup Figure with Multiple Axes
%h handles for object
h.fig = figure(fig_num);        %figure
clf
h.axes.MH = subplot(2,2,1);          %M vs H plot
h.axes.StdMH = subplot(2,2,2);       %stdM vs H
h.axes.controls = subplot(2,2,3);    %controls
h.axes.VP = subplot(2,2,4);          %Voltage vs Position plot

% convert controls to a tab with the same position
pos = h.axes.controls.Position;
delete(h.axes.controls)

h.axes.controls = uipanel(h.fig,'Position',pos,'Title','Controls:');

%% Initialize Each Axis Plot
%MH Plot 
h.axes.MH.Title.String = 'MH Hysteresis Loop';
h.axes.MH.XLabel.String = 'Magnetic Field (Oe)';
h.axes.MH.YLabel.String = 'Magnetization (emu)';
h.axes.MH.XGrid = 'on';
h.axes.MH.YGrid = 'on';

%std. dev. M vs H
h.axes.StdMH.Title.String = 'std.dev. M vs H ';
h.axes.StdMH.XLabel.String = 'Magnetic Field (Oe)';
h.axes.StdMH.YLabel.String = '\sigma_M(emu)';
h.axes.StdMH.XGrid = 'on';
h.axes.StdMH.YGrid = 'on';
h.axes.StdMH.YScale = 'log';

%voltage vs position
h.axes.VP.Title.String = 'Voltage vs Position';
h.axes.VP.XLabel.String = 'Position (cm)';
h.axes.VP.YLabel.String = 'Voltage (volts)';
h.axes.VP.XGrid = 'on';
h.axes.VP.YGrid = 'on';

%% Initialize Lines on Each Axis
h.lines.MH_avg = line(0,0,'Parent',h.axes.MH);
h.lines.MH_all = line(0,0,'Parent',h.axes.MH);
h.lines.stdMH = line(0,0,'Parent',h.axes.StdMH);
h.lines.VP = line(0,0,'Parent',h.axes.VP);

%% Create Controls to Load Data File
h.controls.select_folder = uicontrol(h.axes.controls,...
    'Style','pushbutton',...
    'String','Select Folder',...
    'Units','Normalized',...
    'Position',[.1 .05 .25 .15]);
h.controls.file_list =  uicontrol(h.axes.controls,...
    'Style','popupmenu',...
    'String',{'File List...'},...
    'Units','Normalized',...
    'Position',[.4 .05 .5 .15]);
h.controls.selected_folder = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','Folder:',...
    'HorizontalAlignment','left',...
    'Units','Normalized',...
    'Position',[.1 .4 .8 .2]);

%Adjust font size
h.axes.controls.FontSize = control_font_size;
h.controls.select_folder.FontSize = control_font_size;
h.controls.file_list.FontSize = control_font_size;
h.controls.selected_folder.FontSize =  control_font_size;

%% Controls to Select Which Test Point to Highlight
h.controls.slider = uicontrol(h.axes.controls,...
    'Style','slider',...
    'Value',1,...
    'Min',1,...
    'Max',10,...
    'Enable','off',...
    'Units','Normalized',...
    'Position',[.1 .75 .8 .2]);
h.controls.slider_point_label = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','Point Number: X / Y',...
    'HorizontalAlignment','left',...
    'Units','Normalized',...
    'Position',[.1 .6 .8 .1]);

%adjust font size
h.controls.slider_point_label.FontSize = control_font_size;

%% Indicate which filetypes have been located
h.controls.indicator.text_loaded = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','Loaded:',...
    'HorizontalAlignment','left',...
    'FontSize',control_font_size,...
    'Units','Normalized',...
    'Position',[.1 .25 .13 .1]);

h.controls.indicator.text_fname = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','file_name.rso',...
    'HorizontalAlignment','left',...
    'FontAngle','italic',...
    'FontWeight','bold',...
    'FontSize',control_font_size,...
    'ForegroundColor',[0 210 0]/255,...
    'Units','Normalized',...
    'Position',[.24 .25 .25 .1]);

h.controls.indicator.raw = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','.raw',...
    'HorizontalAlignment','left',...
    'FontSize',control_font_size,...
    'FontWeight','bold',...
    'ForegroundColor','r',...
    'Units','Normalized',...
    'Position',[.5 .25 .1 .1]);

h.controls.indicator.dat = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','.dat',...
    'HorizontalAlignment','left',...
    'FontSize',control_font_size,...
    'FontWeight','bold',...
    'ForegroundColor','r',...
    'Units','Normalized',...
    'Position',[.65 .25 .1 .1]);

h.controls.indicator.ndat = uicontrol(h.axes.controls,...
    'Style','text',...
    'String','.ndat',...
    'HorizontalAlignment','left',...
    'FontSize',control_font_size,...
    'FontWeight','bold',...
    'ForegroundColor','r',...
    'Units','Normalized',...
    'Position',[.8 .25 .1 .1]);

%% Create a warning dialog to indicate a bad file has been chosen
h.warning = uicontrol(h.fig,...
    'Style','text',...
    'String','Warning: Required file extensions not found (see list above file selection menu). Select new file to continue',...
    'HorizontalAlignment','center',...
    'ForegroundColor',[220 0 0]/255,...
    'FontSize',30,...
    'Units','Normalized',...
    'Position',[.25 .5 .5 .3]);
h.warning.Visible = 'off';

%% Attach Handle Information to Figures
h.fig.UserData = h;

end
