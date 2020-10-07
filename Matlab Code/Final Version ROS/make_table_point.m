function make_table_point(data, filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    header = [data(1:end).Header];
    header_tbl = ros1_header2table(header);
    point = [data(1:end).Point];
    px = [point(1:end).X];
    py = [point(1:end).Y];
    p_mod = horzcat(px',py');
    p_tbl = array2table(p_mod);
    p_tbl.Properties.VariableNames = {'CoP_x','CoP_y'};
    table = horzcat (header_tbl, p_tbl);
    
    writetable(table, filename, 'Delimiter',',')
end

