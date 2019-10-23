function data_storage = stream_data(t,size_data)
%stream_data: function to receive data from client in small packages in
%specific sizes
%   INPUT
%   t: TCP IP object that is generated in main script
%   size_data: Datasize in Bytes, whenever this is reached in input buffer,
%   the callback function should be active

global streaming
NumPackReceived = 0;

% create data struct 
datastruct = struct('time_pro_sec',[],'time_pro_nsec',[], 'values',[],'information',[],'time_rec_sec',[],'time_rec_nsec',[]);

% create interface object for the callback function
interfaceObject = t;
interfaceObject.BytesAvailableFcn ={@stream_and_save_data,size_data};
interfaceObject.BytesAvailableFcnMode = 'byte';
interfaceObject.BytesAvailableFcnCount = size_data;


% open interface object if not open yet --> else error
fopen(interfaceObject);

% local function stream_and_save_data
    function stream_and_save_data(interfaceObject,~, size_data)
        if streaming && not(interfaceObject.BytesAvailable == 0)
            disp('Streaming starts..')
            
            data = fread(interfaceObject, size_data/8, 'double'); %divided by 8 as double has 8 Byte
            time_rec = rostime('now');

            %seperate data into struct
            datastruct.time_pro_sec = data(1);
            datastruct.time_pro_nsec = data(2);
            datastruct.values = data(3:34);
            datastruct.information = char(data(35:end));
            datastruct.time_rec_sec = time_rec.Sec;
            datastruct.time_rec_nsec = time_rec.Nsec;
            
            % save data in data storage
            data_storage(NumPackReceived+1) = datastruct;
            NumPackReceived = NumPackReceived + 1;
        else
            stopasync(interfaceObject)
            disp('Streaming is stopped...')          

        end
    end
end

