function  make_final_data_structure(table_sec, table_part, labels , filename)
%MAKE_FINAL_DATA_STRCUTURE ordering old table to final data structure
sec = table_sec{:,1} + table_sec{:,2}*10^-9;
final = array2table(horzcat(sec, table_part));
final.Properties.VariableNames = labels;

writetable(final, filename, 'Delimiter',',')

end

