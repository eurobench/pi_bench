function make_table_point(data, filename,labels)
%make_table_wrench: join header and residual point message in the table
%while adding the correct labeling.
    header = [data(1:end).Header];
    header_tbl = ros1_header2table(header);
    point = [data(1:end).Point];
    px = [point(1:end).X];
    py = [point(1:end).Y];
    p_mod = horzcat(px',py');
    p_tbl = array2table(p_mod);
    p_tbl.Properties.VariableNames = labels;
    table = horzcat (header_tbl, p_tbl);
    
    writetable(table, filename, 'Delimiter',',')
end

