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
    pause(4);
    
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