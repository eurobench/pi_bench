function StopButton(~,~)
%STOPBUTTON 
%   Sets the global streaming variable to 0 to stop streaming process
global streaming
global streaming_completed
streaming = 0;
streaming_completed = 1;
disp('Stop button pushed...streaming will stop.')
%close tcp ip connection ? wenn streaming = 0 in anderem skript
end


