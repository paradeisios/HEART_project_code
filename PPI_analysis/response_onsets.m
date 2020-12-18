function responses = response_onsets(mat_file)

    mat = load(mat_file);
    blocks = feedback_blocks(mat_file);
    block_ends = [blocks.sync_onset+blocks.sync_duration blocks.async_onset+blocks.async_duration];

    mine_onset = [];
    other_onset = [];

    for ii = (block_ends)
        
        if mat.response(ii,:) == "Mine "
            mine_onset = [mine_onset ii+1];
        else
            other_onset = [other_onset ii+1];        
        
        end
    end

    responses = struct();
    responses.name = mat_file(13:17);
    responses.mine = mine_onset; responses.other = other_onset;
end
    
    
