function SpatialSparrow
global BpodSystem

%% Define or load default settings for protocol
% General settings.
DefaultSettings.SubjectName = 'Dummy';
DefaultSettings.RewardedModality = 'AudioVisual'; % modality that is rewarded - 'Vision' for flashes, 'Audio' for beeps, 'AudioVisual' for multisensory
DefaultSettings.leftRewardVolume = 2;  % ul
DefaultSettings.rightRewardVolume = 2; % ul
DefaultSettings.AutoReward = 0; % automaticunt of self-performed trials with audio stimulation. Default is 1 (fully self-performed).
DefaultSettings.autoRewardVision = 1; % Amount of self-performed trials with visual stimulation. Default is 1 (fully self-performed).
DefaultSettings.autoRewardPiezo = 1; % Amount of self-performed trials with somatosensory stimulation. Default is 1 (fully self-performed).
DefaultSettings.autoRewardAudio = 1; % Amount of self-performed trials with auditory stimulation. Default is 1 (fully self-performed).
DefaultSettings.autoRewardMixed = 1; % Amount of self-performed trials with mixed stimulation. Default is 1 (fully self-performed).
DefaultSettings.SaveSettings = false; % Allows to save current settings to file
DefaultSettings.AdjustSpoutes = 0; % Calls the spout adjustment window if it got closed or if changes to spout position are needed.
DefaultSettings.PerformanceSwitch = 'Performed'; % Switch to show performance over all trials (including trials that were not self-performed)
DefaultSettings.DoFit = false; % flag to do curve fitting in the performance window
DefaultSettings.modSelect = 'Combined'; % selector which part of the data show in the performance curve window
DefaultSettings.StartTime = '1'; %start time of current session.
DefaultSettings.cTrial = 1; %Nr of current trial.
DefaultSettings.LeverSound = true; %play indicator sound when animal is touching levers correctly
DefaultSettings.RegularStim = false; %produce regular stimulus sequence
DefaultSettings.biasSeqLength = 3; %nr of trials on one side after which the oder side is switched with 50% probability
DefaultSettings.widefieldPath = '\\grid-hs\churchland_hpc_home\smusall\BpodImager\Animals\'; %path to widefield data on server
DefaultSettings.videoDrive = 'C:'; %path to where the system saves video data
DefaultSettings.serverPath = '\\grid-hs\churchland_nlsas_data\data\Behavior_Simon\'; %path to behavioral data on server
DefaultSettings.bonsaiEXE = 'C:\Users\Anne\Dropbox\Users\Richard\Bonsai_2_4\Bonsai\Bonsai64.exe'; %path to bonsai .exe
DefaultSettings.bonsaiParadim = 'C:\Users\Anne\Dropbox\Users\Richard\Bonsai_workflow\WorkflowTwoCamera_v02.bonsai'; %path to bonsai workflow
DefaultSettings.wavePort = 'COM6'; %com port for analog module
DefaultSettings.TrainingMode = false; %flag if training is being used

% Spout settings
DefaultSettings.SpoutSpeed = 25; % Duration of spout movement from start to endpoint when moving in or out (value in ms)
DefaultSettings.rInnerLim = 1.5; % Servo position to move right spoute close the animal (value between 0 and 100)
DefaultSettings.lInnerLim = 1.5; % Servo position to move left spoute close the animal (value between 0 and 100)
DefaultSettings.rOuterLim = 3.5; % Servo position to move right spoute more distant from the animal (value between 0 and 100)
DefaultSettings.lOuterLim = 3.5; % Servo position to move left spoute more distant from the animal (value between 0 and 100)
DefaultSettings.LeverSpeed = 150; % Duration of lever movement from start to endpoint when moving in or out (value in ms)
DefaultSettings.TouchThresh = 5; % Threshold for touch lines (SDUs)
DefaultSettings.LeverIn = 20; % Servo position to move lever close to the animal
DefaultSettings.LeverOut = 0; % Servo position to move lever away from the animal
DefaultSettings.lMaxSpoutIn = 30; % maximal inner position for left spout
DefaultSettings.rMaxSpoutIn = 30; % maximal inner position for right spout
DefaultSettings.spoutOffset = 10; %distance from inner spout position when moved out

% Trial timing
DefaultSettings.preStimDelay = 1; % (s) animal should sit still before a new stimulus is presented
DefaultSettings.minITI = 1; % (s) min additional time between trial end and next trial
DefaultSettings.maxITI = 2; % (s) max additional time between trial end and next trial
DefaultSettings.ITIlambda = 10; % defines the jitter between the min and maxITI. Higher lambda will constrain times closer to minITI.
DefaultSettings.WaitingTime = 1; % (s) minimum waiting time before a response can be made. Earlier licks are being ignored.
DefaultSettings.TimeToChoose = 3; % (s) wait for a decision
DefaultSettings.TimeToConfirm = 0.5; % (s) wait for a decision
DefaultSettings.TimeOut = 3; % (s) timeout punish for false response
DefaultSettings.LeverWait = 10; % (s) time to wait for lever grasp. Trial is counted as not responded if no touch is detected.
DefaultSettings.MoveLever = true; % Flag to decide whether lever should be moved or not.
DefaultSettings.UseBothLevers = false; % Flag to decide whether both levers have to be touched to trigger stimulus presentation
DefaultSettings.WaitBeforeLever = 1; % Waiting time before lever is moved in after trial onset
DefaultSettings.StimDuration = 1; % (s) Duration of a stimulus sequence
DefaultSettings.runTime = 0; % (h) Duration of the current session
DefaultSettings.varStimDur = 0; % (s) Variable duration of the stimulus sequence. Stim will be StimDuration + (0 to varStimDur)
DefaultSettings.optoDur = 0.5; % (s) Duration of the optogenetic stimulus.
DefaultSettings.optoRamp = 0.2; % (s) Time where optogenetic stimulus is ramping down. Example: optoDur = 0.5 and optoRamp = 0.2 makes a 500ms stimulus that ramps down after 300ms.
DefaultSettings.happyTime = 0.5; % (s) Time of the last bpod state. This is to give the animal some time to collect the water.

%Stimulus settings
DefaultSettings.BeepDuration = 20; % Beep duration in ms.
DefaultSettings.FlashDuration = 20; % Flash duration in ms.
DefaultSettings.BuzzDuration = 20; % Buzz duration in ms.
DefaultSettings.varStimOn = [0 0.125 0.25]; % Variable onset time for stimulus after lever grab in s. This can be a vector of values. Have to be 0 and higher.
DefaultSettings.StimBrightness = 20; %Brightness of flashes. Multiplier of base frequency (default is 100Hz).
DefaultSettings.StimLoudness = 0.5; %Loudness of tones
DefaultSettings.BuzzStrength = 1; %Strength of buzzes
DefaultSettings.WaitForCam = false; % Any positive value will make each trial wait for a trigger signal from the camera. After CamWait seconds without trigger, protocol will continue.
DefaultSettings.TargRate = 10; % Rate of target sequence. Can be either a single scalar or a vector.
DefaultSettings.DistFractions = 0; % Nr of distractor pulses is a fraction of target pulses. Can be either a single number between 0-1 or a vector.
DefaultSettings.DistProb = 0; % Probability of a presenting a distractor trial. Only has an effect if DistFractions > 0.
DefaultSettings.BinSize = 50; % Refractory period after stimulus presentation after which no stimulus can be presented (value in ms).
DefaultSettings.StimCoherence = 1; % Flag to determine if multisensory stimuli on the same side should be correlated (1) or not (0).
DefaultSettings.UseNoise = false; % Probability to produce a noise burst as auditory stimulus (1). Otherwise a convolved click is produced (0).
DefaultSettings.ProbAudio = 0; % Probability of presenting an audio only trial when modality setting allows it. Has no function otherwise.
DefaultSettings.ProbVision = 0; % Probability of presenting an vision only trial when modality setting allows it. Has no function otherwise.
DefaultSettings.ProbPiezo = 0; % Probability of presenting a somatosensory only trial when modality setting allows it. Has no function otherwise.
DefaultSettings.StimGap = 0; % Duration of a gap in the middle of stimulus presentation in s. When this value is used each stimulus is of stimDuration*2 + stimGap long.
DefaultSettings.DecisionGap = [0.3 1.5]; % Range of a gap between stimulus and decision period in s.
DefaultSettings.TestModality = 0; % Define a modality to be used with discrimination (1=vis,2=aud,4=ss), inactive if set to 0. All others will be detection only.
DefaultSettings.optoProb = 0; % Probability to present an optogenetic stimulus. Ranges from 0 (no optogenetics) to 1 (all trials).
DefaultSettings.optoTimes = 'Stimulus/Delay'; % Part of the trial where optogenetic stimulus should be presented.
DefaultSettings.optoRight = 0.5; %Probability for occurence of an optogenetic stimulus on the right.
DefaultSettings.optoBoth = 1; %Probability for occurence of an optogenetic stimulus on both sides. This comes after determining a single HS target.
DefaultSettings.optoPower = 5; %Power of optogenetic light on the brain surface. This is just an indicator.
DefaultSettings.sRate = 20000; % This is the sampling rate of the analog output module. Max rates: 2ch = 100kHz, 4ch = 50kHz, 8ch = 20kHz
DefaultSettings.PunishSoundDur = 0; % (s) Duration of white noise punish sound when the animal makes a mistake.

% Stimulus presentation settings
DefaultSettings.ProbRight = 0.5; %Probability for occurence of a target presentation on the right.
DefaultSettings.ServoPos = zeros(1,2); % position of left and right spout, relative to their inner limit. these values will be changed by anti-bias correction to correct spout position.

%% Load default settings and update with pre-defined settings if required
defaultFieldParamVals = struct2cell(DefaultSettings);defaultFieldNames = fieldnames(DefaultSettings);
BpodSystem.ProtocolSettings.ServoPos = [0 0];
S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct S
currentFieldNames = fieldnames(S);

if isempty(fieldnames(S)) % If settings file was an empty struct, populate struct with default settings
    S = DefaultSettings;
elseif any(~ismember(defaultFieldNames,currentFieldNames))  %an addition to default settings, update
    differentI = find(~ismember(defaultFieldNames,currentFieldNames)); %find the index
    for ii = 1:numel(differentI)
        thisnewfield = defaultFieldNames{differentI(ii)};
        S.(thisnewfield)=defaultFieldParamVals{differentI(ii)};
    end
end
BpodSystem.ProtocolSettings = S; % Adds the currently used settings to the Bpod struct
BpodSystem.ProtocolSettings.SubjectName = BpodSystem.GUIData.SubjectName; %update subject name
serverPath = [S.serverPath filesep BpodSystem.ProtocolSettings.SubjectName filesep ...
    BpodSystem.GUIData.ProtocolName filesep 'Session Data']; %path to data server
BpodSystem.Data.byteLoss = 0; %counter for cases when the teensy didn't send a response byte

%% ensure teensy and analog modules are present and set up communication
try
    W = BpodWavePlayer(S.wavePort); %check if analog module com port is correct
catch
    % check for analog module by finding a serial device that can create a waveplayer object
    W = [];
    Ports = FindSerialPorts; % get available serial com ports
    for i = 1 : length(Ports)
        try
            W = BpodWavePlayer(Ports{i});
            S.wavePort = Ports{i};
            break
        end
    end
end
if isempty(W)
    warning('No analog output module found. Session aborted.');
    BpodSystem.Status.BeingUsed = 0;
else
    clear W %clear waveplayer object to make sure it uses default values
    W = BpodWavePlayer(S.wavePort);
end
W.OutputRange = '-5V:5V'; % make sure output range is correct
W.TriggerProfileEnable = 'On'; % use trigger profiles to produce different waveforms across channels
W.TriggerProfiles(1, :) = 1:8; %when triggering first row, ch1-8 will play waveforms 1-8
W.TriggerMode = 'Master'; %output can be interrupted by new stimulus triggers
W.LoopDuration(1:8) = 0; %keep on for a up to 10 minutes
W.SamplingRate = BpodSystem.ProtocolSettings.sRate; %adjust sampling rate

% check for teensy module
checker = true;
for i = 1 : length(BpodSystem.Modules.Name)
    if strcmpi(BpodSystem.Modules.Name{i},'TouchShaker1')
        checker = false;
    end
end
if checker
    warning('No teensy module found. Session aborted.');
    BpodSystem.Status.BeingUsed = 0;
end

%% check teensy module
try BpodSystem.StartModuleRelay('TouchShaker1'); java.lang.Thread.sleep(10); end % Relay bytes from Teensy

% send trialstart info and check response
teensyWrite([70 ones(1,6) '550050']); %set high touch threshold to avoid confusing bytes

%set touch threshold
cVal = num2str(BpodSystem.ProtocolSettings.TouchThresh);
teensyWrite([75 length(cVal) cVal]);
pause(2); %give some time for calibration

%% Stimulus parameters - Create trial types list (single vs double stimuli)
maxTrials = 5000;
TrialSidesList = double(rand(1,maxTrials) < S.ProbRight);
PrevProbRight = S.ProbRight;
BpodSystem.Data.cTrial = 1; BpodSystem.Data.Rewarded = logical([]); %needed for cam streamer to work in first trial
[dataPath, bhvFile] = fileparts(BpodSystem.Path.CurrentDataFile); %behavioral file and data path
dataPath(1:2) = S.videoDrive; %switch HDD with current selection
if ~exist(dataPath,'dir') 
    try
        mkdir(dataPath); 
    catch
        disp(['Could not create ',dataPath])
        dataPath = uigetdir(pwd,'Select video folder');
    end
end

%% Initialize camera, control GUI and feedback plots
if BpodSystem.Status.BeingUsed %only run this code if protocol is still active
    BpodNotebook('init');
    BpodSystem.GUIHandles.SpatialSparrow_Control = SpatialSparrow_Control; %get handle for control GUI
    BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control.UserData.update({'init',TrialSidesList,60'}); %initiate control GUI and show outcome plot for the next 60 trials
    BpodSystem.Data.animalWeight = str2double(newid('Enter animal weight (in grams)')); %ask for animal weight and save
    
    % start camera
    % Create a string for the arguments to apss to Bonsai during starting
    WorkflowArg1 = sprintf('-p:VideoFileName0="%s"', [dataPath filesep bhvFile '_' 'video1.mp4']);
    WorkflowArg2 = sprintf('-p:VideoFileName1="%s"', [dataPath filesep bhvFile '_' 'video2.mp4']);
    WorkflowArg3 = sprintf('-p:CsvFileName="%s"', [dataPath filesep bhvFile '_' 'frameTimes.csv']);
    WorkflowArgs = [WorkflowArg1 ' ' WorkflowArg2 ' ' WorkflowArg3];
    
    %start bonsai
    cPath = pwd;
    cd(fileparts(BpodSystem.ProtocolSettings.bonsaiParadim));
    vidStatus = startBonsai(BpodSystem.ProtocolSettings.bonsaiEXE, BpodSystem.ProtocolSettings.bonsaiParadim, WorkflowArgs);
    cd(cPath);
    
    % Use UDP to trigger both cameras to start recording
    pause(2);
    udpAddress = '127.0.0.1'; % configure Bonsai OSC "ReceiveMessage" object using these parameters
    udpPort = 7111; % configure Bonsai OSC "ReceiveMessage" object using these parameters
    udpPath = '/x'; % configure Bonsai OSC "ReceiveMessage" object using these parameters
    udpObj = udp(udpAddress,udpPort);
    fopen(udpObj);
    oscsend(udpObj,udpPath,'i',0) % this uses UDP as a software trigger to start video aquisition by sending the integer 0, which is programmed in the Bonsai OSC ReceiveMessage object as the state triggering video capture
    
    if strcmpi(vidStatus, 'Error')
        disp('An error occured while trying to start Bonsai! Stopping paradigm.');
        BpodSystem.Status.BeingUsed = false;
    end
end

BpodSystem.GUIHandles.SpatialSparrow_SpoutControl.figure1 = []; %handle needs to exist so code does not crash when trying to close all figures
if BpodSystem.Status.BeingUsed %only run this code if protocol is still active
    % start spout adjustment
    disp('Waiting for spout adjustment - hit OK in the SpoutControl window to continue')
    SpatialSparrow_SpoutControl; %call spout control gui
    movegui(BpodSystem.GUIHandles.SpatialSparrow_SpoutControl.figure1,'northwest');
    uiwait(BpodSystem.GUIHandles.SpatialSparrow_SpoutControl.figure1); %wait for spout control and clear handle afterwards
    set(BpodSystem.GUIHandles.SpatialSparrow_Control.ServoPos,'String',['L:' num2str(BpodSystem.ProtocolSettings.ServoPos(1)) '; R:' num2str(BpodSystem.ProtocolSettings.ServoPos(2))]); %set indicator for current servo position
end

%% Initialize some arrays
OutcomeRecord = NaN(1,maxTrials);
AssistRecord = false(1,maxTrials);
LastBias = 1; %last trial were bias correction was used
PrevStimLoudness = S.StimLoudness; %variable to check if loudness has changed
singleSpoutBias = false; %flag to indicate if single spout was presented to counter bias

%% Main loop for single trials
for iTrials = 1:maxTrials
    % only run this code if protocol is still active
    if BpodSystem.Status.BeingUsed
        tic % single trial timer
        BpodSystem.ProtocolSettings.cTrial = iTrials; %log current trial ID in bpod object
        BpodSystem.Data.cTrial = iTrials; %log current trial ID in bpod object
        BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control.UserData.update({'Update','Settings'});  %Get inputs from GUIs
        S = BpodSystem.ProtocolSettings; %update settings for this trial
        W.SamplingRate = BpodSystem.ProtocolSettings.sRate; %adjust sampling rate
        sRate = BpodSystem.ProtocolSettings.sRate;
        oscsend(udpObj,udpPath,'i',iTrials) % send current trialnr to bonsai
        
        %% create sounds - recreate if loudness has changed
        if iTrials == 1 || PrevStimLoudness ~= S.StimLoudness
            LeftPortValveState = 2^0;
            RightPortValveState = 2^1; % ports are numbered 0-7. Need to convert to 8bit values for bpod
            PunishSound = ((rand(1,sRate*S.PunishSoundDur) * 5) - 2.5)/10; %white noise for punishment
            RewardSound = zeros(1,sRate*0.02);RewardSound(1:sRate*0.01) = 1; %20ms click sound for reward
            RewardSound = RewardSound*0.5;
            
            if isempty(PunishSound);PunishSound = zeros(1,sRate/1000);end
            if isempty(RewardSound);RewardSound = zeros(1,sRate/1000);end
            leverSound = GenerateSineWave(sRate, 2000, 0.05) / 10; %0.5s pure tone if lever is touched to subsequently trigger the stimulus
            
            W.loadWaveform(10,leverSound); % load signal to waveform object
            W.loadWaveform(11,RewardSound); % load signal to waveform object
            W.loadWaveform(12,PunishSound); % load signal to waveform object
            PrevStimLoudness = S.StimLoudness;
            
            W.TriggerProfiles(10, 1:2) = 10; %this will play waveform 10 (leverSound) on ch1+2
            W.TriggerProfiles(11, 1:2) = 11; %this will play waveform 11 (rewardSound) on ch1+2
            W.TriggerProfiles(12, 1:2) = 12; %this will play waveform 12 (punishSound) on ch1+2
        end
        
        if S.AdjustSpoutes
            disp('Waiting for spout adjustment - hit OK in the SpoutControl window to continue')
            SpatialSparrow_SpoutControl; %call spout control gui
            uiwait(BpodSystem.GUIHandles.SpatialSparrow_SpoutControl.figure1); %wait for spout control and clear handle afterwards
            S.AdjustSpoutes = false; %set variable back to false
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.AdjustSpoutes,'Value',false); %set GUI back to false
        end
        
        %update valve times
        LeftValveTime = GetValveTimes(S.leftRewardVolume, 1);
        RightValveTime = GetValveTimes(S.rightRewardVolume, 2);
        
        % update performance plot
        if iTrials > 1
            BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control.UserData.update({'Update','Performance',TrialSidesList,OutcomeRecord,AssistRecord});drawnow; clear temp % update PMF plots
        end
        
        % update modality plot
        if iTrials > 1 && rem(iTrials,10) == 0
            BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control.UserData.update({'Update','modality',TrialSidesList,OutcomeRecord,AssistRecord});drawnow; clear temp % update performance curves
        end
        
        % update touch threshold every 50 trials
%         if iTrials > 1 && rem(iTrials,50) == 0
%             cVal = num2str(BpodSystem.ProtocolSettings.TouchThresh);
%             teensyWrite([75 length(cVal) cVal]);
%         end
        
        % if stimulus probability has changed, compute a new sidelist and re-initate outcome plot
        if PrevProbRight ~= S.ProbRight
            PrevProbRight = S.ProbRight;
            TrialSidesList = [TrialSidesList(1:iTrials) double(rand(1,5000-iTrials) < S.ProbRight)];
        end
        
        % decide over detection vs discrimination
        if rand > S.DistProb  % unimodal trial (detection only)
            TrialType = 1; %identifier for detection trial - stimulate only one side
        else
            TrialType = 2; %identifier for discrimination trial.
        end
        
        % if the same side was repeated more than 'biasSeqLength'
        if iTrials > S.biasSeqLength
            if length(unique(TrialSidesList(iTrials-S.biasSeqLength:iTrials))) == 1
                if rand > 0.5
                    TrialSidesList(iTrials) = double(~logical(TrialSidesList(iTrials))); %flip to the other side
                end
            end
        end
        
        if iTrials >1  %update outcome plot
            BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control.UserData.update({'Update','Outcome',TrialSidesList,OutcomeRecord,AssistRecord});drawnow; % update outcome plot
        end
        
        %% Move servo based on difference between left and right performance
        temp = TrialSidesList(LastBias:end); %get sides for all trials since the last check
        temp = temp(AssistRecord(LastBias:end)); %get sides for all performed trials
        
        if sum(temp == 0) > 5 && sum(temp == 1) > 5 %if more than 5 trials were performed on both sides
            LastBias = iTrials;
            ServoPos = get(BpodSystem.GUIHandles.SpatialSparrow_Control.ServoPos,'String'); %set indicator for current servo position
            ServoPos(strfind(ServoPos,'L'))=[];ServoPos(strfind(ServoPos,'R'))=[]; %remove non-nummeric part of the string but leave space in there
            ServoPos(strfind(ServoPos,':'))=[];ServoPos(strfind(ServoPos,';'))=[]; %remove non-nummeric part of the string but leave space in there
            ServoPos = str2num(ServoPos); %convert to numbers
            ServoPos(ServoPos<0) = 0; %make sure there are no negative values
            
            if length(ServoPos) == 2
                BpodSystem.ProtocolSettings.ServoPos = ServoPos;
            end
            
            SideDiff = BpodSystem.Data.rPerformance(iTrials-1)-BpodSystem.Data.lPerformance(iTrials-1); %performance difference
            if abs(SideDiff) > 0.2 && abs(SideDiff) < 0.5 %small correction
                cMove = 1;
            elseif abs(SideDiff) >=  0.5 && abs(SideDiff) < 1 %medium correction
                cMove = 3;
            elseif abs(SideDiff) == 1 %large correction
                cMove = 5;
            else
                cMove = 0; %no correction
            end
            
            if SideDiff < 0 %stronger left performance
                cInd = [1 2]; %create index to modify right values in ServoPos
                lim(1) = S.lInnerLim; %get inner and outer limit for biased spout
                lim(2) = S.lOuterLim;
            else
                cInd = [2 1]; %stronger right performance
                lim(1) = S.rInnerLim;
                lim(2) = S.rOuterLim;
            end
            
            if BpodSystem.ProtocolSettings.ServoPos(cInd(2)) > 0 %if 'weak' spout is not at its inner limit
                if BpodSystem.ProtocolSettings.ServoPos(cInd(2)) < cMove
                    BpodSystem.ProtocolSettings.ServoPos(cInd(2)) = 0; %move weak spout to its inner limit
                else
                    BpodSystem.ProtocolSettings.ServoPos(cInd(2)) = BpodSystem.ProtocolSettings.ServoPos(cInd(2)) - cMove; %move weak spout closer again
                end
            else
                if lim(1) - BpodSystem.ProtocolSettings.ServoPos(cInd(1)) - cMove > lim(2) %if 'strong' spout can be moved closer without going below the outer limit
                    BpodSystem.ProtocolSettings.ServoPos(cInd(1)) = BpodSystem.ProtocolSettings.ServoPos(cInd(1)) + cMove; %move 'strong' spout further away
                else
                    if round(BpodSystem.ProtocolSettings.ServoPos(cInd(1)),2) < round(lim(1)-lim(2),2) %if spout is not at its outer limit
                        BpodSystem.ProtocolSettings.ServoPos(cInd(1)) = lim(1)-lim(2); %move spout to its outer limit
                    end
                end
            end
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.ServoPos,'String',['L:' num2str(BpodSystem.ProtocolSettings.ServoPos(1)) '; R:' num2str(BpodSystem.ProtocolSettings.ServoPos(2))]); %set indicator for current servo position
        end
        
        %% Assign stimuli and create output variables
        % Determine stimulus presentation
        TargStim = Sample(S.TargRate);
        if TrialType == 2 % present distractor stimulus
            DistStim = Sample(S.DistFractions);
            if DistStim < 0 || DistStim > 1
                warning(['Current DistFraction = ' num2str(Distractor) '; Set to 0 instead.']);
                DistStim = 0;
            end
            DistStim = floor(DistStim * TargStim); %convert distractor fraction to rate
        else
            DistStim = 0;
        end
        StimRates = repmat([TargStim;DistStim],1,3);
        if TrialSidesList(iTrials) == 1
            StimRates = flipud(StimRates); %first row is left target, second row is right target
        end
        
        % add decision gap if required
        cDecisionGap = 0;
        if any(S.DecisionGap ~= 0) % present decision gap
            if length(S.DecisionGap) == 1 %if only one value is given, window should range between 0 and that value
                S.DecisionGap = [0 abs(S.DecisionGap)];
            end
            if length(S.DecisionGap) == 2 %randomly pick from range of values
                S.DecisionGap = sort(abs(S.DecisionGap)); %make sure values are absoluted and sorted correctly
                cDecisionGap = (diff(S.DecisionGap) * rand) + S.DecisionGap(1); %choose random decision gap value for current trial
            elseif length(S.DecisionGap) > 2 %if more than 2 values are provided, randomly pick one of them
                cDecisionGap = Sample(abs(S.DecisionGap));
            end
            BpodSystem.ProtocolSettings.DecisionGap = sort(abs(S.DecisionGap)); %make potential changes permanent
        end
        
        % check rewarded modality.
        if strcmpi(S.RewardedModality,'Vision')
            StimType = 1;
        elseif strcmpi(S.RewardedModality,'Audio')
            StimType = 2;
        elseif strcmpi(S.RewardedModality,'Somatosensory')
            StimType = 4;
        elseif strcmpi(S.RewardedModality,'AudioVisual')
            StimType = 3;
            singleModProb = S.ProbAudio + S.ProbVision; %probability of switchting to single modality
            if rand < singleModProb %switch to single modality
                if rand <= (S.ProbAudio / singleModProb)
                    StimType = 2; %switch to audio trial
                else
                    StimType = 1; %switch to vision trial
                end
            end
        elseif strcmpi(S.RewardedModality,'SomatoVisual')
            StimType = 5;
            singleModProb = S.ProbPiezo + S.ProbVision; %probability of switchting to single modality
            if rand < singleModProb %switch to single modality
                if rand <= (S.ProbPiezo / singleModProb)
                    StimType = 4; %switch to somatosensory trial
                else
                    StimType = 1; %switch to vision trial
                end
            end
        elseif strcmpi(S.RewardedModality,'SomatoAudio')
            StimType = 6;
            singleModProb = S.ProbPiezo + S.ProbAudio; %probability of switchting to single modality
            if rand < singleModProb %switch to single modality
                if rand <= (S.ProbPiezo / singleModProb)
                    StimType = 4; %switch to somatosensory trial
                else
                    StimType = 2; %switch to audio trial
                end
            end
        elseif strcmpi(S.RewardedModality,'AllMixed')
            StimType = 7;
            %  ProbAudio and ProbVision can switch trial to single modality if any is larger then 0.
            singleModProb = S.ProbAudio + S.ProbVision + S.ProbPiezo; %probability of switchting to single modality
            if rand < singleModProb %switch to single modality
                coin = rand;
                if coin <= (S.ProbAudio / singleModProb)
                    StimType = 2; %switch to audio trial
                elseif coin > (S.ProbAudio / singleModProb) && coin < ((S.ProbAudio + S.ProbVision) / singleModProb)
                    StimType = 1; %switch to vision trial
                else
                    StimType = 4; %switch to somatosensory trial
                end
            end
        end
        
        % check for trained modality
        if StimType ~= S.TestModality && ismember(S.TestModality, 1:6) %if TestModality is active and current stimType is not selected, switch to detection
            DistStim = 0;
        end
        
        UseChannels = zeros(2,3); %1st column auditory, 2nd column visual, 3rd column somatosensory; 1st row left, 2nd row right
        % audio
        if ismember(StimType,[2 3 6 7]) %if auditory stimulation is required
            if TrialSidesList(iTrials) == 0
                UseChannels(1) = 1; %use left channel
            else
                UseChannels(2) = 1; %use right channel
            end
            if DistStim > 0
                UseChannels(:,1) = [1,1]; %use both channels
            end
        end
        % vision
        if ismember(StimType,[1 3 5 7]) %if visual stimulation is required
            if TrialSidesList(iTrials) == 0
                UseChannels(3) = 1; %use left channel
            else
                UseChannels(4) = 1; %use right channel
            end
            if DistStim > 0
                UseChannels(:,2) = [1,1]; %use both channels
            end
        end
        % somatosensory
        if ismember(StimType,4:7) %if somatosensory stimulation is required
            if TrialSidesList(iTrials) == 0
                UseChannels(5) = 1; %use left channel
            else
                UseChannels(6) = 1; %use right channel
            end
            if DistStim > 0
                UseChannels(:,3) = [1,1]; %use both channels
            end
        end
        StimIntensities = [S.StimLoudness S.StimBrightness S.BuzzStrength; S.StimLoudness S.StimBrightness S.BuzzStrength];
        
        % only use selected channels
        StimRates(~UseChannels) = 0;
        StimIntensities(~UseChannels) = 0;
        
        %% Compute variable stimulus duration if varStimDur is > 0;
        if strcmpi(class(S.varStimDur), 'double') && S.varStimDur >= 0
            stimDur = S.StimDuration + rand * S.varStimDur;
        else
            S.varStimDur = 0;
            stimDur = S.StimDuration;
        end
        
        %check for variable stimulus onset. Has to > 0 seconds. If 2 inputs are
        %given, they define an interval from which a random delay is taken.
        if length(S.varStimOn) ~= 2
            cStimOn = Sample(abs(S.varStimOn));
        else
            cStimOn = min(S.varStimOn) + rand * abs(diff(S.varStimOn));
        end
        if ~strcmpi(class(cStimOn),'double')
            cStimOn = 0;
            BpodSystem.ProtocolSettings.varStimOn = 0;
            warning('Invalid input for varStimOn. Set to 0 instead.')
        end
        
        %% create analog waveforms
        [Signal,stimEvents] = SpatialSparrow_GetStimSequence(StimRates, StimIntensities, sRate, stimDur, cStimOn, S); %produce stim sequences and event log
        
        %% check if optogenetic stimulus should be presented
        optoDur = 0; %duration of optogenetic stimulus
        optoSide = NaN; %side to which an optogenetic stimulus gets presented. 1 = left, 2 = right.
        optoType = NaN; % time of optogenetic stimulus
        % (1 = Stimulus, 2 = Delay, 3 = Response, 4 = Late Stimulus (Computed from stimulus end instead of start),
        %  5 = Handle period. Starts right with stimulus onset. Use varStimOn to ensure this doesnt come up during the stimulus.)
        
        if rand < S.optoProb
            % determine time of opto stimulus
            if strcmpi(S.optoTimes,'Stimulus')
                optoType = 1;
            elseif strcmpi(S.optoTimes,'Delay')
                optoType = 2;
            elseif strcmpi(S.optoTimes,'Stimulus/Delay')
                if rand > 0.5
                    optoType = 1;
                else
                    optoType = 2;
                end
            elseif strcmpi(S.optoTimes,'Response')
                optoType = 3;
            elseif strcmpi(S.optoTimes,'LateStimulus')
                optoType = 4;
            elseif strcmpi(S.optoTimes,'Handle')
                optoType = 5;
            elseif strcmpi(S.optoTimes,'AllTimes')
                coin = rand;
                if coin < 0.2
                    optoType = 1;
                elseif coin >= 0.2 && coin < 0.4
                    optoType = 2;
                elseif coin >= 0.4 && coin < 0.6
                    optoType = 3;
                elseif coin >= 0.6 && coin < 0.8
                    optoType = 4;
                elseif coin >= 0.8
                    optoType = 5;
                end
            end
            
            % determinde side of opto stimulus
            if rand > S.optoRight
                optoSide = 1; %left
            else
                optoSide = 2; %right
            end
            
            if rand <= S.optoBoth
                optoSide = 3; %both sides
            end
            
            if isinf(S.optoDur) && (optoType == 1 || optoType == 4)
                optoDur = stimDur;
            elseif isinf(S.optoDur) && optoType == 2
                optoDur = cDecisionGap;
            elseif isinf(S.optoDur) && optoType == 3
                optoDur = 1; % shouldnt inactivate for more than 1s if time is set to infinity
            elseif isinf(S.optoDur) && optoType == 5
                optoDur = S.varStimOn(1); % shouldnt be longer as minimum time before stimulus onset.
            else
                optoDur = S.optoDur;
            end
            
            % create opto stim sequence
            pulse = ones(1, round(optoDur * sRate));
            pulse(end-round(S.optoRamp * sRate)+1:end) = 1-1/round(S.optoRamp * sRate) : -1/round(S.optoRamp * sRate) : 0;
            pulse(end) = 0; %make sure this goes back to 0
            
            
            Signal(7:8,:) = zeros(2,size(Signal,2)); % make sure these channels are empty
            stimDur = size(Signal,2) / sRate; %adjust stimulus duration based on analog signal
            if optoType == 1 %find stimulus onset (stimulus period)
                optoStart = ceil(cStimOn*sRate);
            elseif optoType == 2 %find stimulus offset (delay period)
                optoStart = size(Signal,2)+1;
            elseif optoType == 3 %find stimulus offset and add delay time (response period)
                optoStart = size(Signal,2) + round(cDecisionGap*sRate);
            elseif optoType == 4 %find stimulus offset and subtract optogenetic stimulation time (late stimulus period)
                optoStart = size(Signal,2) - length(pulse);
            elseif optoType == 5 %start with signal presentation. This should occur during the varStimOn time (Handle period).
                optoStart = 1;
                if S.varStimOn(1) == 0
                    warning(['!!! varStimOn(1) = 0. Handle inactivation might affect stimulus period. OptoDur = ' num2str(optoDur) '!!!']);
                end
            else
                optoSide = NaN;
                warning('Unknown optoType. No opto stimulus created !!!');
            end
            
            if optoStart < 1; optoStart = 1; end %should not be negative
            
            if optoSide == 1
                Signal(7, optoStart : optoStart + length(pulse) - 1) = pulse; %stimulate left HS
            elseif optoSide == 2
                Signal(8, optoStart : optoStart + length(pulse) - 1) = pulse; %stimulate right HS
            elseif optoSide == 3
                Signal(7:8, optoStart : optoStart + length(pulse) - 1) = repmat(pulse,2,1); %stimulate both HS
            end
        end
        
        %% Check training status and set up if auto-reward should be given
        GiveReward = false; SingleSpout = false; %make sure trials are not aided by mistake
        if S.TrainingMode
            if StimType == 1
                checker = S.autoRewardVision;
            elseif StimType == 2
                checker = S.autoRewardAudio;
            elseif StimType == 4
                checker = S.autoRewardPiezo;
            elseif ismember(StimType,[3 5 6 7])
                checker = S.autoRewardMixed;
            else
                warning(['Unknown StimType! StimType = ' num2str(StimType)]);
            end
            
            if rand > checker %checker = 0 means no unassisted trials, 1 is all trials are unassisted.
                SingleSpout = true; % percentage of unassisted trials. Use single spouts if spouts are moving.
            end
        else
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.autoRewardMixed,'string','1')
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.autoRewardAudio,'string','1')
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.autoRewardVision,'string','1')
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.autoRewardPiezo,'string','1')
        end
        
        % check for additional single spout if animal keeps making mistakes on the same side
        if singleSpoutBias
            seqLength = 1;
        else
            seqLength = S.biasSeqLength*2;
        end
        singleSpoutBias = false;
        
        if iTrials > seqLength && S.ProbRight == 0.5
            %provide single spout if animal is strictly going to one side
            if length(unique(BpodSystem.Data.ResponseSide(iTrials-seqLength : iTrials - 1))) == 1 %animal always goes to the same side
                if (TrialSidesList(iTrials)+1) ~= unique(BpodSystem.Data.ResponseSide(iTrials-seqLength : iTrials - 1)) %current trial is non-preferred side
                    if rand > 0.75
                        SingleSpout = true;
                        singleSpoutBias = true;
                    end
                end
            end
            
            %provide autoreward if animal does not touch lever anymore
            if sum(ismember(OutcomeRecord(iTrials-seqLength:iTrials-1),4)) == 3
                if rand > 0.5
                    GiveReward = true;
                end
            end
        end
        
        if SingleSpout && ~isnan(optoSide) %dont give optogenetic stimulus in single spout trials
            optoType = NaN; optoSide = NaN;
            Signal(7:8,:) = zeros(2,size(Signal,2));
        end
        
        %% move signal to analog module
        for iChans = 1 : size(Signal,1)
            W.loadWaveform(iChans,Signal(iChans,:)); % load current channel to analog output module
            W.BpodEvents{iChans} = 'On';
        end
        
        %% set bpdod state information for current trial
        if S.WaitingTime == S.StimDuration %if waitduration equals stimduration, adjust waiting time to match variable stim time
            waitDur = stimDur;
        else
            waitDur = S.WaitingTime;
        end
        
        CamTrig = 'Tup';
        if S.WaitForCam > 0 %check whether camera trigger is required to trigger trial and stimulus presentation
            CamTrig = 'BNC1High';
        end
        
        if TrialSidesList(iTrials) == 0 %target is left
            LeftPortAction = 'CheckReward';
            pLeftPortAction = 'CheckReward';
            cLeftPortAction = 'Reward';
            WireRewardOut = 103; %move right spout out if animal chooses left
            RightPortAction = 'CheckPunish';
            cRightPortAction = 'CheckPunish';
            pRightPortAction = 'HardPunish';
            WirePunishOut = 102; %move left spout out if animal chooses right
            RewardValve = LeftPortValveState; %left-hand port represents port#0, therefore valve value is 2^0
            rewardValveTime = LeftValveTime;
            correctSide = 1;
            cSide = 'Left';wSide = 'Right';
        else
            LeftPortAction = 'CheckPunish';
            cLeftPortAction = 'CheckPunish';
            pLeftPortAction = 'HardPunish';
            WirePunishOut = 103; %move right spout out if animal chooses left
            RightPortAction = 'CheckReward';
            pRightPortAction = 'CheckReward';
            cRightPortAction = 'Reward';
            WireRewardOut = 102; %move left spout out if animal chooses right
            RewardValve = RightPortValveState; %right-hand port represents port#2, therefore valve value is 2^2
            rewardValveTime = RightValveTime;
            correctSide = 2;
            cSide = 'Right';wSide = 'Left';
        end
        
        if S.AutoReward || GiveReward
            autoValve = rewardValveTime; %give automatic reward
        else
            autoValve = 0; %don't open if no lick occured
        end
        
        if S.MoveLever
            LeverWait = S.LeverWait; %wait for lever touch
            LeverState = 'WaitBeforeLever';
            LeverMiss = 'DidNotLever';
            if S.UseBothLevers
                LeverWaitState = 'WaitForBothLevers'; %both handles are touched
            else
                LeverWaitState = 'WaitForLever'; %any handle is touched
            end
        else
            LeverWait = 0; %don't wait
            LeverState = 'CheckAutoReward';
            LeverMiss = 'WaitForAnimal1';
        end
        
        if S.LeverSound %play indicator sound on lever touch
            leverSoundID = 9;
        else
            leverSoundID = 63; %this will be empty, so no sound
        end
        
        %% display some stimulus information
        cModality = {'Vision only' 'Audio only' 'AudioVisual' 'Somatosensory' 'SomatoVisual' 'SomatoAudio' 'AllMixed'};
        disp(['Trial ' int2str(iTrials) ' - ' cModality{StimType} '; DecisionGap: ' num2str(cDecisionGap)]);
        disp(['Target: ' num2str(TargStim) ' Hz - ' cSide]);
        disp(['Dist. Fraction: ' num2str(DistStim) ' - ' wSide]);
        disp(['SingleSpout: = ' int2str(SingleSpout) '; AutoReward = ' num2str(GiveReward || S.AutoReward)]);
        
        plot(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, linspace(0,length(Signal)/sRate,length(Signal)), Signal(1,:), 'g'); %update stimulus plot - audio1
        hold(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,'on')
        plot(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, linspace(0,length(Signal)/sRate,length(Signal)), Signal(2,:), 'c'); %update stimulus plot - audio2
        plot(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, linspace(0,length(Signal)/sRate,length(Signal)), Signal(7,:), 'k'); %update stimulus plot - vision1
        plot(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, linspace(0,length(Signal)/sRate,length(Signal)), Signal(8,:), 'b'); %update stimulus plot - vision2
        plot(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, linspace(0,length(Signal)/sRate,length(Signal)), Signal(5,:), 'r'); %update stimulus plot - somatosensory1
        plot(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, linspace(0,length(Signal)/sRate,length(Signal)), Signal(6,:), 'y'); %update stimulus plot - somatosensory1
        hold(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,'off')
        a = min(min(Signal));b = max(max(Signal));ylim(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,[a-a/5 b+b/5]);
        ylim(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,[a b*1.25]);
        xlim(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,[0 stimDur]);
        line([waitDur waitDur],get(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,'YLim'),'Color','r','Parent',BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot,'linewidth',2);
        set(BpodSystem.GUIHandles.SpatialSparrow_Control.StimulusPlot, 'box', 'off');
        
        %% send trial information to arduino
        LeftIn = round(S.lInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(1); %left inner position - bias offset
        RightIn = round(S.rInnerLim,2) - BpodSystem.ProtocolSettings.ServoPos(2); %right inner position - bias offset
        LeftOut = LeftIn - S.spoutOffset; %left outer position
        RightOut = RightIn - S.spoutOffset; %right outer position
        
        if SingleSpout
            if correctSide == 1 %correct side is left
                RightIn = RightOut - abs(RightIn - RightOut); %move right spout in opposite direction
            else
                LeftIn = LeftOut - abs(LeftIn - LeftOut); %move left spout in opposite direction
            end
        end
        
        % convert to strings and combine as teensy output
        LeftIn = num2str(LeftIn); RightIn = num2str(RightIn);
        LeftOut = num2str(LeftOut); RightOut = num2str(RightOut);
        LeverIn = num2str(BpodSystem.ProtocolSettings.LeverIn);
        LeverOut = num2str(BpodSystem.ProtocolSettings.LeverOut);
        
        cVal = [length(LeftIn) length(RightIn) length(LeftOut) length(RightOut) length(LeverIn) length(LeverOut) ...
            LeftIn RightIn LeftOut RightOut LeverIn LeverOut];
        
        % send trial information to teensy and move spouts/lever to outer position
        try BpodSystem.StartModuleRelay('TouchShaker1'); java.lang.Thread.sleep(10); end % Start relaying bytes from teensy
        teensyWrite([70 cVal]);% send spout/lever information to teensy at trial start
        teensyWrite(102); % Move left spout to outer position
        teensyWrite(103); % Move right spout to outer position
        teensyWrite(105); % Move handles to outer position
        BpodSystem.StopModuleRelay('TouchShaker1'); % Stop relaying bytes from teensy to allow communication with state machine

        %% Build state matrix
        sma = NewStateMatrix();
        
        sma = AddState(sma, 'Name', 'TrialStart', ... %trigger to signal trialstart to attached hardware. Only works when using 'WaitForCam'.
            'Timer', S.WaitForCam, ...
            'StateChangeConditions', {CamTrig,'TriggerDowntime','Tup','TriggerDowntime'},... %wait for imager before producing barcode sequence
            'OutputActions', {'BNCState',1}); % BNC 1 is high, all others are low
        
        sma = AddState(sma, 'Name', 'TriggerDowntime', ... %give a 50ms downtime of the trigger before sending the barcode. Might help with to ensure that data is correctly recorded.
            'Timer', 0.05, ...
            'StateChangeConditions', {'Tup','trialCode1'},...
            'OutputActions', {'TouchShaker1', 78}); % all outpouts are low but make teensy send a trial-onset trigger
        
        % generate barcode to identify trialNr on adjacent hardware
        Cnt = 0;
        code = encode2of5(iTrials);
        codeModuleDurs = [0.0025 0.0055]; %Durations for each module of the trial code sent over the TTL line
        
        for iCode = 1:size(code,2)
            Cnt = Cnt+1;
            stateName = ['trialCode' num2str(Cnt)];
            nextState = [stateName 'Low'];
            
            sma = AddState(sma, 'Name', stateName, ... %produce high state
                'Timer', codeModuleDurs(code(1,iCode)), ...
                'StateChangeConditions', {'Tup',nextState},... %move to next low state
                'OutputActions',{'BNCState',1}); %send output to BNC1 to send barcode to adjacent hardware
            
            stateName = nextState;
            if iCode == size(code,2)
                nextState = 'CheckForLever';
            else
                nextState = ['trialCode' num2str(Cnt + 1)];
            end
            
            sma = AddState(sma, 'Name', stateName, ... %produce low state
                'Timer', codeModuleDurs(code(2, iCode)), ...
                'StateChangeConditions', {'Tup',nextState},... %move to next low state
                'OutputActions',{});
        end
        
        sma = AddState(sma, 'Name', 'CheckForLever', ... %check if lever is part of the paradigm
            'Timer', 0, ...
            'StateChangeConditions', {'Tup',LeverState},... %skip WaitBeforeLever if not required
            'OutputActions', {});
        
        sma = AddState(sma, 'Name', 'WaitBeforeLever', ... %wait duration before the lever is moved in
            'Timer', S.WaitBeforeLever, ...
            'StateChangeConditions', {'Tup','MoveLever'},...
            'OutputActions', {});
        
        sma = AddState(sma, 'Name', 'MoveLever', ... %state to move handles
            'Timer', 1, ...
            'StateChangeConditions', {'Tup','CheckAutoReward','TouchShaker1_14','CheckAutoReward'},...
            'OutputActions', {'TouchShaker1', 104}); % move handles in
        
        sma = AddState(sma, 'Name', 'CheckAutoReward', ... %always give a reward if AutoReward is on
            'Timer', autoValve, ...
            'StateChangeConditions', {'Tup',LeverWaitState},...  %do a short break before moving to response state
            'OutputActions', {'ValveState', RewardValve}); %open reward valve
        
        sma = AddState(sma, 'Name', 'WaitForLever', ... %wait for any levertouch
            'Timer', LeverWait, ...
            'StateChangeConditions', {'TouchShaker1_5', 'WaitForAnimal', 'TouchShaker1_6', 'WaitForAnimal', 'TouchShaker1_7', 'WaitForAnimal', 'Tup', LeverMiss},... %in lever case, any touch is required. Otherwise will move on immediately. Goes to 'DidNotLever' if no touch appears until S.Leverwait.
            'OutputActions', {'TouchShaker1', 76}); % request lever states from teensy
        
        sma = AddState(sma, 'Name', 'WaitForBothLevers', ... %wait for both levertouches
            'Timer', LeverWait, ...
            'StateChangeConditions', {'TouchShaker1_7', 'WaitForAnimal', 'Tup', LeverMiss},... %in lever case, any touch is required. Otherwise will move on immediately. Goes to 'DidNotLever' if no touch appears until S.Leverwait.
            'OutputActions', {'TouchShaker1', 76}); % request lever states from teensy
        
        sma = AddState(sma, 'Name', 'WaitForAnimal', ... %hold both handles for a baseline duration before stimulus presentation
            'Timer', S.preStimDelay, ...
            'StateChangeConditions', {'TouchShaker1_8', LeverWaitState, 'TouchShaker1_9', LeverWaitState, 'Tup','WaitForCam'},... %restart waiting period if animal releases any of the handles prematurely
            'OutputActions', {'WavePlayer1',['P' leverSoundID]}); % play lever sound on ch 1+2
        
        sma = AddState(sma, 'Name', 'WaitForCam', ... %wait for next camera trigger befor starting the Stimulus - this is to synchronize with image acquisition
            'Timer',S.WaitForCam, ...
            'StateChangeConditions', {CamTrig,'PlayStimulus','Tup','PlayStimulus'},... %start stimulus presentation
            'OutputActions', {});
        
        sma = AddState(sma, 'Name', 'PlayStimulus', ... %present stimulus for the set stimulus duration.
            'Timer', waitDur, ... %waitDur is the duration the animal has to wait before moving to next state
            'StateChangeConditions', {'Tup','DecisionWait'},...
            'OutputActions', {'WavePlayer1',['P' 0], 'TouchShaker1', 77}); %start stimulus presentation + stimulus trigger
        
        sma = AddState(sma, 'Name', 'DecisionWait', ... %Add gap after stimulus presentation
            'Timer', cDecisionGap, ...
            'StateChangeConditions', {'Tup','MoveSpout'},...
            'OutputActions', {});
        
        sma = AddState(sma, 'Name', 'MoveSpout', ... %move spouts towards the animal so it can report its choice
            'Timer', 1, ...
            'StateChangeConditions', {'Tup','WaitForResponse','TouchShaker1_14','WaitForResponse'},...
            'OutputActions', {'TouchShaker1', 101}); % trigger to moves spouts in
        
        sma = AddState(sma, 'Name', 'WaitForResponse', ... %wait for animal response after stimulus was presented
            'Timer', S.TimeToChoose, ...
            'StateChangeConditions', {'TouchShaker1_1', LeftPortAction, 'TouchShaker1_2', RightPortAction, 'Tup', 'DidNotChoose'},...
            'OutputActions',{});
        
        sma = AddState(sma, 'Name', 'CheckReward', ... %wait for second lick to confirm decision.
            'Timer', S.TimeToConfirm, ...
            'StateChangeConditions', {'TouchShaker1_1', cLeftPortAction, 'TouchShaker1_2', cRightPortAction, 'Tup', 'WaitForResponse'},...
            'OutputActions',{});
        
        sma = AddState(sma, 'Name', 'CheckPunish', ... %wait for second lick to confirm decision.
            'Timer', S.TimeToConfirm, ...
            'StateChangeConditions', {'TouchShaker1_1', pLeftPortAction, 'TouchShaker1_2', pRightPortAction, 'Tup', 'WaitForResponse'},...
            'OutputActions',{});
        
        sma = AddState(sma, 'Name', 'Reward', ... %reward for correct response
            'Timer', rewardValveTime,...
            'StateChangeConditions', {'Tup','HappyTime'},...
            'OutputActions', {'ValveState', RewardValve, 'WavePlayer1',['P' 10], 'TouchShaker1', WireRewardOut}); %open reward valve and play reward click (don't act if reward was given already)
        
        sma = AddState(sma, 'Name', 'HappyTime', ... %wait for a moment to collect water
            'Timer', S.happyTime, ...
            'StateChangeConditions', {'Tup', 'StopStim'}, ...
            'OutputActions', {});
        
        sma = AddState(sma, 'Name', 'HardPunish', ... %punish for incorrect response - timeout + punish sound
            'Timer', 1,... %skip this state for now and pause in Matlab instead. This is to make sure behavioral videos are not longer as in rewarded trials.
            'StateChangeConditions', {'Tup','StopStim', 'TouchShaker1_14','StopStim'},...
            'OutputActions', {'WavePlayer1',['P' 11], 'TouchShaker1', WirePunishOut}); %play punish sound
        
        sma = AddState(sma, 'Name', 'DidNotLever', ... %if animal did not touch the lever move on to next trial
            'Timer', 0.01, ...
            'StateChangeConditions', {'Tup', 'StopStim'}, ...
            'OutputActions', {'BNCState', 2});
        
        sma = AddState(sma, 'Name', 'DidNotChoose', ... %if animal did not respond move on to next trial
            'Timer', 0.01, ...
            'StateChangeConditions', {'Tup', 'StopStim'}, ...
            'OutputActions', {'BNCState', 2});
        
        sma = AddState(sma, 'Name', 'StopStim', ... %move to next trials after a randomly varying waiting period.
            'Timer', 1, ...
            'StateChangeConditions', {'Tup', 'exit', 'TouchShaker1_14','exit'}, ...
            'OutputActions', {'WavePlayer1','X', 'TouchShaker1', 105});  %make sure all stimuli are off and move handles out
        
        %% send state machine to bpod and create ITI jitter
        SendStateMachine(sma);
        pause(0.1);
                
        trialPrep = toc; %check how much time was used to prepare trial and subtract from ITI
        if S.minITI >= 0 && S.maxITI > 0
            x = -log(rand)/S.ITIlambda;
            ITIjitter = mod(x,S.maxITI - S.minITI) + S.minITI;
        else
            ITIjitter = 0; disp('ITI jitter is set to 0.')
        end
        if trialPrep > ITIjitter
            ITIjitter = trialPrep; %if time was used already just keep that as jitter and move on
        else
            java.lang.Thread.sleep((ITIjitter - trialPrep)*1000); %wait a moment to get to determined ITI
        end
        disp(BpodSystem.SerialPort.bytesAvailable)
        BpodSystem.SerialPort.read(BpodSystem.SerialPort.bytesAvailable, 'uint8'); %remove all bytes from serial port
        
        while BpodSystem.SerialPort.bytesAvailable > 0
            disp('!!! Something really weird is going on with the serial communication to Bpod !!!');
            disp(BpodSystem.SerialPort.bytesAvailable);
            BpodSystem.SerialPort.read(BpodSystem.SerialPort.bytesAvailable, 'uint8'); %remove all bytes from serial port
            pause(0.01);
            BpodSystem.Data.weirdBytes = true;
        end
        
        %% run bpod and save data after trial is finished
        RawEvents = RunStateMachine; % Send and run state matrix

        % Save events and data
        if length(fieldnames(RawEvents)) > 1
            
            BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); %collect trialdata
            BpodSystem.Data.Rewarded(iTrials) = ~isnan(BpodSystem.Data.RawEvents.Trial{1,iTrials}.States.Reward(1)); %Correct choice
            BpodSystem.Data.Punished(iTrials) = ~isnan(BpodSystem.Data.RawEvents.Trial{1,iTrials}.States.HardPunish(1)); %False choice
            BpodSystem.Data.DidNotChoose(iTrials) = ~isnan(BpodSystem.Data.RawEvents.Trial{1,iTrials}.States.DidNotChoose(1)); %No choice
            BpodSystem.Data.DidNotLever(iTrials) = ~isnan(BpodSystem.Data.RawEvents.Trial{1,iTrials}.States.DidNotLever(1)); %No choice
            BpodSystem.Data.TargStim(iTrials) = TargStim; %Pulsecount for target side
            BpodSystem.Data.DistStim(iTrials) = DistStim; %Pulsecount for distractor side
            BpodSystem.Data.ITIjitter(iTrials) = ITIjitter; %duration of jitter between trials
            BpodSystem.Data.CorrectSide(iTrials) = correctSide; % 1 means left, 2 means right side
            BpodSystem.Data.StimType(iTrials) = StimType; % 1 means vision is rewarded, 2 means audio is rewarded
            BpodSystem.Data.stimEvents{iTrials} = stimEvents; % timestamps for individual events on each channel. Order is AL,AR,VL,VR, timestamps are in s, relative to stimulus onset (use stimOn to be more precise).
            BpodSystem.Data.TrialSettings(iTrials) = S; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
            BpodSystem.Data = BpodNotebook('sync', BpodSystem.Data); % Sync with Bpod notebook plugin
            BpodSystem.Data.TrialStartTime(iTrials) = RawEvents.TrialStartTimestamp(end); %keep absolute start time of each trial
            BpodSystem.Data.stimDur(iTrials) = stimDur; %stimulus duration of current trial
            BpodSystem.Data.decisionGap(iTrials) = cDecisionGap; %duration of gap between stimulus and decision in current trial
            BpodSystem.Data.stimOn(iTrials) = cStimOn; %variability in stim onset relative to lever grab. Creates an additional baseline before stimulus events.
            BpodSystem.Data.optoSide(iTrials) = optoSide; %side to which an optogenetic stimulus gets presented. 1 = left, 2 = right.
            BpodSystem.Data.optoType(iTrials) = optoType; %%time of optogenetic stimulus (1 = Stimulus, 2 = Delay')
            BpodSystem.Data.optoDur(iTrials) = optoDur; %%duration of optogenetic stimulus (s)
            
            if BpodSystem.Data.Punished(iTrials)
                pause(S.TimeOut); %punishment pause
            end
            
            % collect performance in OutcomeRecord variable (used for performance plot)
            if BpodSystem.Data.DidNotChoose(iTrials)
                OutcomeRecord(iTrials) = 3;
            elseif BpodSystem.Data.DidNotLever(iTrials)
                OutcomeRecord(iTrials) = 4;
            else
                OutcomeRecord(iTrials) = BpodSystem.Data.Rewarded(iTrials);
            end
            AssistRecord(iTrials) = ~any([GiveReward SingleSpout S.AutoReward]); %identify fully animal-performed trials.
            BpodSystem.Data.Assisted(iTrials) = AssistRecord(iTrials);
            BpodSystem.Data.SingleSpout(iTrials) = SingleSpout;
            BpodSystem.Data.AutoReward(iTrials) = any([GiveReward S.AutoReward]);
            BpodSystem.Data.Modality(iTrials) = TrialType; % 1 means detection trial, 2 means discrimination trial, 3 means delayed detection trial
            
            if OutcomeRecord(iTrials) < 3 %if the subject responded
                if (correctSide==1 && BpodSystem.Data.Rewarded(iTrials)) || (correctSide==2 && ~BpodSystem.Data.Rewarded(iTrials))
                    BpodSystem.Data.ResponseSide(iTrials) = 1; %left side
                elseif ((correctSide==1) && ~BpodSystem.Data.Rewarded(iTrials)) || ((correctSide==2) && BpodSystem.Data.Rewarded(iTrials))
                    BpodSystem.Data.ResponseSide(iTrials) = 2; %right side
                end
            else
                BpodSystem.Data.ResponseSide(iTrials) = NaN; %no response
            end
            
            % move spouts and lever out
            try BpodSystem.StartModuleRelay('TouchShaker1'); java.lang.Thread.sleep(10); end % Relay bytes from Teensy
            teensyWrite([71 1 '0' 1 '0']); % Move spouts to zero position
            teensyWrite([72 1 '0']); % Move handles to zero position
            
            %print things to screen
            fprintf('Nr. of trials initiated: %d\n', iTrials)
            fprintf('Nr. of completed trials: %d\n', nansum(OutcomeRecord==0|OutcomeRecord==1))
            fprintf('Nr. of rewards: %d\n', nansum(OutcomeRecord==1))
            fprintf('Amount of water in ul (est.): %d\n',  nansum(OutcomeRecord==1) * (mean([S.leftRewardVolume S.rightRewardVolume])))
            
        end
        SaveBpodSessionData % Saves the field BpodSystem.Data to the current data file
        
        if S.SaveSettings %if current settings should be saved to file
            S.SaveSettings = false; %set variable back to false before saving
            ProtocolSettings = BpodSystem.ProtocolSettings;
            save(BpodSystem.GUIData.SettingsFileName, 'ProtocolSettings'); % save protocol settings file to directory
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.SaveSettings,'Value',false); %set GUI back to false after saving
        end
        
        % show elapsed time and check if code still runs
        toc;disp('==============================================')
        
        HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
        
    else  %stop code if stop button is pressed and close figures
        if S.SaveSettings %if current settings should be saved to file
            S.SaveSettings = false; %set variable back to false before saving
            ProtocolSettings = BpodSystem.ProtocolSettings;
            save(BpodSystem.GUIData.SettingsFileName, 'ProtocolSettings'); % save protocol settings file to directory
            set(BpodSystem.GUIHandles.SpatialSparrow_Control.SaveSettings,'Value',false); %set GUI back to false after saving
        else
            % check if settings should be saved when ending current session
            button = questdlg('Save current settings?','Save settings','Yes','No','Yes'); %creates a question dialog box with two push buttons labeled 'str1' and 'str2'. default specifies the default button selection and must be 'str1' or 'str2'.
            if strcmp(button,'Yes')
                ProtocolSettings = BpodSystem.ProtocolSettings;
                save(BpodSystem.GUIData.SettingsFileName, 'ProtocolSettings'); % save protocol settings file to directory
            end
        end
        
        % check for path to server and save behavior + graph
        if exist(BpodSystem.ProtocolSettings.serverPath, 'dir') %if server responds
            try
                if ~exist(serverPath,'dir')
                    mkdir(serverPath)
                end
                SessionData = BpodSystem.Data; %current session data
                if ~isempty(SessionData)
                    save([serverPath bhvFile],'SessionData'); %save datafile
                    
                    %save session graph
                    sPath = strrep(serverPath,'Session Data','Session Graphs');
                    if ~exist(sPath,'dir')
                        mkdir(sPath)
                    end
                    set(BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control,'PaperOrientation','portrait','PaperPositionMode','auto');
                    saveas(BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control, [sPath filesep bhvFile '.jpg']);
                end
            catch
                warning('!!! Error while writing to server. Make sure local data got copied correctly. !!!');
            end
        end
        
        % check for BpodImager imager folder on the server and save data there if a matching destination is found
        if exist(BpodSystem.ProtocolSettings.widefieldPath,'dir')
            wfPath = [S.widefieldPath filesep BpodSystem.ProtocolSettings.SubjectName filesep ...
                BpodSystem.GUIData.ProtocolName filesep]; %path to data server
            check = dir([wfPath '*' date '*_open']); %check for open folder (created by BpodImager)
            if ~isempty(check)
                SessionData = BpodSystem.Data; %current session data
                save([wfPath check.name filesep bhvFile],'SessionData'); %save datafile
            end
        end
        break;
    end
end

%% move steppers to zero, close video and all figures
try
    try BpodSystem.StartModuleRelay('TouchShaker1'); java.lang.Thread.sleep(10); end % Relay bytes from Teensy
    teensyWrite([71 1 '0' 1 '0']); % Move spouts to zero position
    teensyWrite([72 1 '0']); % Move handles to zero position
    
    oscsend(udpObj,udpPath,'i',1000) % stop video capture
    stopBonsai(); %shut down bonsai
    
    % close figures
    close(BpodSystem.GUIHandles.SpatialSparrow_Control.SpatialSparrow_Control);
    close(BpodSystem.GUIHandles.SpatialSparrow_SpoutControl.figure1);
    close(BpodSystem.GUIHandles.ParamFig);
end
end

%% nested functions
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
end


function returnValue = startBonsai(pathBonsai, pathWorkflow, workflowArgs)
%STARTBONSAI Start Bonsai with a predefined workflow (tree) and add. arguments
%
% Synopsis:
% ---------
% retVal = startBonsai(pathBonsai, pathWorkflow, workflowArgs);
%
% Arguments:
% ----------
% pathBonsai: Fully-qualified (absolute) path to 'Bonsai.exe' as a string
%             E.g.: 'C:\Users\<username>\AppData\Local\Bonsai\Bonsai.exe'
%
% pathWorkflow: Fully-qualified (absolute) path to the workflow to be opened  as a string
%               E.g.: 'C:\Users\<username>\Documents\Bosnai\Workflow.bonsai'
%
% workflowArgs: List of arguments to the workflow as a string
%               '-p:Arg1="value_for_Arg_1" -p:Arg2="value_for_Arg_2"'
%
% Output:
% -------
% A string indicating the action:
% - 'Start': All commands were executed without error and Bonsai should have started
% - 'Error': Something went wrong and Bonsai might not have been started
%
% Additional Information:
% -----------------------
% This script makes use of the Windows Script Host to start Bonsai. For ore
% information, please see following references:
% - Reference (Windows Script Host):
%   https://docs.microsoft.com/en-us/previous-versions//98591fh7%28v%3dvs.85%29
% - Methods (Windows Script Host):
%   https://docs.microsoft.com/en-us/previous-versions//2x3w20xf%28v%3dvs.85%29
% - AppActivate Method
%   https://docs.microsoft.com/en-us/previous-versions//wzcddbek%28v%3dvs.85%29
% - Run Method (Windows Script Host)
%   https://docs.microsoft.com/en-us/previous-versions//d5fk67ky%28v%3dvs.85%29
% - SendKeys Method
%   https://docs.microsoft.com/en-us/previous-versions//8c6yea83%28v%3dvs.85%29
%
%
% Author: Michael Wulf
%         Cold Spring Harbor Laboratory
%         Kepecs Lab
%         One Bungtown Road
%         Cold Spring Harboor
%         NY 11724, USA
%
% Date:    04/26/2019
% Version: 1.0.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

returnValue = 'Start';
try
    % Get an instance of scripting shell
    %
    hndlWScript = actxserver('WScript.Shell');
    
    % First, try to close all open bonsai windows
    stillOpenFlag = hndlWScript.AppActivate('Bonsai');
    
    % Counter for keeping track of how many Bonsai-windows have been closed so
    % far. If too many Bonsai-windows are opened the user might have opened
    % additional Bonsai instances and this script will terminate with an error
    % stating that circumstance.
    closingCntr = 0;
    
    while(stillOpenFlag == 1)
        % Send Alt-F4 to close Bonsai
        % - code for Alt-key: '%'
        % - code for F4-key:  {F4}
        % -> code for Alt-F4: %{F4}
        hndlWScript.SendKeys('%{F4}');
        
        % Wait a second for closing to be finished
        pause(1);
        
        % Increment counter
        closingCntr = closingCntr + 1;
        
        % MAke an output to the console
        fprintf('Trying to close Bonsai for the %d. time...\n', closingCntr);
        
        % Activate (bring to focus) another possibly available Bonsai window
        stillOpenFlag = hndlWScript.AppActivate('Bonsai');
        
        if (closingCntr > 5)
            error('Too many Bonsai windows open...');
        end
    end
    
    % Starting Bonsai
    hndlWScript.Run([pathBonsai ' ' pathWorkflow ' ' workflowArgs]);
    fprintf('Trying to open Bonsai...\n');
    
    % Wait for Bonsai to start
    pause(6);
    
    % Bring Bonsai to foreground
    hndlWScript.AppActivate('Bonsai');
    % Send F5-hotkey to start workflow
    hndlWScript.SendKeys('{F5}');
    fprintf('Starting workflow...\n');
    pause(1);
    
catch ME
    returnValue = 'Error';
    warning('An error occured while trying to start Bonsai...');
    disp(ME.identifier);
    disp(ME.message);
end
end

function returnValue = stopBonsai()
%STOPBONSAI Stop currently running Bonsai workflow and close Bonsai
%
% Synopsis:
% ---------
% retVal = stopBonsai();
%
% Arguments:
% ----------
% -none
%
% Output:
% -------
% A string indicating the action:
% - 'Stop':  All commands were executed without error and Bonsai should have stopped
% - 'Error': Something went wrong and Bonsai might not have been stopped
%
% Additional Information:
% -----------------------
% This script makes use of the Windows Script Host to start Bonsai. For ore
% information, please see following references:
% - Reference (Windows Script Host):
%   https://docs.microsoft.com/en-us/previous-versions//98591fh7%28v%3dvs.85%29
% - Methods (Windows Script Host):
%   https://docs.microsoft.com/en-us/previous-versions//2x3w20xf%28v%3dvs.85%29
% - AppActivate Method
%   https://docs.microsoft.com/en-us/previous-versions//wzcddbek%28v%3dvs.85%29
% - Run Method (Windows Script Host)
%   https://docs.microsoft.com/en-us/previous-versions//d5fk67ky%28v%3dvs.85%29
% - SendKeys Method
%   https://docs.microsoft.com/en-us/previous-versions//8c6yea83%28v%3dvs.85%29
%
%
% Author: Michael Wulf
%         Cold Spring Harbor Laboratory
%         Kepecs Lab
%         One Bungtown Road
%         Cold Spring Harboor
%         NY 11724, USA
%
% Date:    04/26/2019
% Version: 1.0.0

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

returnValue = 'Stop';
try
    % Get an instance of scripting shell
    hndlWScript = actxserver('WScript.Shell');
    
    % Wait a bit
    pause(0.5);
    
    % Bring Bonsai to foreground
    hndlWScript.AppActivate('Bonsai');
    
    % Send hotkey to stop workflow
    hndlWScript.SendKeys('+{F5}');
    fprintf('Stopping workflow...\n');
    
    % Wait a bit
    pause(0.5);
    
    % Bring Bonsai to foreground again
    hndlWScript.AppActivate('Bonsai');
    
    % Send hotkey to close Bonsai
    hndlWScript.SendKeys('%{F4}');
    fprintf('Closing Bonsai...\n');
    
catch ME
    returnValue = 'Error';
    warning('An error occured while trying to stop Bonsai...');
    disp(ME.identifier);
    disp(ME.message);
end

end