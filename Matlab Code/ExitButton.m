function ExitButton(~,~)
%EXITBUTTON 
%   Sets the global streaming variable to 3 to stop streaming and close the
%   connection clientwise
global streaming
streaming = 3;
disp('Exit button pushed...script will stop running.')
end

