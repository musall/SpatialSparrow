function varargout = lightChecker(varargin)
% LIGHTCHECKER MATLAB code for lightChecker.fig
%      LIGHTCHECKER, by itself, creates a new LIGHTCHECKER or raises the existing
%      singleton*.
%
%      H = LIGHTCHECKER returns the handle to a new LIGHTCHECKER or the handle to
%      the existing singleton*.
%
%      LIGHTCHECKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIGHTCHECKER.M with the given input arguments.
%
%      LIGHTCHECKER('Property','Value',...) creates a new LIGHTCHECKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lightChecker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lightChecker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lightChecker

% Last Modified by GUIDE v2.5 21-Nov-2019 00:24:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lightChecker_OpeningFcn, ...
                   'gui_OutputFcn',  @lightChecker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before lightChecker is made visible.
function lightChecker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lightChecker (see VARARGIN)

% Choose default command line output for lightChecker
handles.output = hObject;
global BpodSystem

hold(handles.curveGraph, 'on');
if exist([BpodSystem.Path.SettingsDir filesep 'LEDconfig.mat'], 'file')
    load([BpodSystem.Path.SettingsDir filesep 'LEDconfig.mat'], 'LEDconfig');
else
    LEDconfig{1} = [1:5; zeros(1,5)];
    LEDconfig{2} = LEDconfig{1};
end

handles.LEDconfig = LEDconfig;
handles.leftLine = plot(handles.curveGraph, handles.LEDconfig{1}(1,:), handles.LEDconfig{1}(2,:), 'go-', 'linewidth', 4);
handles.rightLine = plot(handles.curveGraph, handles.LEDconfig{2}(1,:), handles.LEDconfig{2}(2,:), 'bo-', 'linewidth', 4);

% check for analog module by finding a serial device that can create a
% waveplayer object
Ports = FindSerialPorts; %get all serial ports
for i = 1 : length(Ports)
    try
        handles.WaveOut = BpodWavePlayer(Ports{i});
    end
end
handles.WaveOut.OutputRange = '-5V:5V'; % make sure output range is correct
handles.WaveOut.TriggerProfileEnable = 'Off';
handles.WaveOut.LoopDuration(7:8) = 600; %keep on for a up to 10 minutes
handles.WaveOut.SamplingRate = 100; %adjust sampling rate
handles.WaveOut.LoopMode(7:8) = {'On' 'On'};

xlabel(handles.curveGraph, 'measured light power (mW)'); ylabel(handles.curveGraph, 'control signal (V)')
xlim(handles.curveGraph, [min(handles.LEDconfig{1}(1,:))-0.5 max(handles.LEDconfig{1}(1,:))+0.5]);
legend({'left LED', 'right LED'}, 'location', 'northwest');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lightChecker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lightChecker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in saveConfig.
function saveConfig_Callback(hObject, eventdata, handles)
% hObject    handle to saveConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
LEDconfig = handles.LEDconfig;
save([BpodSystem.Path.SettingsDir filesep 'LEDconfig.mat'], 'LEDconfig');

% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject.Parent, eventdata, handles)

% --- Executes on button press in leftLED.
function leftLED_Callback(hObject, eventdata, handles)
% hObject    handle to leftLED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for iPowers = 1 : 5
    handles.WaveOut.loadWaveform(1, iPowers);
    handles.WaveOut.play(7, 1);
    
    handles.leftValues.Data{1,iPowers} = iPowers;
    handles.leftValues.Data{2,iPowers} = str2double(newid([int2str(iPowers) 'V: Enter measured light power']));
    while isnan(handles.leftValues.Data{2,iPowers})
        handles.leftValues.Data{2,iPowers} = str2double(newid([int2str(iPowers) 'V: Enter measured light power']));
    end
    
    handles.WaveOut.stop;
end
handles.leftLine.YData = cell2mat(handles.leftValues.Data(2,:));
handles.LEDconfig{1} = cell2mat(handles.leftValues.Data);
guidata(hObject, handles);


% --- Executes on button press in rightLED.
function rightLED_Callback(hObject, eventdata, handles)
% hObject    handle to rightLED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for iPowers = 1 : 5
    handles.WaveOut.loadWaveform(1, iPowers);
    handles.WaveOut.play(8, 1);
    
    handles.rightValues.Data{1,iPowers} = iPowers;
    handles.rightValues.Data{2,iPowers} = str2double(newid([int2str(iPowers) 'V: Enter measured light power']));
    while isnan(handles.rightValues.Data{2,iPowers})
        handles.rightValues.Data{2,iPowers} = str2double(newid([int2str(iPowers) 'V: Enter measured light power']));
    end
    
    handles.WaveOut.stop;
end
handles.rightLine.YData = cell2mat(handles.rightValues.Data(2,:));
handles.LEDconfig{2} = cell2mat(handles.rightValues.Data);
guidata(hObject, handles);




%% additional functions
function Ports = FindSerialPorts
% Search for connected serial devices and return as cell array
[~, RawString] = system('wmic path Win32_SerialPort Get DeviceID');
PortLocations = strfind(RawString, 'COM');
Ports = cell(1,100);
nPorts = length(PortLocations);
for x = 1:nPorts
    Clip = RawString(PortLocations(x):PortLocations(x)+6);
    Ports{x} = Clip(1:find(Clip == 32,1, 'first')-1);
end
Ports = Ports(1:nPorts);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear handles.WaveOut
delete(hObject);
