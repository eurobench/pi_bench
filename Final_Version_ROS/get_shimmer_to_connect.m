function idx_out = get_shimmer_to_connect(sh)

ss = cell2mat(cellfun(@(x) getstatus(x),sh,'uniformoutput',false));

idx_out = find(ss == 0);