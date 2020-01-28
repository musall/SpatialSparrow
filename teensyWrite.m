function [good, bad] = teensyWrite(bytes, stopParadigm)
% function to check the handshake with a teensy module. Module should run
% the TouchShaker code and sent byte 14 or 15 in response to receiving a command
% through bpod. Other bytes should be ignored.
% If 'stopParadigm' is true, the code will stop the current paradigm if
% handshake is not successful.

global BpodSystem

%check 2nd input
if ~exist('stopParadigm','var') || isempty(stopParadigm)
    stopParadigm = false;
end

%send bytes to teensy, wait a moment then check for response
ModuleWrite('TouchShaker1',bytes); tic;

% wait for handshake for a max of 1s
good = false; %flag that positive handshake was received
bad = false; %flag that negative handshake was received

if BpodSystem.Modules.RelayActive(strcmpi(BpodSystem.Modules.Name, 'TouchShaker1')) %only check for handshale if relay is active
    while ~(good || bad)
        try
            Byte = ModuleRead('TouchShaker1', 1);
            good = Byte == 14; %positve handshake received
            bad = Byte == 15; %negative handshake received
        end
        if toc > 1
            break
        end
    end
else
    disp('!!! Teensy relay is inactive, so handshake can not be received. !!!');
    good = true;
end

% if no handshake was received in time
if ~(good || bad)
    if stopParadigm % stop paradigm if no handshake was received
        disp('!!! Teensy module did not send any response. Session aborted. !!!');
        BpodSystem.Status.BeingUsed = 0;
    else %try again
        disp('!!! Teensy module did not send any response. Sending command again. !!!');
        BpodSystem.Data.byteLoss = BpodSystem.Data.byteLoss + 1;
        teensyWrite(bytes, true);
    end
end