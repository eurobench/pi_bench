function is_ok = store_vector(filename, data, labels, type)

%taken from https://github.com/eurobench/pi_octave_csic/blob/master/src/store_vector.m

    file_id = fopen(filename, "w");
    fprintf(file_id, type);
    fprintf(file_id, labels);
    value_str = "value: ";
    for i = 1:size(data)(2)
        value_str = sprintf("%s%.5f", value_str, data(i));
        if (i != size(data)(2))
            value_str = sprintf("%s, ", value_str);
        endif
    endfor
    value_str = sprintf("%s\n", value_str);
    fprintf(file_id, value_str);
    fclose(file_id);
    is_ok = true;
end