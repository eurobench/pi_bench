function table = make_table_wrench(data, filename, labels)
%make_table_wrench: join header and residual wrench message in the table
%while adding the correct labeling.
    header = [data(1:end).Header];
    header_tbl = ros1_header2table(header);
    wrench = [data(1:end).Wrench];
    wrench_tbl = ros1_wrench2table(wrench, labels);
    table = horzcat (header_tbl, wrench_tbl);
    
    writetable(table, filename, 'Delimiter',',')
end

