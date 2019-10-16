function send (t, data_to_send)
% send data via tcpip

%create tcp object 
    %t = tcpip('localhost', port, 'NetworkRole', 'client');
    
%open tcpip connection 
if not(strcmpi(get(t,'status'), 'open'))
    try
        fopen(t);
    catch
        disp('Cannot initiate TCP IP connection')
    end
end

if strcmpi(get(t,'status'), 'open')
        %reshaping of data in extra function before using the sending function
        reshaped_data = reshape_sent(data_to_send);
        fwrite(t, reshaped_data, 'uint16') 
end


end 