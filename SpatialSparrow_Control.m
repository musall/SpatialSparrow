function varargout = SpatialSparrow_Control(varargin)
% SPATIALSPARROW_CONTROL MATLAB code for SpatialSparrow_Control.fig
%      SPATIALSPARROW_CONTROL, by itself, creates a new SPATIALSPARROW_CONTROL or raises the existing
%      singleton*.
%
%      H = SPATIALSPARROW_CONTROL returns the handle to a new SPATIALSPARROW_CONTROL or the handle to
%      the existing singleton*.
%
%      SPATIALSPARROW_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPATIALSPARROW_CONTROL.M with the given input arguments.
%
%      SPATIALSPARROW_CONTROL('Property','Value',...) creates a new SPATIALSPARROW_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpatialSparrow_Control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpatialSparrow_Control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpatialSparrow_Control

% Last Modified by GUIDE v2.5 02-Nov-2019 16:20:21
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpatialSparrow_Control_OpeningFcn, ...
                   'gui_OutputFcn',  @SpatialSparrow_Control_OutputFcn, ...
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

         
% --- Executes just before SpatialSparrow_Control is made visible.
function SpatialSparrow_Control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpatialSparrow_Control (see VARARGIN)
hObject.UserData.update = @(x) SpatialSparrow_Control_Update(hObject, [], x); %assign function handle to do updates without calling the whole figure (to keep it from stealing focus)
guidata(hObject, handles);


function SpatialSparrow_Control_Update(hObject, eventdata, varargin)
% Function to update SpatialSparrow_Control window
global BpodSystem
handles = guidata(hObject);

% Add some information to individual panels
% xlabel(handles.PerformancePlot,'Trial #');
% xlabel(handles.StimulusPlot,'Time(ms)');

% switch for updating plots
if ~isempty(varargin)  %if additional input was provided. The first input should be a state switch.
    switch lower(varargin{1}{1})  %state switch
        
        case 'init' %initialize plots
            BpodSystem.GUIHandles.SpatialSparrow_Control = handles;
            movegui(BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control,'northeast')
            Params = BpodSystem.ProtocolSettings;
            SideList = varargin{1}{2}; %sidelist for of future trials
            nTrialsToShow = 60; %default number of trials to display
            if ~isempty(varargin{1}{3}) %custom number of trials
                nTrialsToShow =varargin{1}{3};
            end
            BpodSystem.GUIData.nTrialsToShow = nTrialsToShow; %keep for update routine
            
            %% Outcome plot
            axes(handles.OutcomePlot);cla(handles.OutcomePlot);
            Xdata = 1:nTrialsToShow; Ydata = SideList(Xdata);
            BpodSystem.GUIHandles.FutureTrialLine = line(Xdata,Ydata,'LineStyle','none','Marker','o','MarkerEdge','b','MarkerFace','b', 'MarkerSize',6);
            BpodSystem.GUIHandles.CurrentTrialCircle = line(0,0, 'LineStyle','none','Marker','o','MarkerEdge','k','MarkerFace','w', 'MarkerSize',6);
            BpodSystem.GUIHandles.CurrentTrialCross = line(0,0, 'LineStyle','none','Marker','+','MarkerEdge','k','MarkerFace','w', 'MarkerSize',6);
            BpodSystem.GUIHandles.PunishedErrorLine = line(0,0, 'LineStyle','none','Marker','o','MarkerEdge','r','MarkerFace','r', 'MarkerSize',6);
            BpodSystem.GUIHandles.RewardedCorrectLine = line(0,0, 'LineStyle','none','Marker','o','MarkerEdge','g','MarkerFace','g', 'MarkerSize',6);
            BpodSystem.GUIHandles.AbortedLine = line(0,0, 'LineStyle','none','Marker','o','MarkerEdge',[1 .5 0],'MarkerFace',[1 .5 0], 'MarkerSize',6);
            BpodSystem.GUIHandles.NoResponseLine = line(0,0, 'LineStyle','none','Marker','o','MarkerEdge','b','MarkerFace','w', 'MarkerSize',6);
            BpodSystem.GUIHandles.NoLeverResponseLine = line(0,0, 'LineStyle','none','Marker','o','MarkerEdge','c','MarkerFace','w', 'MarkerSize',6);
            set(handles.OutcomePlot,'TickDir','out','YLim', [-1, 2], 'YTick', [0 1],'YTickLabel', {'Left','Right'},'xtick',[]);
            
            %% Other plots
            set(handles.PerformancePlot,'TickDir', 'in','YLim', [-0.1, 1.1], 'YTick',0:0.25:1);ylabel(handles.PerformancePlot,'Performance'); %rescale y-axis and label
            set(handles.PerformanceOverview,'TickDir', 'in','YLim', [-0.1, 1.1], 'YTick',0:0.25:1);ylabel(handles.PerformanceOverview,'Performance'); %rescale y-axis and label
            
            %% Set variables in main GUI
            hFields = fieldnames(handles); %fields in main GUI
            pFields = fieldnames(Params); %fields in params structure
            
            for iFields = 1:length(hFields) %go through control panel elements
                if strcmp(get(handles.(hFields{iFields}),'Type'),'uicontrol') %if a field is a user control
                    if strcmp(get(handles.(hFields{iFields}),'Style'),'edit') %if control is a textbox
                        handles.(hFields{iFields}).String = num2str(Params.(pFields{ismember(pFields,hFields(iFields))}));
                    elseif strcmp(get(handles.(hFields{iFields}),'Style'),'togglebutton') %if control is a binary input
                        handles.(hFields{iFields}).Value = Params.(pFields{ismember(pFields,hFields(iFields))});
                    elseif strcmp(get(handles.(hFields{iFields}),'Style'),'popupmenu') %if control is a popup menu
                        if ischar(handles.(hFields{iFields}).String)
                            handles.(hFields{iFields}).String = cellstr(handles.(hFields{iFields}).String);
                        end
                        for x = 1:length(handles.(hFields{iFields}).String)
                            if strcmpi(handles.(hFields{iFields}).String{x},Params.(pFields{ismember(pFields,hFields(iFields))}))
                                handles.(hFields{iFields}).Value = x;
                            end
                        end
                        clear x
                    end
                end
            end
            Params = rmfield(Params,pFields(ismember(pFields,hFields))); %remove values that are set in main GUI from Params so they won't be shown in ParamsGUI

            %% Value panels
            %don't set values that are set in the control GUI            
            ParamNames = fieldnames(Params);
            nValues = length(ParamNames);
            ParamValues = struct2cell(Params);
            
            wHeight = 500;
            wWidth = round(25+(240*(nValues/20)));
            BpodSystem.GUIHandles.ParamFig = figure('Position', [100 100 wWidth wHeight],'name','Live Params','numbertitle','off', 'MenuBar', 'none', 'Resize', 'on');
            uicontrol('Style', 'text', 'String', 'Parameter', 'Position', [10 wHeight-30 100 20], 'FontWeight', 'bold', 'FontSize', 11, 'FontName', 'Arial');
            uicontrol('Style', 'text', 'String', 'Value', 'Position', [120 wHeight-30 80 20], 'FontWeight', 'bold', 'FontSize', 11, 'FontName', 'Arial');
            BpodSystem.GUIHandles.ParameterGUI = struct;
            BpodSystem.GUIHandles.ParameterGUI.ParamNames = ParamNames;
            BpodSystem.GUIHandles.ParameterGUI.LastParamValues = ParamValues;
            nValues = length(BpodSystem.GUIHandles.ParameterGUI.LastParamValues);
            
            BpodSystem.GUIHandles.ParameterGUI.LabelsHandle = zeros(1,nValues);
            Pos = wHeight-60;
            Cnt = 0;
            for x = 1:nValues
                if rem(x,20) == 0
                    Cnt = Cnt + 1;
                    Pos = wHeight-60;
                    uicontrol('Style', 'text', 'String', 'Parameter', 'Position', [(Cnt*200) + 10 wHeight-30 100 20], 'FontWeight', 'bold', 'FontSize', 11, 'FontName', 'Arial');
                    uicontrol('Style', 'text', 'String', 'Value', 'Position', [(Cnt*200) + 120 wHeight-30 80 20], 'FontWeight', 'bold', 'FontSize', 11, 'FontName', 'Arial');
                end
                if ~isempty(str2num(num2str(ParamValues{x}))) % if is numeric
                    ParamValues{x} = double(ParamValues{x});
                    BpodSystem.GUIHandles.ParameterGUI.LastParamValues{x} = str2num(num2str(ParamValues{x}));
                end
                BpodSystem.GUIHandles.ParameterGUI.LabelsHandle(x) = uicontrol('Style', 'text', 'String', ParamNames{x}, 'Position', [(Cnt*200) + 10 Pos 100 18], 'FontWeight', 'normal', 'FontSize', 10, 'FontName', 'Arial');
                BpodSystem.GUIHandles.ParameterGUI.ParamValHandle(x) = uicontrol('Style', 'edit', 'String',num2str(ParamValues{x}(:)'), 'Position', [(Cnt*200) + 120 Pos 80 20], 'FontWeight', 'normal', 'FontSize', 9, 'FontName', 'Arial');
                Pos = Pos - 20;
            end
            
            % update trial display
            handles.cTrial.String = 'Trial: 1 / 1';
            
            % update session display
            [~,b] = fileparts(BpodSystem.Path.CurrentDataFile); %get sessionnr from bpod
            c = textscan(b,'%s','delimiter','_');
            currentSession = str2num(c{1}{end}(length('Session')+1:end));
            handles.StartTime.String = ['Session: ' num2str(currentSession)];
                
        case 'update' %update settings or plots
            if strcmpi(varargin{1}{2},'Settings') %if settings should be updated
                %% MainGUI
                Params = BpodSystem.ProtocolSettings; %current parameter structure
                hFields = fieldnames(handles);pFields = fieldnames(Params);
                for iFields = 1:length(hFields) %go through control panel elements
                    if strcmp(get(handles.(hFields{iFields}),'Type'),'uicontrol') %if a field is a user control
                        if strcmp(get(handles.(hFields{iFields}),'Style'),'edit') %if control is a textbox
                            if strcmp(hFields{iFields},'ServoPos')
                                ServoPos = get(handles.(hFields{iFields}),'String'); %set indicator for current servo position
                                ServoPos(strfind(ServoPos,'L'))=[];ServoPos(strfind(ServoPos,'R'))=[]; %remove non-nummeric part of the string but leave space in there
                                ServoPos(strfind(ServoPos,':'))=[];ServoPos(strfind(ServoPos,';'))=[]; %remove non-nummeric part of the string but leave space in there
                                Params.(pFields{ismember(pFields,hFields(iFields))}) = str2num(ServoPos); %convert to numbers
                            elseif isempty(str2num(handles.(hFields{iFields}).String))
                                Params.(pFields{ismember(pFields,hFields(iFields))}) = handles.(hFields{iFields}).String; %change value in S, based on user input
                            else
                                Params.(pFields{ismember(pFields,hFields(iFields))}) = str2num(handles.(hFields{iFields}).String); %change value in S, based on user input
                            end
                        elseif strcmp(get(handles.(hFields{iFields}),'Style'),'togglebutton') %if control is a binary input
                            Params.(pFields{ismember(pFields,hFields(iFields))}) = handles.(hFields{iFields}).Value; %change value in S, based on user input
                        elseif strcmp(get(handles.(hFields{iFields}),'Style'),'popupmenu') %if control is a popup menu
                            Params.(pFields{ismember(pFields,hFields(iFields))}) = handles.(hFields{iFields}).String{handles.(hFields{iFields}).Value}; %change value in S, based on user input
                        end
                    end
                end
                
                %% ParamGUI
                nValues = length(BpodSystem.GUIHandles.ParameterGUI.LastParamValues); %check for last set param values
                for x = 1:nValues
                    
                    thisParamGUIValue = get(BpodSystem.GUIHandles.ParameterGUI.ParamValHandle(x), 'String'); %get current GUI fields content
                    thisParamLastValue = BpodSystem.GUIHandles.ParameterGUI.LastParamValues{x}; %get last set value
                    thisParamInputValue = Params.(BpodSystem.GUIHandles.ParameterGUI.ParamNames{x}); %current value in parameter structure
                    
                    if ~strcmp(thisParamGUIValue, num2str(thisParamLastValue)) % If the user changed the GUI input parameter
                        param_is_numeric = ~isempty(str2num(num2str(thisParamGUIValue)));
                        if param_is_numeric
                            Params.(BpodSystem.GUIHandles.ParameterGUI.ParamNames{x}) = str2num(num2str(thisParamGUIValue));
                            BpodSystem.GUIHandles.ParameterGUI.LastParamValues{x} = str2num(num2str(thisParamGUIValue));
                        else
                            Params.(BpodSystem.GUIHandles.ParameterGUI.ParamNames{x}) = thisParamGUIValue;
                            BpodSystem.GUIHandles.ParameterGUI.LastParamValues{x} = thisParamGUIValue;
                        end
                    else
                        if ~isempty(str2num(num2str(thisParamInputValue))) % if is numeric
                            BpodSystem.GUIHandles.ParameterGUI.LastParamValues{x} = str2num(num2str(thisParamInputValue));
                        else
                            BpodSystem.GUIHandles.ParameterGUI.LastParamValues{x} = thisParamInputValue;
                        end
                        set(BpodSystem.GUIHandles.ParameterGUI.ParamValHandle(x), 'String', num2str(thisParamInputValue));
                    end
                    
                end
                BpodSystem.ProtocolSettings = Params;
                
            else % if plots should be updated
                SideList = varargin{1}{3}; % set basic parameters
                OutcomeRecord = varargin{1}{4}; % trial performance
                UseTrials = varargin{1}{5}; % Only self-performed trials should be used.
                dispMode = get(BpodSystem.GUIHandles.SpatialSparrow_Control.PerformanceSwitch,'value'); %current mode to compute performance
                if dispMode == 1
                    UseTrials = true(1,length(UseTrials)); %Use all trials, regardles whether they were aided or not
                elseif ismember(dispMode,3:5)
                    DistFraqt = BpodSystem.Data.DistStim./BpodSystem.Data.TargStim; %Distractor/Target fraction
                    DistFraqt(length(UseTrials)) = 0; %make same length as useTrials
                    UseTrials = UseTrials .* DistFraqt ~=0; %%use all performed discrimination trials
                    
                    if dispMode == 4
                        UseTrials = UseTrials & DistFraqt < 0.5; %use all performed trials with distractor fraction below 0.5 (easy discrimination)
                    elseif dispMode == 5
                        UseTrials = UseTrials & DistFraqt >= 0.5; %use all performed trials with distractor fraction equal or above 0.5 (hard discrimination)
                    end
                end
                
                CurrentTrial = BpodSystem.Data.nTrials+1;
                nTrialsToShow = BpodSystem.GUIData.nTrialsToShow;
                
                % update time display
                handles.runTime.String = ['Elapsed time: ' num2str(round(BpodSystem.Data.TrialStartTime(BpodSystem.Data.nTrials)/60, 2)) ' min']; %elapsed time since the first trial in hours
                
                % update trial display - show #performed trials / # all trials
                handles.cTrial.String = ['Trial: ' num2str(sum(~(BpodSystem.Data.DidNotLever | BpodSystem.Data.DidNotChoose))) ' / ' num2str(BpodSystem.Data.nTrials+1)];
                
                % check trialcounts by modality
                for x  = 1:3
                    if x == 1
                        allTrials = ismember(BpodSystem.Data.StimType,[1 3 5 7]); %vision
                        cMod = 'Vision';
                    elseif x == 2
                        allTrials = ismember(BpodSystem.Data.StimType,[2 3 6 7]); %audio
                        cMod = 'Audio';
                    elseif x == 3
                        allTrials = ismember(BpodSystem.Data.StimType,[4:7]); %tactile
                        cMod = 'Tactile';
                    end
                    
                    perfTrials = allTrials & (BpodSystem.Data.Rewarded | BpodSystem.Data.Punished);
                    cCnt(1) = sum(BpodSystem.Data.DistStim(perfTrials) == 0); %detection
                    cCnt(2) = sum(BpodSystem.Data.DistStim(perfTrials) > 0); %discrimination
                    handles.trialCounter.String{x} = [cMod ' : ' num2str(cCnt(1)) '/' num2str(cCnt(2)) ' (' num2str(sum(allTrials)) ') trials'];
                end
                
                cCnt(1) = sum(BpodSystem.Data.optoType == 1);
                cCnt(2) = sum(BpodSystem.Data.optoType == 2);
                handles.trialCounter.String{4} = ['Optogenetics : ' num2str(cCnt(1)) '/' num2str(cCnt(2)) ' trials'];
                
                % update session display
                [~,b] = fileparts(BpodSystem.Path.CurrentDataFile); %get sessionnr from bpod
                c = textscan(b,'%s','delimiter','_');
                handles.StartTime.String = datestr(datenum(c{1}{4},'HHMMSS'),'HH:MM:SS'); %show start time
                   
                switch lower(varargin{1}{2})
                    %% Outcome plot
                    case 'outcome'
                        AxesHandle = handles.OutcomePlot;
                        if CurrentTrial<1
                            CurrentTrial = 1;
                        end
                        
                        % recompute xlim
                        [mn, mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow);
                        FutureTrialsIndx = CurrentTrial:mx;
                        Xdata = FutureTrialsIndx; Ydata = SideList(Xdata);
                        set(BpodSystem.GUIHandles.FutureTrialLine, 'xdata', [Xdata,Xdata], 'ydata', [Ydata,Ydata]);
                        
                        %Plot current trial
                        set(BpodSystem.GUIHandles.CurrentTrialCircle, 'xdata', CurrentTrial, 'ydata', SideList(CurrentTrial));
                        set(BpodSystem.GUIHandles.CurrentTrialCross, 'xdata', CurrentTrial, 'ydata', SideList(CurrentTrial));
                        
                        %Plot past trials
                        if ~isempty(OutcomeRecord)
                            indxToPlot = mn:CurrentTrial-1;
                            %Plot Error, punished
                            InCorrectTrialsIndx = (OutcomeRecord(indxToPlot) == 0);
                            Xdata = indxToPlot(InCorrectTrialsIndx); Ydata = SideList(Xdata);
                            set(BpodSystem.GUIHandles.PunishedErrorLine, 'xdata', [Xdata,Xdata], 'ydata', [Ydata,Ydata]);
                            %Plot Correct, rewarded
                            CorrectTrialsIndx = (OutcomeRecord(indxToPlot) == 1);
                            Xdata = indxToPlot(CorrectTrialsIndx); Ydata = SideList(Xdata);
                            set(BpodSystem.GUIHandles.RewardedCorrectLine, 'xdata', [Xdata,Xdata], 'ydata', [Ydata,Ydata]);
                            %Plot DidNotChoose
                            DidNotChooseTrialsIndx = (OutcomeRecord(indxToPlot) == 3);
                            Xdata = indxToPlot(DidNotChooseTrialsIndx); Ydata = SideList(Xdata);
                            set(BpodSystem.GUIHandles.NoResponseLine, 'xdata', [Xdata,Xdata], 'ydata', [Ydata,Ydata]);
                            %Plot DidNotLever
                            DidNotLeverTrialsIndx = (OutcomeRecord(indxToPlot) == 4);
                            Xdata = indxToPlot(DidNotLeverTrialsIndx); Ydata = SideList(Xdata);
                            set(BpodSystem.GUIHandles.NoLeverResponseLine, 'xdata', [Xdata,Xdata], 'ydata', [Ydata,Ydata]);
                            %Plot DidNotLever
                            AbortedTrialsIndx = (OutcomeRecord(indxToPlot) == 5);
                            Xdata = indxToPlot(AbortedTrialsIndx); Ydata = SideList(Xdata);
                            set(BpodSystem.GUIHandles.AbortedLine, 'xdata', [Xdata,Xdata], 'ydata', [Ydata,Ydata]);
                        end
                        
                    %% Performance plot
                    case 'performance'
                        AxesHandle = handles.PerformancePlot;cla(AxesHandle);
                        [mn,mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow);hold(AxesHandle, 'on');%rescale x-axis and hold
                        set(AxesHandle,'TickDir', 'in','YLim', [-0.1, 1.1], 'YTick', 0:0.25:1);ylabel(AxesHandle,'Performance'); %rescale y-axis and label
                        AvgWindow = 10; %number of trials to be used when averaging performance
                        
                        %compute performance values
                        iAll = (OutcomeRecord == 0 | OutcomeRecord == 1) & UseTrials; %for performance, only use completed (valid) trials that were achieved without auto reward or servo aid
                        iLeft = SideList == 0 & iAll; %only use performed trials to the left
                        iRight = SideList == 1 & iAll; %only use performed trials to the right
                        
                        PerformanceVec = cumsum(OutcomeRecord == 1 & UseTrials)./cumsum(iAll); %compute performance vector
                        if sum(iAll)<=AvgWindow*2
                            sPerformanceVec = PerformanceVec;
                        else %get performance for the last AvgWindow trials
                            sPerformanceVec = BpodSystem.Data.Performance;
                            temp = find(iAll); iAll = false(1,length(iAll)); iAll(temp(end-(AvgWindow*2)+1:end)) = true; clear temp %only use the last AvgWindow trials
                            sPerformanceVec(CurrentTrial-1) = sum(OutcomeRecord(iAll))/(AvgWindow*2); % add performance in current trial
                        end
                        BpodSystem.Data.Performance = sPerformanceVec; %update Bpod data with overall performance
 
                        if sum(iLeft) <= AvgWindow %if more than AvgWindow trials on the left were performed
                            temp = OutcomeRecord;temp(~iLeft) = 0;
                            lPerformanceVec = cumsum(temp)./cumsum(iLeft); %compute performance vector
                            clear temp
                        else
                            lPerformanceVec = BpodSystem.Data.lPerformance;
                            temp = find(iLeft); iLeft = false(1,length(iLeft)); iLeft(temp(end-AvgWindow+1:end)) = true; clear temp %only use the last AvgWindow trials
                            lPerformanceVec(CurrentTrial-1) = sum(OutcomeRecord(iLeft))/AvgWindow; % add performance in current trial
                        end
                        BpodSystem.Data.lPerformance = lPerformanceVec; %update Bpod data with left performance

                        if sum(iRight) <= AvgWindow %if more than AvgWindow trials on the right were performed
                            temp = OutcomeRecord;temp(~iRight) = 0;
                            rPerformanceVec = cumsum(temp)./cumsum(iRight); %compute performance vector
                            clear temp
                        else
                            rPerformanceVec = BpodSystem.Data.rPerformance;
                            temp = find(iRight); iRight = false(1,length(iRight)); iRight(temp(end-AvgWindow+1:end)) = true; clear temp %only use the last AvgWindow trials
                            rPerformanceVec(CurrentTrial-1) = sum(OutcomeRecord(iRight))/AvgWindow; % add performance in current trial
                        end
                        BpodSystem.Data.rPerformance = rPerformanceVec; %update Bpod data with right performance

                        % do plots
                        plot(AxesHandle,mn-1:mx+1,0.5*ones(size(mn-1:mx+1)),'k--'); %plot midline
                        h1 = plot(AxesHandle,PerformanceVec(1:CurrentTrial-1),'-o','MarkerFaceColor',[0.5 0.5 0.5],'Color',[0.5 0.5 0.5],'MarkerSize',5); %plot performance
                        h2 = plot(AxesHandle,BpodSystem.Data.Performance(1:CurrentTrial-1),':x','MarkerFaceColor','k','Color','k','MarkerSize',5); %plot performance
                        h3 = plot(AxesHandle,BpodSystem.Data.lPerformance(1:CurrentTrial-1),':x','MarkerFaceColor','g','Color','g','MarkerSize',5); %plot performance
                        h4 = plot(AxesHandle,BpodSystem.Data.rPerformance(1:CurrentTrial-1),':x','MarkerFaceColor','r','Color','r','MarkerSize',5); %plot performance
                        legend(AxesHandle,[h1 h2 h3 h4],{'All(GrandAvg)','All','Left','Right'},'Location','east','Orientation','vertical') %add legend
                        xlabel(AxesHandle,'# Trials')
                        hold(AxesHandle, 'off');
                        
                    case 'modality'
                        DoFit_Callback(hObject, [], handles);
                        
                end
            end
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SpatialSparrow_Control wait for user response (see UIRESUME)
% uiwait(handles.SpatialSparrow_Control);


% --- Outputs from this function are returned to the command line.

function varargout = SpatialSparrow_Control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Output all handles to capute manual changes made by the user
varargout{1} = handles;


% --- Executes on button press in AutoReward.
function AutoReward_Callback(hObject, eventdata, handles)
% hObject    handle to AutoReward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of AutoReward
if get(hObject, 'Value')
    disp('AutoReward is ON')
    BpodSystem.ProtocolSettings.AutoReward = true;
else
    disp('AutoReward is OFF')
    BpodSystem.ProtocolSettings.AutoReward = false;
end

% --- Executes on button press in UseAntiBias.
function UseAntiBias_Callback(hObject, eventdata, handles)
% hObject    handle to UseAntiBias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(hObject, 'String');
if isempty(str2num(S))
    disp([S ' is not a valid input. Please enter a single number between 0 and 1 for anti-bias strength.'])
    set(hObject, 'String', '0'); %set anti-bias to 0
end
if str2num(S) < 0
    set(hObject, 'String', '0'); %set anti-bias to 0
elseif str2num(S) > 1
    set(hObject, 'String', '1'); %set anti-bias to 1
end
S = get(hObject, 'String');
disp(['Anti bias strength set to ' S])

% Hint: get(hObject,'Value') returns toggle state of UseAntiBias


% --- Executes on selection change in RewardedModality.
function RewardedModality_Callback(hObject, eventdata, handles)
% hObject    handle to RewardedModality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(hObject, 'string');
disp(['Rewarded modality set to ' S{handles.RewardedModality.Value}]);

% Hints: contents = cellstr(get(hObject,'String')) returns RewardedModality contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RewardedModality


% --- Executes during object creation, after setting all properties.
function RewardedModality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RewardedModality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function leftRewardVolume_Callback(hObject, eventdata, handles)
% hObject    handle to leftRewardVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for left reward volume.'])
    set(hObject, 'String', '4'); %reset to default if input is invalid
else
    disp(['Left reward volume changed to ' num2str(S) ' ul'])
end


% --- Executes during object creation, after setting all properties.
function leftRewardVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftRewardVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rightRewardVolume_Callback(hObject, eventdata, handles)
% hObject    handle to rightRewardVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for right reward volume.'])
    set(hObject, 'String', '4'); %reset to default is unput is invalid
else
    disp(['Right reward volume changed to ' num2str(S) ' ul'])
end


% --- Executes during object creation, after setting all properties.
function rightRewardVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightRewardVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MasterIntervals_Callback(hObject, eventdata, handles)
% hObject    handle to MasterIntervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for the master ISI.'])
    set(hObject, 'String', '200'); %reset to default is unput is invalid
else
    temp = [];
    for x = 1:length(S)
        temp = [temp num2str(S(x)) '/'];
    end
    temp(end) = [];
    disp(['Master ISI changed to ' temp ' ms'])       
end
% Hints: get(hObject,'String') returns contents of MasterIntervals as text
%        str2double(get(hObject,'String')) returns contents of MasterIntervals as a double


% --- Executes during object creation, after setting all properties.
function MasterIntervals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MasterIntervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MM_Intervals_Callback(hObject, eventdata, handles)
% hObject    handle to MM_Intervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for the mutimodal ISI.'])
    set(hObject, 'String', '200'); %reset to default is unput is invalid
else
    temp = [];
    for x = 1:length(S)
        temp = [temp num2str(S(x)) '/'];
    end
    temp(end) = [];
    disp(['Multimodal ISI changed to ' temp ' ms'])       
end
% Hints: get(hObject,'String') returns contents of MM_Intervals as text
%        str2double(get(hObject,'String')) returns contents of MM_Intervals as a double


% --- Executes during object creation, after setting all properties.
function MM_Intervals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MM_Intervals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function preStimDelay_Callback(hObject, eventdata, handles)
% hObject    handle to preStimDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for the preStim delay.'])
    set(hObject, 'String', '2'); %reset to default is unput is invalid
else
    disp(['preStim delay changed to ' num2str(S) ' seconds'])
end
% Hints: get(hObject,'String') returns contents of preStimDelay as text
%        str2double(get(hObject,'String')) returns contents of preStimDelay as a double


% --- Executes during object creation, after setting all properties.
function preStimDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preStimDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WaitingTime_Callback(hObject, eventdata, handles)
% hObject    handle to WaitingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for the waiting time during stimulus presentation.'])
    set(hObject, 'String', '0.6'); %reset to default is unput is invalid
else
    disp(['Stimulus waiting time changed to ' num2str(S) ' seconds'])
end
% Hints: get(hObject,'String') returns contents of WaitingTime as text
%        str2double(get(hObject,'String')) returns contents of WaitingTime as a double


% --- Executes during object creation, after setting all properties.
function WaitingTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WaitingTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minITI_Callback(hObject, eventdata, handles)
% hObject    handle to minITI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S)
    disp([get(hObject, 'String') ' is not a valid input. Please enter a single number for the minimum inter-trial interval.'])
    set(hObject, 'String', '0.5'); %reset to default is unput is invalid
else
    disp(['Minimum ITI changed to ' num2str(S) ' seconds'])
end
% Hints: get(hObject,'String') returns contents of minITI as text
%        str2double(get(hObject,'String')) returns contents of minITI as a double


% --- Executes during object creation, after setting all properties.
function minITI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minITI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ProbRight_Callback(hObject, eventdata, handles)
% hObject    handle to ProbRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S) || S > 1 || S < 0
    disp([get(hObject, 'String') ' is not a valid input, greater than 1 or below 0. Please enter a single number for the single stimulus presentation probability.'])
    set(hObject, 'String', '0.5'); %reset to default is unput is invalid
else
    disp(['Single stimulus probability changed to ' num2str(S)])
end
% Hints: get(hObject,'String') returns contents of ProbRight as text
%        str2double(get(hObject,'String')) returns contents of ProbRight as a double


% --- Executes during object creation, after setting all properties.
function ProbRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProbRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DistFractions_Callback(hObject, eventdata, handles)
% hObject    handle to DistFractions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S) ||  any(S < 0)
    disp([get(hObject, 'String') ' is not a valid input or below 0. Please enter a single number or vector for the amount of distractor pulses.'])
    set(hObject, 'String', '0.25'); %reset to default is unput is invalid
else
    disp(['Distractor pulses: ' num2str(S)])
end
% Hints: get(hObject,'String') returns contents of DistFractions as text
%        str2double(get(hObject,'String')) returns contents of DistFractions as a double


% --- Executes during object creation, after setting all properties.
function DistFractions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DistFractions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function [mn,mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow)
FractionWindowStickpoint = .75; % After this fraction of visible trials, the trial position in the window "sticks" and the window begins to slide through trials.
mn = max(round(CurrentTrial - FractionWindowStickpoint*nTrialsToShow),1);
mx = mn + nTrialsToShow - 1;
set(AxesHandle,'XLim',[mn-1 mx+1]);


% --- Executes on button press in TrainingMode.
function TrainingMode_Callback(hObject, eventdata, handles)
% hObject    handle to TrainingMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'Value')
    disp('Training mode is ON')
else
    disp('Training mode is OFF')
end
% Hint: get(hObject,'Value') returns toggle state of TrainingMode


% --- Executes on selection change in FlashMode.
function FlashMode_Callback(hObject, eventdata, handles)
% hObject    handle to FlashMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(hObject, 'string');
disp(['Intensity mode set to ' S{hObject.Value}]);

% Hints: contents = cellstr(get(hObject,'String')) returns FlashMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FlashMode


% --- Executes during object creation, after setting all properties.
function FlashMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FlashMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TargRate_Callback(hObject, eventdata, handles)
% hObject    handle to TargRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S) ||  any(S < 0)
    disp([get(hObject, 'String') ' is not a valid input or below 0. Please enter a single number or vector for the amount of target pulses.'])
    set(hObject, 'String', '0.25'); %reset to default is unput is invalid
else
    disp(['Target pulses: ' num2str(S)])
end
% Hints: get(hObject,'String') returns contents of TargRate as text
%        str2double(get(hObject,'String')) returns contents of TargRate as a double


% --- Executes during object creation, after setting all properties.
function TargRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TargRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveSettings.
function SaveSettings_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Save current settings to file')
% Hint: get(hObject,'Value') returns toggle state of SaveSettings


% --- Executes on button press in AdjustSpoutes.
function AdjustSpoutes_Callback(hObject, eventdata, handles)
% hObject    handle to AdjustSpoutes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AdjustSpoutes



function ServoPos_Callback(hObject, eventdata, handles)
% hObject    handle to ServoPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ServoPos as text
%        str2double(get(hObject,'String')) returns contents of ServoPos as a double
global BpodSystem
ServoPos = get(hObject,'String'); %set indicator for current servo position
ServoPos(strfind(ServoPos,'L'))=[];ServoPos(strfind(ServoPos,'R'))=[]; %remove non-nummeric part of the string but leave space in there
ServoPos(strfind(ServoPos,':'))=[];ServoPos(strfind(ServoPos,';'))=[]; %remove non-nummeric part of the string but leave space in there
ServoPos = str2num(ServoPos); %convert to numbers
ServoPos(ServoPos<0) = 0; %make sure there are no negative values

if length(ServoPos) ~= 2
    set(hObject,'String',['L:' num2str(BpodSystem.ProtocolSettings.ServoPos(1)) '; R:' num2str(BpodSystem.ProtocolSettings.ServoPos(2))]); %set indicator for current servo position
    disp('False input to bias correction')
else
    ServoPos(ServoPos<0) = 0; %make sure there are no negative values
    set(hObject,'String',['L:' num2str(ServoPos(1)) '; R:' num2str(ServoPos(2))]); %set indicator for current servo position
    BpodSystem.ProtocolSettings.ServoPos = ServoPos;
end     
    
% --- Executes during object creation, after setting all properties.
function ServoPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ServoPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MasterISIrange_Callback(hObject, eventdata, handles)
% hObject    handle to MasterISIrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MasterISIrange as text
%        str2double(get(hObject,'String')) returns contents of MasterISIrange as a double


% --- Executes during object creation, after setting all properties.
function MasterISIrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MasterISIrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PerformanceSwitch.
function PerformanceSwitch_Callback(hObject, eventdata, handles)
% hObject    handle to PerformanceSwitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function autoRewardMixed_Callback(hObject, eventdata, handles)
% hObject    handle to autoRewardMixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of autoRewardMixed as text
%        str2double(get(hObject,'String')) returns contents of autoRewardMixed as a double

global BpodSystem
cVal = str2num(get(hObject,'String'));
if cVal < 0 %Self-performed should not be lower as 0
    cVal = 0;
    set(hObject,'string','0')
elseif cVal > 1 %Self-performed should not be higher as 1
    cVal = 1;
    set(hObject,'string','1')
end

if ~isnan(cVal)
    BpodSystem.ProtocolSettings.autoRewardMixed = cVal; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input to change the training status.'])
    set(hObject,'string',num2str(BpodSystem.ProtocolSettings.autoRewardMixed))
end


% --- Executes during object creation, after setting all properties.
function autoRewardMixed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to autoRewardMixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DistProb_Callback(hObject, eventdata, handles)
% hObject    handle to DistProb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S) || S > 1 || S < 0
    disp([get(hObject, 'String') ' is not a valid input, greater than 1 or below 0. Please enter a single number for the probability of presenting a distractor stimulus.'])
    set(hObject, 'String', '0'); %reset to default is unput is invalid
else
    disp(['Distractor presentation probability changed to ' num2str(S)])
end

% Hints: get(hObject,'String') returns contents of DistProb as text
%        str2double(get(hObject,'String')) returns contents of DistProb as a double


% --- Executes during object creation, after setting all properties.
function DistProb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DistProb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UseButtons_Callback(hObject, eventdata, handles)
% hObject    handle to UseButtons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UseButtons as text
%        str2double(get(hObject,'String')) returns contents of UseButtons as a double


% --- Executes during object creation, after setting all properties.
function UseButtons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UseButtons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StimDuration_Callback(hObject, eventdata, handles)
% hObject    handle to StimDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = str2num(get(hObject, 'String'));
if isempty(S) ||  any(S < 0)
    disp([get(hObject, 'String') ' is not a valid input or below 0. Please enter a single number for the stimulus duration.'])
    set(hObject, 'String', '0.25'); %reset to default is unput is invalid
else
    disp(['Stimulus duration: ' num2str(S)])
end
% Hints: get(hObject,'String') returns contents of StimDuration as text
%        str2double(get(hObject,'String')) returns contents of StimDuration as a double


% --- Executes during object creation, after setting all properties.
function StimDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StimDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ProbAudio_Callback(hObject, eventdata, handles)
% hObject    handle to Tag_ProbAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tag_ProbAudio as text
%        str2double(get(hObject,'String')) returns contents of Tag_ProbAudio as a double
ProbAudio = str2num(get(handles.ProbAudio,'string'));
if isnan(ProbAudio) || ProbAudio < 0
     disp([get(handles.ProbAudio,'string') ' is an invalid input for audio probability. Set to 0 instead.'])
     set(handles.ProbAudio,'string','0');
     ProbAudio = 0;
end

ProbVision = str2num(get(handles.ProbVision,'string'));
ProbPiezo = str2num(get(handles.ProbPiezo,'string'));
if (ProbAudio + ProbVision + ProbPiezo) > 1
    set(handles.ProbAudio,'string',num2str(1 - (ProbVision + ProbPiezo))); %set prob audio as high as possible without the combined probability going beyond 1.
    disp([get(handles.ProbAudio,'string') ' is higher as possible when combined with pVision/pPiezo. Set to ' num2str(ProbAudio) ' instead.'])
end

% --- Executes during object creation, after setting all properties.
function ProbAudio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProbAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Tag_ProbAudio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tag_ProbAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ProbVision_Callback(hObject, eventdata, handles)
% hObject    handle to Tag_ProbVision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tag_ProbVision as text
%        str2double(get(hObject,'String')) returns contents of Tag_ProbVision as a double

ProbVision = str2num(get(handles.ProbVision,'string'));
if isnan(ProbVision) || ProbVision < 0
     disp([get(handles.ProbVision,'string') ' is an invalid input for vision probability. Set to 0 instead.'])
     set(handles.ProbVision,'string','0');
     ProbVision = 0;
end

ProbAudio = str2num(get(handles.ProbAudio,'string'));
ProbPiezo = str2num(get(handles.ProbPiezo,'string'));
if (ProbAudio + ProbVision + ProbPiezo) > 1
    set(handles.ProbVision,'string',num2str(1 - (ProbAudio + ProbPiezo))); %set prob vision as high as possible without the combined probability going beyond 1.
    disp([get(handles.ProbVision,'string') ' is higher as possible when combined with pAudio/pPiezo. Set to ' num2str(ProbVision) ' instead.'])
end


% --- Executes during object creation, after setting all properties.
function ProbVision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProbVision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Tag_ProbVision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tag_ProbVision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function SpatialSparrow_Control_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpatialSparrow_Control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in modSelect.
function modSelect_Callback(hObject, eventdata, handles)
% hObject    handle to modSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modSelect

DoFit_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function modSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DoFit.
function DoFit_Callback(hObject, eventdata, handles)
% hObject    handle to DoFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DoFit
global BpodSystem

if isfield(BpodSystem.Data,'Rewarded')
    
AxesHandle = handles.PerformanceOverview;
cla(AxesHandle);hold(AxesHandle,'on');
distFractions = BpodSystem.Data.DistStim ./ BpodSystem.Data.TargStim;
discPerf = [];
UseTrials = BpodSystem.Data.Assisted;

if handles.modSelect.Value == 3
    if length(unique(BpodSystem.Data.decisionGap)) == 1
        distStim = 0;
    else
        if length(unique(BpodSystem.Data.decisionGap)) <= 10
            distStim = unique(BpodSystem.Data.decisionGap(BpodSystem.Data.decisionGap > 0));
        else
            [~,distStim] = histcounts((BpodSystem.Data.decisionGap(BpodSystem.Data.decisionGap > 0)),5);
            distStim(end) = [];
        end
    end
else
    distStim = unique(distFractions);
end

for iDist = 1:length(distStim)
    if handles.modSelect.Value == 1
        ind1 = distFractions == distStim(iDist) & UseTrials; %all trials for given distractor
        ind2 = distFractions == distStim(iDist) & BpodSystem.Data.CorrectSide == 1 & UseTrials; %left only
        ind3 = distFractions == distStim(iDist) & BpodSystem.Data.CorrectSide == 2 & UseTrials; %right only
    
    elseif handles.modSelect.Value == 2
        ind1 = distFractions == distStim(iDist) & ismember(BpodSystem.Data.StimType,[3 5:7]) & UseTrials; %multisensory only
        ind2 = distFractions == distStim(iDist) & BpodSystem.Data.StimType == 1 & UseTrials; %vision only
        ind3 = distFractions == distStim(iDist) & BpodSystem.Data.StimType == 2 & UseTrials; %audio only
        ind4 = distFractions == distStim(iDist) & BpodSystem.Data.StimType == 4 & UseTrials; %somatosensory only
        
    elseif handles.modSelect.Value == 3
        ind = BpodSystem.Data.decisionGap >= distStim(iDist) & BpodSystem.Data.decisionGap < (distStim(iDist) + mean(diff(distStim))); %find trials with right gap values 
        ind1 = ind & ismember(BpodSystem.Data.StimType,[3 5:7]) & UseTrials; %multisensory only
        ind2 = ind & BpodSystem.Data.StimType == 1 & UseTrials; %vision only
        ind3 = ind & BpodSystem.Data.StimType == 2 & UseTrials; %audio only
        ind4 = ind & BpodSystem.Data.StimType == 4 & UseTrials; %somatosensory only
    end
    
    tCount(iDist,1) = sum(BpodSystem.Data.Rewarded(ind1)+BpodSystem.Data.Punished(ind1)); %trialcount
    discPerf(iDist,1) = sum(BpodSystem.Data.Rewarded(ind1))/tCount(iDist,1); %peformance for given distractor
    
    tCount(iDist,2) = sum(BpodSystem.Data.Rewarded(ind2)+BpodSystem.Data.Punished(ind2)); %trialcount
    discPerf(iDist,2) = sum(BpodSystem.Data.Rewarded(ind2))/tCount(iDist,2); %peformance for given distractor
    
    tCount(iDist,3) = sum(BpodSystem.Data.Rewarded(ind3)+BpodSystem.Data.Punished(ind3)); %trialcount
    discPerf(iDist,3) = sum(BpodSystem.Data.Rewarded(ind3))/tCount(iDist,3); %peformance for given distractor
    
    if handles.modSelect.Value > 1
        tCount(iDist,4) = sum(BpodSystem.Data.Rewarded(ind4)+BpodSystem.Data.Punished(ind4)); %trialcount
        discPerf(iDist,4) = sum(BpodSystem.Data.Rewarded(ind4))/tCount(iDist,4); %peformance for given distractor
    end
end

if handles.modSelect.Value == 3
    discPerf = [NaN(1,size(discPerf,2));discPerf];
    ind = BpodSystem.Data.decisionGap == 0 & UseTrials;
    ind1 = ind & ismember(BpodSystem.Data.StimType,[3 5:7]); %multisensory
    ind2 = ind & BpodSystem.Data.StimType == 1; %vision
    ind3 = ind & BpodSystem.Data.StimType == 2; %audio
    ind4 = ind & BpodSystem.Data.StimType == 4; %somatosensory
    
    tCount = sum(BpodSystem.Data.Rewarded(ind1)+BpodSystem.Data.Punished(ind1)); %trialcount
    discPerf(1,1) = sum(BpodSystem.Data.Rewarded(ind1))/tCount; %peformance for given distractor
    
    tCount = sum(BpodSystem.Data.Rewarded(ind2)+BpodSystem.Data.Punished(ind2)); %trialcount
    discPerf(1,2) = sum(BpodSystem.Data.Rewarded(ind2))/tCount; %peformance for given distractor
    
    tCount = sum(BpodSystem.Data.Rewarded(ind3)+BpodSystem.Data.Punished(ind3)); %trialcount
    discPerf(1,3) = sum(BpodSystem.Data.Rewarded(ind3))/tCount; %peformance for given distractor
    
    tCount = sum(BpodSystem.Data.Rewarded(ind4)+BpodSystem.Data.Punished(ind4)); %trialcount
    discPerf(1,4) = sum(BpodSystem.Data.Rewarded(ind4))/tCount; %peformance for given distractor
    
    distStim = [0 distStim];
end

% update modality plot
plotDist = distStim(any(~isnan(discPerf),2));
plotPerf = discPerf(any(~isnan(discPerf),2),:);

if handles.DoFit.Value
    plot(AxesHandle, plotDist,plotPerf(:,2),'og','Markersize',5,...
        'MarkerEdgeColor','g','MarkerFaceColor','w','linewidth',2)
    plot(AxesHandle, plotDist,plotPerf(:,3),'or','Markersize',5,...
        'MarkerEdgeColor','r','MarkerFaceColor','w','linewidth',2)
    plot(AxesHandle, plotDist,plotPerf(:,1),'ok','Markersize',5,...
        'MarkerEdgeColor','k','MarkerFaceColor','w','linewidth',2)
    
    if handles.modSelect.Value == 2
        plot(plotDist,plotPerf(:,4),'ob','Markersize',6,'MarkerEdgeColor','b','MarkerFaceColor','w','linewidth',2,'parent',AxesHandle)
    end
    
    try
        % get fit together and weigh based on trials. To allow fit to be fixed to a guess rate of 0.5, performance below 0.45 is ignored.
        Est = [plotPerf(1,1)/2 0.5  0.1];
        f = @(p,x) 0.5 + p(1) ./ (1 + exp(-((1-x)-p(2))/p(3)));
        BpodSystem.Data.wFit1 = fitnlm(distStim',(plotPerf(:,1)),f,Est,'Weight',(tCount(:,1).*~(plotPerf(:,1)<0.45))'+1);
        BpodSystem.Data.wFit2 = fitnlm(distStim',(plotPerf(:,2)),f,Est,'Weight',(tCount(:,2).*~(plotPerf(:,1)<0.45))'+1);
        BpodSystem.Data.wFit3 = fitnlm(distStim',(plotPerf(:,3)),f,Est,'Weight',(tCount(:,3).*~(plotPerf(:,1)<0.45))'+1);
        
        % plot fitline
        xx = linspace(-0.2,1)';
        line(xx,predict(BpodSystem.Data.wFit1,xx),'Linewidth',2,'color','k','Parent',AxesHandle); % plot fit
        line(xx,predict(BpodSystem.Data.wFit2,xx),'Linewidth',2,'color','g','Parent',AxesHandle); % plot fit
        line(xx,predict(BpodSystem.Data.wFit3,xx),'Linewidth',2,'color','r','Parent',AxesHandle); % plot fit
        if handles.modSelect.Value == 2
            BpodSystem.Data.wFit4 = fitnlm(distStim',(plotPerf(:,4)),f,Est,'Weight',(tCount(:,4).*~(plotPerf(:,1)<0.45))'+1);
            line(xx,predict(BpodSystem.Data.wFit4,xx),'Linewidth',2,'color','b','parent',AxesHandle); % plot fit
        end
    catch
        disp('Fit line could not be plotted')
    end 
else
    plot(plotDist,plotPerf(:,2),'-og','Markersize',5,...
        'MarkerEdgeColor','g','MarkerFaceColor','w','linewidth',2,'Parent',AxesHandle)
    plot(plotDist,plotPerf(:,3),'-or','Markersize',5,...
        'MarkerEdgeColor','r','MarkerFaceColor','w','linewidth',2,'Parent',AxesHandle)
    plot(plotDist,plotPerf(:,1),'-ok','Markersize',5,...
        'MarkerEdgeColor','k','MarkerFaceColor','w','linewidth',2,'Parent',AxesHandle)
    
    if handles.modSelect.Value == 2
        plot(plotDist,plotPerf(:,4),'-ob','Markersize',6,...
            'MarkerEdgeColor','b','MarkerFaceColor','w','linewidth',2,'parent',AxesHandle)
    end
end
grid(AxesHandle,'on');
ylim(AxesHandle,[0.45 1.05]);
if handles.modSelect.Value == 3
    xlim(AxesHandle,[-0.5 distStim(end) + 0.5]); xlabel(AxesHandle,'decision delay (s)');
else
    xlim(AxesHandle,[-0.2 1]);
end
line(AxesHandle.XLim,[0.5 0.5],'linestyle','--','linewidth',1,'color',[0.5 0.5 0.5], 'parent', AxesHandle)

end


function autoRewardAudio_Callback(hObject, eventdata, handles)
% hObject    handle to autoRewardAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of autoRewardAudio as text
%        str2double(get(hObject,'String')) returns contents of autoRewardAudio as a double

global BpodSystem
cVal = str2num(get(hObject,'String'));
if cVal < 0 %Self-performed should not be lower as 0
    cVal = 0;
    set(hObject,'string','0')
elseif cVal > 1 %Self-performed should not be higher as 1
    cVal = 1;
    set(hObject,'string','1')
end

if ~isnan(cVal)
    BpodSystem.ProtocolSettings.autoRewardAudio = cVal; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input to change the training status.'])
    set(hObject,'string',num2str(BpodSystem.ProtocolSettings.autoRewardAudio))
end


% --- Executes during object creation, after setting all properties.
function autoRewardAudio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to autoRewardAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function autoRewardVision_Callback(hObject, eventdata, handles)
% hObject    handle to autoRewardVision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of autoRewardVision as text
%        str2double(get(hObject,'String')) returns contents of autoRewardVision as a double

global BpodSystem
cVal = str2num(get(hObject,'String'));
if cVal < 0 %Self-performed should not be lower as 0
    cVal = 0;
    set(hObject,'string','0')
elseif cVal > 1 %Self-performed should not be higher as 1
    cVal = 1;
    set(hObject,'string','1')
end

if ~isnan(cVal)
    BpodSystem.ProtocolSettings.autoRewardVision = cVal; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input to change the training status.'])
    set(hObject,'string',num2str(BpodSystem.ProtocolSettings.autoRewardVision))
end


% --- Executes during object creation, after setting all properties.
function autoRewardVision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to autoRewardVision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SubjectName_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubjectName as text
%        str2double(get(hObject,'String')) returns contents of SubjectName as a double



function runTime_Callback(hObject, eventdata, handles)
% hObject    handle to runTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of runTime as text
%        str2double(get(hObject,'String')) returns contents of runTime as a double


% --- Executes during object creation, after setting all properties.
function runTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StartTime_Callback(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartTime as text
%        str2double(get(hObject,'String')) returns contents of StartTime as a double


% --- Executes during object creation, after setting all properties.
function StartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cTrial_Callback(hObject, eventdata, handles)
% hObject    handle to cTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cTrial as text
%        str2double(get(hObject,'String')) returns contents of cTrial as a double


% --- Executes during object creation, after setting all properties.
function cTrial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function autoRewardPiezo_Callback(hObject, eventdata, handles)
% hObject    handle to autoRewardPiezo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of autoRewardPiezo as text
%        str2double(get(hObject,'String')) returns contents of autoRewardPiezo as a double

global BpodSystem
cVal = str2num(get(hObject,'String'));
if cVal < 0 %Self-performed should not be lower as 0
    cVal = 0;
    set(hObject,'string','0')
elseif cVal > 1 %Self-performed should not be higher as 1
    cVal = 1;
    set(hObject,'string','1')
end

if ~isnan(cVal)
    BpodSystem.ProtocolSettings.autoRewardPiezo = cVal; %update Bpod object
else
    disp([get(hObject,'String') ' is not a valid input to change the training status.'])
    set(hObject,'string',num2str(BpodSystem.ProtocolSettings.autoRewardPiezo))
end

% --- Executes during object creation, after setting all properties.
function autoRewardPiezo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to autoRewardPiezo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ProbPiezo_Callback(hObject, eventdata, handles)
% hObject    handle to ProbPiezo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ProbPiezo as text
%        str2double(get(hObject,'String')) returns contents of ProbPiezo as a double

ProbVision = str2num(get(handles.ProbVision,'string'));
ProbAudio = str2num(get(handles.ProbAudio,'string'));
ProbPiezo = str2num(get(handles.ProbPiezo,'string'));

if isnan(ProbPiezo) || ProbPiezo < 0
     disp([get(handles.ProbPiezo,'string') ' is an invalid input for piezo probability. Set to 0 instead.'])
     set(handles.ProbPiezo,'string','0');
     ProbPiezo = 0;
end

if (ProbAudio + ProbVision + ProbPiezo) > 1
    set(handles.ProbPiezo,'string',num2str(1 - (ProbAudio + ProbVision))); %set prob piezo as high as possible without the combined probability going beyond 1.
    disp([get(handles.ProbPiezo,'string') ' is higher as possible when combined with pAudio/pVision. Set to ' num2str(ProbPiezo) ' instead.'])
end

% --- Executes during object creation, after setting all properties.
function ProbPiezo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProbPiezo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function optoProb_Callback(hObject, eventdata, handles)
% hObject    handle to optoProb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of optoProb as text
%        str2double(get(hObject,'String')) returns contents of optoProb as a double

S = get(hObject, 'String');
if isempty(str2num(S))
    disp([S ' is not a valid input. Please enter a single number between 0 and 1 for optoProb.'])
    set(hObject, 'String', '0'); %set optoProb to 0
end
if str2num(S) < 0
    set(hObject, 'String', '0'); %set optoProb to 0
elseif str2num(S) > 1
    set(hObject, 'String', '1'); %set optoProb to 1
end
S = get(hObject, 'String');
disp(['optoProb set to ' S])

% --- Executes during object creation, after setting all properties.
function optoProb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optoProb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function optoDur_Callback(hObject, eventdata, handles)
% hObject    handle to optoDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of optoDur as text
%        str2double(get(hObject,'String')) returns contents of optoDur as a double


% --- Executes during object creation, after setting all properties.
function optoDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optoDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in optoTimes.
function optoTimes_Callback(hObject, eventdata, handles)
% hObject    handle to optoTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns optoTimes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from optoTimes


% --- Executes during object creation, after setting all properties.
function optoTimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to optoTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function trialCounter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialCounter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in videoDrive.
function videoDrive_Callback(hObject, eventdata, handles)
% hObject    handle to videoDrive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns videoDrive contents as cell array
%        contents{get(hObject,'Value')} returns selected item from videoDrive


% --- Executes during object creation, after setting all properties.
function videoDrive_CreateFcn(hObject, eventdata, handles)
% hObject    handle to videoDrive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
