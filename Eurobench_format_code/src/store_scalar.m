%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% store_scalar.m
%
% Store a scalar into yaml file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function is_ok = store_scalar(filename, data)

    file_id = fopen(filename, "w");

    fprintf(file_id, "type: \'scalar\'\n");

    value_str = sprintf("value: %.5f\n", data);

    fprintf(file_id, value_str);
    fclose(file_id);
    is_ok = true;
end
