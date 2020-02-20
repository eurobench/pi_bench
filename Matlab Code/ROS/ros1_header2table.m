function header_tbl = ros1_header2table(header)
%header2table: convert the standard header of a ROS message into a table 
%   Header consisting of time stamp struct (seconds and nanoseconds) and
%   frame id is converted into a table with three columns. First column is
%   seconds, than nanoseconds and then frame id.

% converting the time stamp struct into a table 
    stamp = [header(1:end).Stamp];
    sec = [stamp(1:end).Sec];
    nsec = [stamp(1:end).Nsec];
    sec_tbl = array2table(sec');
    nsec_tbl = array2table(nsec');
    
    sec_tbl.Properties.VariableNames = {'sec'};
    nsec_tbl.Properties.VariableNames = {'nsec'};

% converting the strings of the frame id into cells to save them as  table
    for a= 1:size(header,2)
        if a == 1
            frame_id = cellstr(header(a).FrameId);
        else
            frame_id = horzcat(frame_id , cellstr(header(a).FrameId));
        end
    end
    
  frame_tbl = cell2table(frame_id');
  frame_tbl.Properties.VariableNames = {'frame_id'};
    
% fusing both parts to one table 
    header_tbl = horzcat(sec_tbl, nsec_tbl, frame_tbl);
end

