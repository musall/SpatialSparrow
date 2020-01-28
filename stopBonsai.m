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