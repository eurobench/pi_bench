function StopButton(~,~)
%STOPBUTTON 
%   Sets the global streaming variable to 2 to stop streaming process
global streaming
streaming = 2;
global active 
active = 0;
disp('Stop button pushed...streaming will stop.')
end


