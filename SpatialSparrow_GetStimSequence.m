function [stim,events]=SpatialSparrow_GetStimSequence(stimRates, stimIntensities, samplingRate, stimLength, baseline, S)
% Usage: [stim,events]=SpatialDisc_GetStimSequence(stimRates, stimIntensities, samplingRate, baseline, stimLength, S)
% Function to generate stimulus waveforms for the SpatialDisc paradigm.

if~exist('stimRates','var')
    stimRates = [10 1000/150 0; 10 1000/150 0];% Default rate.
end
if~exist('stimIntensities','var')
    stimIntensities = [0.25 5 1;0.25 5 1];% Default full intensities. For the graph display, this determines the amount of LEDs (usually 20).
end
if ~exist('sampli ngRate','var')
    samplingRate = 20000;%Default sampling rate for 8ch analog output module
end
if ~exist('stimLength','var')
    stimLength = 1;%Default stimulus duration
end

if ~exist('baseline','var')
    baseline = 0;%Default baseline duration
end

if ~exist('S','var')
    deadTime = 0; %1ms is default refractory period after events.
    flashLength = 150; %150ms default flash
    beepLength = 3; %3ms default beep
    buzzLength = 50; %20ms default buzz
    coherence = false; %binary flag whether to make multisensory stimuli correlated or not. Only applies if all stimulus durations are < deadTime.
    noiseStim = false; %binary flag whether to make auditory stimuli click sounds or noise bursts
    regStim = false; %binary flag whether to make auditory stimuli click sounds or noise bursts
    gap = 0; %duration of first gap betweeen two stimulus sequences (seconds)
else
    deadTime = S.BinSize/1000;
    flashLength = S.FlashDuration;
    beepLength = S.BeepDuration;
    buzzLength = S.BuzzDuration;
    coherence = S.StimCoherence;
    noiseStim = S.UseNoise;
    regStim = S.RegularStim;
    gap = S.StimGap;
end
stimFreq = 205; %resonant frequency of LRA stimulators (for tactile stimulus)

%% Generate individual event waveforms
%auditory stimuli (multifrequency convolved click)
tt = -pi:2*pi*1000/(samplingRate*beepLength):pi;tt=tt(1:end-1);
beep = (1+cos(tt)).*(sin(2*tt)+sin(4*tt)+sin(6*tt)+sin(8*tt)+sin(16*tt));
sBeep(1,:) = beep*stimIntensities(1)/max(beep);
sBeep(2,:) = beep*stimIntensities(2)/max(beep);

%stim event for somatosensory stimulator
tt = -pi:2*pi*1000/(samplingRate*buzzLength):pi; tt(end-1) = [];
sBuzz(1,:) = (cos(tt)*(stimIntensities(5))+1)/2;
sBuzz(1,:) = (sBuzz(1,:) - min(sBuzz(1,:))) / max((sBuzz(1,:) - min(sBuzz(1,:))));
sBuzz(2,:) = (cos(tt)*(stimIntensities(6)));
sBuzz(2,:) = (sBuzz(2,:) - min(sBuzz(2,:))) / max((sBuzz(2,:) - min(sBuzz(2,:))));

% trigger sequence for visual stimulus
pulseDur = floor(samplingRate * 0.0005); % Duration of a single trigger in a sequence - default is 10 samples which is ~500us at 20000 sampling rate
flash = zeros(2,ceil(flashLength/1000*samplingRate));
tt = 0:5*pi*1000/(samplingRate*.5):5*pi;tt=tt(1:end-1);
pulse = square(tt);
pulse(pulse < 0 ) = 0; %1-0-1-0-1 signal with 5bits in 0.5ms

for x = 1:2
    if stimIntensities(x+2) > 0
        if flashLength >= 25 %led sequence. remove last bit to change to a 1-0-1-0-0 sequence.
            pulse(end-ceil(pulseDur/5):end) = 0;
            pulseSpace = floor((size(flash,2) - (pulseDur * (stimIntensities(x+2)+1))) /  (stimIntensities(x+2))); %space between trigger signals
            temp = repmat([pulse zeros(1,pulseSpace)],1,stimIntensities(x+2));
            flash(x,1:length(temp)) = temp;
        else
            flash(x,1:length(pulse)) = pulse;
        end
        flash(x,end -(samplingRate/1000)+1:end) = [ones(1,ceil(pulseDur/5)) zeros(1,samplingRate/1000 - ceil(pulseDur/5))]; %add stop trigger to close panel in the last ms of the sequence
    end
end

%% Generate poisson-distributed events
events = cell(1,6); %timestamps of stimulus event onset
stimDuration = [beepLength/1000 size(flash,2)/samplingRate buzzLength/1000]; %number of used bin due to stimDuration.
stimDuration = [stimDuration;stimDuration];

for x = 1:6
    
    cDead = stimDuration(x) + deadTime; %dead time for current channel
    
    if stimRates(x) > 0
        if (coherence == 1 && (x > 2 && x < 5) && stimRates(x) > 0 && any(stimRates(1:2) > 0)) || ... %use same event times in visual as set for auditory.
                (coherence == 1 && x > 4 && any(stimRates(3:4) > 0)) %use same event times in somatosensory as set for visual.
            events{x} = events{x-2};
            
        elseif coherence == 1 && x > 4 && any(stimRates(1:2) > 0) %use same event times in somatosensory as set for auditory.
            events{x} = events{x-4};
            
        elseif (1/stimRates(x) > cDead) && ~regStim %if rate allows some flexibility of stim timing. this also catches stimRates = 0 cases
            if stimRates(x) > 0
                eventCheck = true; %flag for end of sequence generation
                lastStim = -cDead; %index of last seq stimulus. Start at -cDead to avoid higher stimulus probability at the onset of the sequence.
                Cnt = 1; %index for event timestamps
                
                while eventCheck
                    cStim = exprnd((1/stimRates(x))-cDead) + cDead; %get new ISI from current to next stimulus
                    if cStim+lastStim < stimLength-(stimDuration(x) + pulseDur/samplingRate) %enough space left to place new stimulus in the sequence
                        lastStim = lastStim + cStim; %absolute timepoint of last event.
                        events{x}(Cnt) = lastStim;
                        Cnt = Cnt + 1;
                    else
                        eventCheck = false; % done
                    end
                end
                if ~isempty(events{x})
                    events{x}(events{x} < cDead) = [];
                end
                events{x} = [0 events{x}]; %add first event in first bin
            end
        else
            if 1/stimRates(x) >= stimDuration(x)
                events{x} = 0:1/stimRates(x):stimLength; %produce regular sequence if remaining time is too short to allow ITI variability
            else
                events{x} = 0:stimDuration(x):stimLength - stimDuration(x); %produce regular sequence at the highest possible frequency, given the stimulus duration
            end
        end
        events{x}(stimLength-events{x} < stimDuration(x)) = [];
        events{x} = events{x} + 1/samplingRate;
    else
        events{x} = [];
    end
end

%% check if higher stimRates ended up with lower counts by chance.
if stimRates(1) ~= stimRates(2) %different rates for auditory
    [~,maxInd] = max(stimRates(:,1));
    [~,swapInd] = max([length(events{1}) length(events{2})]);
    
    if maxInd ~= swapInd %lower rate has more events. switch sequence and events.
        events([1 2]) = events([2 1]);
    end   
end

if stimRates(3) ~= stimRates(4) %different rates for visual
    [~,maxInd] = max(stimRates(:,2));
    [~,swapInd] = max([length(events{3}) length(events{4})]);
    
    if maxInd ~= swapInd %lower rate has more events. switch sequence and events.
        events([3 4]) = events([4 3]);
    end   
end

if stimRates(5) ~= stimRates(6) %different rates for somatosensory
    [~,maxInd] = max(stimRates(:,3));
    [~,swapInd] = max([length(events{5}) length(events{6})]);
    
    if maxInd ~= swapInd %lower rate has more events. switch sequence and events.
        events([5 6]) = events([6 5]);
    end   
end

%% convert stimEvents into analog trace
stim = zeros(8,round(samplingRate*stimLength)); %preallocate stimulus sequence

for x = 1:length(events)
    for y = 1:length(events{x})
        cEvent = round(events{x}(y)*samplingRate) + baseline;
        if x < 3 %auditory stimulus, x > 2 are visual
            stim(x,cEvent:cEvent+size(sBeep,2)-1) = sBeep(x,:);
        elseif x > 2 && x < 5
            stim(x,cEvent:cEvent+size(flash,2)-1) = flash(x-2,:);
        elseif x > 4
            stim(x,cEvent:cEvent+size(sBuzz,2)-1) = sBuzz(x-4,:);
        end
    end
end

% If gap is above 0, double stimulus sequence
if gap > 0
    stim = [stim zeros(size(stim,1),round(samplingRate * gap)) stim];
    for x = 1:length(events)
        events{x} = [events{x} events{x}+stimLength+gap];
    end
end

% add somatosensory noise
cycles = 2*pi*stimFreq*(size(stim,2)/samplingRate);
tt = 0:cycles/(round(samplingRate*(size(stim,2)/samplingRate))):cycles; tt(end-1) = [];
stim(5:6,:) = bsxfun(@times,(stim(5:6,:) +0.01),sin(tt));
        
%check for auditory noise
if noiseStim > 0
    stim(1:2,:) = bsxfun(@plus,stim(1:2,:),((rand(1,size(stim,2))-0.5)*noiseStim));
end

%add baseline
stim = [zeros(size(stim,1),round(samplingRate * baseline)) stim];
