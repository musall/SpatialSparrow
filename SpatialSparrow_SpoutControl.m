function varargout = SpatialSparrow_SpoutControl(varargin)
% SPATIALSPARROW_SPOUTCONTROL MATLAB code for SpatialSparrow_SpoutControl.fig
%      SPATIALSPARROW_SPOUTCONTROL, by itself, creates a new SPATIALSPARROW_SPOUTCONTROL or raises the existing
%      singleton*.
%
%      H = SPATIALSPARROW_SPOUTCONTROL returns the handle to a new SPATIALSPARROW_SPOUTCONTROL or the handle to
%      the existing singleton*.
%
%      SPATIALSPARROW_SPOUTCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPATIALSPARROW_SPOUTCONTROL.M with the given input arguments.
%
%      SPATIALSPARROW_SPOUTCONTROL('Property','Value',...) creates a new SPATIALSPARROW_SPOUTCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpatialSparrow_SpoutControl_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpatialSparrow_SpoutControl_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpatialSparrow_SpoutControl

% Last Modified by GUIDE v2.5 06-Nov-2019 21:01:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpatialSparrow_SpoutControl_OpeningFcn, ...
                   'gui_OutputFcn',  @SpatialSparrow_SpoutControl_OutputFcn, ...
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


% --- Executes just before SpatialSparrow_SpoutControl is made visible.
function SpatialSparrow_SpoutControl_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpatialSparrow_SpoutControl (see VARARGIN)
% Choose default command line output for SpatialSparrow_SpoutControl
global BpodSystem
handles.output = hObject;
BpodSystem.GUIHandles.SpatialSparrow_SpoutControl = handles;
handles.lMaxSpoutIn.String = int2str(BpodSystem.ProtocolSettings.lMaxSpoutIn); % max. inner position for left spout
handles.rMaxSpoutIn.String = int2str(BpodSystem.ProtocolSettings.rMaxSpoutIn); % max. inner position for right spout
handles.SpoutSpeed.String = int2str(BpodSystem.ProtocolSettings.SpoutSpeed); %update spout speed
handles.LeverSpeed.String = int2str(BpodSystem.ProtocolSettings.LeverSpeed); %update lever speed
handles.LeverIn.String = int2str(BpodSystem.ProtocolSettings.LeverIn); %update inner lever position
handles.LeverOut.String = int2str(BpodSystem.ProtocolSettings.LeverOut); %update outer lever position
handles.TouchThresh.String = num2str(BpodSystem.ProtocolSettings.TouchThresh); %threshold for touch sensors
movegui(BpodSystem.GUIHandles.SpatialSparrow_SpoutControl.figure1,'northwest')

%set slider properties
handles.LeftSpout.Min = 0; 
handles.RightSpout.Min = 0;
handles.LeftSpout.Max = round(BpodSystem.ProtocolSettings.lMaxSpoutIn);
handles.RightSpout.Max = round(BpodSystem.ProtocolSettings.rMaxSpoutIn);
handles.LeftSpout.Value = round(BpodSystem.ProtocolSettings.lInnerLim);
handles.RightSpout.Value = round(BpodSystem.ProtocolSettings.rMaxSpoutIn - BpodSystem.ProtocolSettings.rInnerLim);
handles.LeftSpout.SliderStep = [1/(handles.LeftSpout.Max) , 1/(handles.LeftSpout.Max)*5]; %arrow click moves by 1, area click by 5
handles.RightSpout.SliderStep = [1/(handles.RightSpout.Max) , 1/(handles.RightSpout.Max)*5]; %arrow click moves by 1, area click by 5

set(handles.InnerLimits,'string',['Left : ' int2str(round(BpodSystem.ProtocolSettings.lInnerLim,2)) ' - Right : ' int2str(round(BpodSystem.ProtocolSettings.rInnerLim,2))]);
set(handles.OuterLimits,'string',['Left : ' int2str(round(BpodSystem.ProtocolSettings.lOuterLim,2)) ' - Right : ' int2str(round(BpodSystem.ProtocolSettings.rOuterLim,2))]);

%% reset spout spout position and speed based on current settings
% move spouts to inner position
leftSpout = int2str(BpodSystem.ProtocolSettings.lInnerLim); %left inner limit for spout
rightSpout = int2str(BpodSystem.ProtocolSettings.rInnerLim); %right inner limit for spout
teensyWrite([71 1 '0' 1 '0']); % move to zero position 
teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % inner spout position

%move handles to outer position
cVal = int2str(BpodSystem.ProtocolSettings.LeverOut); %outer lever position
teensyWrite([72 1 '0']); %move to zero position 
teensyWrite([72 length(cVal) cVal]); 

% send trial information to teensy - this is needed to compute the spout/leverspeed from outer to inner position
LeftIn = round(BpodSystem.ProtocolSettings.lInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(1); %left inner position + bias offset
RightIn = round(BpodSystem.ProtocolSettings.rInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(2); %right inner position + bias offset
LeftOut = LeftIn + BpodSystem.ProtocolSettings.spoutOffset; %left outer position
RightOut = RightIn + BpodSystem.ProtocolSettings.spoutOffset; %right outer position

% convert to strings and combine as teensy output
LeftIn = num2str(LeftIn); RightIn = num2str(RightIn);
LeftOut = num2str(LeftOut); RightOut = num2str(RightOut);
LeverIn = num2str(BpodSystem.ProtocolSettings.LeverIn);
LeverOut = num2str(BpodSystem.ProtocolSettings.LeverOut);

cVal = [length(LeftIn) length(RightIn) length(LeftOut) length(RightOut) length(LeverIn) length(LeverOut) ...
    LeftIn RightIn LeftOut RightOut LeverIn LeverOut];
teensyWrite([70 cVal]); % send spout/lever information to teensy at trial start
  
% set spoutspeed
cVal = int2str(BpodSystem.ProtocolSettings.SpoutSpeed);
teensyWrite([73 length(cVal) cVal]);

%set leverspeed
cVal = int2str(BpodSystem.ProtocolSettings.LeverSpeed);
teensyWrite([74 length(cVal) cVal]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SpatialSparrow_SpoutControl wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SpatialSparrow_SpoutControl_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function lMaxSpoutIn_Callback(hObject, eventdata, handles)
% hObject    handle to lMaxSpoutIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lMaxSpoutIn as text
%        str2double(get(hObject,'String')) returns contents of lMaxSpoutIn as a double
% ------------------------------------------------------------
% Remember that slider values for the left spout are inverted. If a value
% is set to the slider maximum, the resulting servo spoutposition is close to the center.
% ------------------------------------------------------------

global BpodSystem
LeftPos = round(str2double(get(hObject,'String'))); %new slider limit
if ~isnan(LeftPos)
    BpodSystem.ProtocolSettings.lMaxSpoutIn = LeftPos; %update Bpod object
    handles.LeftSpout.Max = LeftPos;
else
    disp([get(hObject,'String') ' is not a valid input for max. inner position of left spout.'])
    handles.LeftSpout.max = BpodSystem.ProtocolSettings.lMaxSpoutIn;
end
handles.LeftSpout.SliderStep = [1/(handles.LeftSpout.Max) , 1/(handles.LeftSpout.Max)*5]; %arrow click moves by 1, area click by 5

% --- Executes during object creation, after setting all properties.
function lMaxSpoutIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lMaxSpoutIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function rMaxSpoutIn_Callback(hObject, eventdata, handles)
% hObject    handle to rMaxSpoutIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rMaxSpoutIn as text
%        str2double(get(hObject,'String')) returns contents of rMaxSpoutIn as a double
global BpodSystem
RightPos = round(str2double(get(hObject,'String')));
RightVal = get(handles.RightSpout,'value'); %current slider value
RightMax = get(handles.RightSpout,'max'); %current slider limit

if ~isnan(RightPos)
    BpodSystem.ProtocolSettings.rMaxSpoutIn = RightPos; %update Bpod object
    handles.RightSpout.Value = RightPos-(RightMax-RightVal); %keep distance between current value and slider maximum constant
    handles.RightSpout.Max = RightPos;
else
    disp([get(hObject,'String') ' is not a valid input to move out the right spout.'])
    set(hObject,'String',int2str(BpodSystem.ProtocolSettings.rMaxSpoutIn)); % Servo position to move the right spout away from the animal
end
handles.RightSpout.SliderStep = [1/(handles.RightSpout.Max) , 1/(handles.RightSpout.Max)*5]; %arrow click moves by 1, area click by 5


% --- Executes during object creation, after setting all properties.
function rMaxSpoutIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rMaxSpoutIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MoveZero.
function MoveZero_Callback(hObject, eventdata, handles)
% hObject    handle to MoveZero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.LeftSpout,'value',0); %update slider
set(handles.RightSpout,'value',get(handles.RightSpout,'max'));  %update slider
teensyWrite([71 1 '0' 1 '0']); %move spouts to zero positions


% --- Executes on button press in ConfirmAdjustment.
function ConfirmAdjustment_Callback(hObject, eventdata, handles)
% hObject    handle to ConfirmAdjustment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
BpodSystem.ProtocolSettings.rMaxSpoutIn = str2double(get(handles.rMaxSpoutIn,'String')); %update settings in bpod
BpodSystem.ProtocolSettings.lMaxSpoutIn = str2double(get(handles.lMaxSpoutIn,'String')); %update settings in bpod
uiresume(handles.figure1); %resume main program after spouts have been adjusted


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in CloseFigure.
function CloseFigure_Callback(hObject, eventdata, handles)
% hObject    handle to CloseFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
delete(handles.figure1);


function SpoutSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to RightLickThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RightLickThresh as text
%        str2double(get(hObject,'String')) returns contents of RightLickThresh as a double


% --- Executes during object creation, after setting all properties.
function SpoutSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RightLickThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AdjustSpoutSpeed.
function AdjustSpoutSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustSpoutSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
LeftIn = round(BpodSystem.ProtocolSettings.lInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(1); %left inner position + bias offset
RightIn = round(BpodSystem.ProtocolSettings.rInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(2); %right inner position + bias offset
LeftOut = LeftIn + BpodSystem.ProtocolSettings.spoutOffset; %left outer position
RightOut = RightIn + BpodSystem.ProtocolSettings.spoutOffset; %right outer position

% convert to strings and combine as teensy output
LeftIn = num2str(LeftIn); RightIn = num2str(RightIn);
LeftOut = num2str(LeftOut); RightOut = num2str(RightOut);
LeverIn = num2str(BpodSystem.ProtocolSettings.LeverIn);
LeverOut = num2str(BpodSystem.ProtocolSettings.LeverOut);

% send trial information to teensy - this is needed to compute the
% leverspeed from outer to inner position
cVal = [length(LeftIn) length(RightIn) length(LeftOut) length(RightOut) length(LeverIn) length(LeverOut) ...
    LeftIn RightIn LeftOut RightOut LeverIn LeverOut];
teensyWrite([70 cVal]); % send spout/lever information to teensy at trial start
 
BpodSystem.ProtocolSettings.SpoutSpeed = str2num(handles.SpoutSpeed.String); %update SpoutSpeed
teensyWrite([73 length(handles.SpoutSpeed.String) handles.SpoutSpeed.String]); %set spout speed


% --- Executes on slider movement.
function LeftSpout_Callback(hObject, eventdata, handles)
% hObject    handle to LeftSpout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns spoutposition of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function LeftSpout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LeftSpout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function RightSpout_Callback(hObject, eventdata, handles)
% hObject    handle to RightSpout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns spoutposition of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function RightSpout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RightSpout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in SetInnerLimits.
function SetInnerLimits_Callback(hObject, eventdata, handles)
% hObject    handle to SetInnerLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
if get(hObject,'value')
    set(hObject,'string','Setting Limits')
else
    set(hObject,'string','Set Inner Limits')
end

while get(hObject,'value')
    drawnow;
    leftSpout = int2str(get(handles.LeftSpout,'Value')); %slider value
    rightMax = get(handles.RightSpout,'max'); %current slider limit
    rightSpout = int2str(rightMax-get(handles.RightSpout,'Value')); %slider value
    teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % move to new spout position
    set(handles.InnerLimits,'string',['Left : ' leftSpout ' - Right : ' rightSpout]);
    
    if ~get(hObject,'value')
        BpodSystem.ProtocolSettings.lInnerLim = str2double(leftSpout); %update Bpod object
        BpodSystem.ProtocolSettings.rInnerLim = str2double(rightSpout); %update Bpod object
    end
end


% --- Executes on button press in SetOuterLimits.
function SetOuterLimits_Callback(hObject, eventdata, handles)
% hObject    handle to SetOuterLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
if get(hObject,'value')
    set(hObject,'string','Setting Limits')
else
    set(hObject,'string','Set Outer Limits')
end

while get(hObject,'value')
    drawnow;
    leftSpout = int2str(get(handles.LeftSpout,'Value')); %slider value
    rightMax = get(handles.RightSpout,'max'); %current slider limit
    rightSpout = int2str(rightMax-get(handles.RightSpout,'Value')); %slider value
    teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % move to new spout position
    set(handles.OuterLimits,'string',['Left : ' leftSpout ' - Right : ' rightSpout]);

    if ~get(hObject,'value')
        BpodSystem.ProtocolSettings.lOuterLim = str2double(leftSpout); %update Bpod object
        BpodSystem.ProtocolSettings.rOuterLim = str2double(rightSpout); %update Bpod object
    end
end


function InnerLimits_Callback(hObject, eventdata, handles)
% hObject    handle to InnerLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InnerLimits as text
%        str2double(get(hObject,'String')) returns contents of InnerLimits as a double


% --- Executes during object creation, after setting all properties.
function InnerLimits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InnerLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OuterLimits_Callback(hObject, eventdata, handles)
% hObject    handle to OuterLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OuterLimits as text
%        str2double(get(hObject,'String')) returns contents of OuterLimits as a double


% --- Executes during object creation, after setting all properties.
function OuterLimits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OuterLimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MoveInnerLimit.
function MoveInnerLimit_Callback(hObject, eventdata, handles)
% hObject    handle to MoveInnerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
drawnow;
leftSpout = BpodSystem.ProtocolSettings.lInnerLim; %get left inner limit
rightSpout = BpodSystem.ProtocolSettings.rInnerLim; %get right inner limit
set(handles.LeftSpout,'value',leftSpout); %update slider
set(handles.RightSpout,'value',get(handles.RightSpout,'max')-rightSpout); %update slider
leftSpout = int2str(leftSpout);
rightSpout = int2str(rightSpout);
teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % move to new spout position


% --- Executes on button press in MoveToOuterLimit.
function MoveToOuterLimit_Callback(hObject, eventdata, handles)
% hObject    handle to MoveToOuterLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
drawnow;
leftSpout = BpodSystem.ProtocolSettings.lOuterLim; %update from Bpod object
rightSpout = BpodSystem.ProtocolSettings.rOuterLim; %update from Bpod object
set(handles.LeftSpout,'value',leftSpout); %update slider
set(handles.RightSpout,'value',get(handles.RightSpout,'max')-rightSpout); %update slider
leftSpout = int2str(leftSpout);
rightSpout = int2str(rightSpout);
teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % move to new spout position


function ChangeLeftPos_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeLeftPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChangeLeftPos as text
%        str2double(get(hObject,'String')) returns contents of ChangeLeftPos as a double

leftSpout = str2double(get(hObject,'String'));
if ~isnan(leftSpout)
    handles.LeftSpout.Value = leftSpout; %update slider
    rightSpout = int2str(handles.RightSpout.Max - handles.RightSpout.Value);  %convert current slider value
    rightSpout = int2str(rightSpout);
    teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % move to new spout position
else
    disp([get(hObject,'String') ' is not a valid input for left spout position.'])
end


% --- Executes during object creation, after setting all properties.
function ChangeLeftPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChangeLeftPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ChangeRightPos_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeRightPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChangeRightPos as text
%        str2double(get(hObject,'String')) returns contents of ChangeRightPos as a double

rightSpout = str2double(get(hObject,'String'));
if ~isnan(rightSpout)
    handles.RightSpout.Value = handles.RightSpout.Max - rightSpout; %update slider
    leftSpout = int2str(handles.LeftSpout.Value);  %current slider value
    rightSpout = int2str(rightSpout);
    teensyWrite([71 length(leftSpout) leftSpout length(rightSpout) rightSpout]); % move to new spout position
else
    disp([get(hObject,'String') ' is not a valid input for right spout position.'])
end

% --- Executes during object creation, after setting all properties.
function ChangeRightPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChangeRightPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in AdjustLeverSpeed.
function AdjustLeverSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustLeverSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
LeftIn = round(BpodSystem.ProtocolSettings.lInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(1); %left inner position + bias offset
RightIn = round(BpodSystem.ProtocolSettings.rInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(2); %right inner position + bias offset
LeftOut = LeftIn + BpodSystem.ProtocolSettings.spoutOffset; %left outer position
RightOut = RightIn + BpodSystem.ProtocolSettings.spoutOffset; %right outer position

% convert to strings and combine as teensy output
LeftIn = num2str(LeftIn); RightIn = num2str(RightIn);
LeftOut = num2str(LeftOut); RightOut = num2str(RightOut);
LeverIn = num2str(BpodSystem.ProtocolSettings.LeverIn);
LeverOut = num2str(BpodSystem.ProtocolSettings.LeverOut);

% send trial information to teensy - this is needed to compute the
% leverspeed from outer to inner position
cVal = [length(LeftIn) length(RightIn) length(LeftOut) length(RightOut) length(LeverIn) length(LeverOut) ...
    LeftIn RightIn LeftOut RightOut LeverIn LeverOut];
teensyWrite([70 uint8(cVal)]); % send spout/lever information to teensy at trial start
        
BpodSystem.ProtocolSettings.LeverSpeed = str2num(handles.LeverSpeed.String); %update LeverSpeed
teensyWrite([74 length(handles.LeverSpeed.String) handles.LeverSpeed.String]); %set lever speed


function LeverSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to LeverSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LeverSpeed as text
%        str2double(get(hObject,'String')) returns contents of LeverSpeed as a double
global BpodSystem
LeverSpeed = str2double(get(hObject,'String'));
if ~isnan(LeverSpeed) && LeverSpeed > 0
    BpodSystem.ProtocolSettings.LeverSpeed = LeverSpeed; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input for the lever speed. This value determines the time it takes the lever to move in and out in ms.'])
    set(hObject,'String',int2str(BpodSystem.ProtocolSettings.LeverSpeed)); % Lever speed
end


% --- Executes during object creation, after setting all properties.
function LeverSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LeverSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LeverIn_Callback(hObject, eventdata, handles)
% hObject    handle to LeverIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LeverIn as text
%        str2double(get(hObject,'String')) returns contents of LeverIn as a double
global BpodSystem
LeverPos = str2double(get(hObject,'String'));
if ~isnan(LeverPos) && LeverPos >= 0
    BpodSystem.ProtocolSettings.LeverIn = LeverPos; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input to move the lever in.'])
    set(hObject,'String',int2str(BpodSystem.ProtocolSettings.LeverIn)); % Lever position
end

% --- Executes during object creation, after setting all properties.
function LeverIn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LeverIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MoveLeverIn.
function MoveLeverIn_Callback(hObject, eventdata, handles)
% hObject    handle to MoveLeverIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
drawnow;
cVal = int2str(BpodSystem.ProtocolSettings.LeverIn); %update from Bpod object
teensyWrite([72 length(cVal) cVal]);


function LeverOut_Callback(hObject, eventdata, handles)
% hObject    handle to LeverOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LeverOut as text
%        str2double(get(hObject,'String')) returns contents of LeverOut as a double
global BpodSystem
LeverPos = str2double(get(hObject,'String'));
if ~isnan(LeverPos) && LeverPos >= 0 && LeverPos <= 100
    BpodSystem.ProtocolSettings.LeverOut = LeverPos; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input to move the lever out.'])
    set(hObject,'String',int2str(BpodSystem.ProtocolSettings.LeverOut)); % Lever position
end


% --- Executes during object creation, after setting all properties.
function LeverOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LeverOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MoveLeverOut.
function MoveLeverOut_Callback(hObject, eventdata, handles)
% hObject    handle to MoveLeverOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
drawnow;
cVal = int2str(BpodSystem.ProtocolSettings.LeverOut); %update from Bpod object
teensyWrite([72 length(cVal) cVal]);


% --- Executes on button press in AdjustTouchThresh.
function AdjustTouchThresh_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustTouchThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BpodSystem
drawnow;
cVal = num2str(BpodSystem.ProtocolSettings.TouchThresh);
teensyWrite([75 length(cVal) cVal]);


function TouchThresh_Callback(hObject, eventdata, handles)
% hObject    handle to TouchThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TouchThresh as text
%        str2double(get(hObject,'String')) returns contents of TouchThresh as a double
global BpodSystem
TouchThresh = str2double(get(hObject,'String'));
if ~isnan(TouchThresh) && TouchThresh > 0
    BpodSystem.ProtocolSettings.TouchThresh = TouchThresh; %update Bpod object
else
    disp([get(hObject,'String') ' is invalid for touch threshold. This determines the touch threshold in standard deviations.'])
    set(hObject,'String',int2str(BpodSystem.ProtocolSettings.TouchThresh)); % Lever speed
end

% --- Executes during object creation, after setting all properties.
function TouchThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TouchThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in increaseSpoutL.
function increaseSpoutL_Callback(hObject, eventdata, handles)
% hObject    handle to increaseSpoutL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(80); % move to zero position 


% --- Executes on button press in decreaseSpoutL.
function decreaseSpoutL_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseSpoutL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(81); % move to zero position 


% --- Executes on button press in increaseSpoutR.
function increaseSpoutR_Callback(hObject, eventdata, handles)
% hObject    handle to increaseSpoutR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(82); % move to zero position 


% --- Executes on button press in decreaseSpoutR.
function decreaseSpoutR_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseSpoutR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(83); % move to zero position 


% --- Executes on button press in increaseLeverL.
function increaseLeverL_Callback(hObject, eventdata, handles)
% hObject    handle to increaseLeverL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(84); % move to zero position 


% --- Executes on button press in decreaseLeverL.
function decreaseLeverL_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseLeverL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(85); % move to zero position 


% --- Executes on button press in increaseLeverR.
function increaseLeverR_Callback(hObject, eventdata, handles)
% hObject    handle to increaseLeverR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(86); % move to zero position 


% --- Executes on button press in decreaseLeverR.
function decreaseLeverR_Callback(hObject, eventdata, handles)
% hObject    handle to decreaseLeverR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teensyWrite(87); % move to zero position 
