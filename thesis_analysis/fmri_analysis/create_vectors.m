function create_vectors(subjects,vector_dir)
% Create vectors for SPM(scans) and CONN(times) first level design matrices

% Args : Subjects(list) - Subjects to be analyzed 
%        Vector_dir(string) - Location of the vector mat files
%
% NOTE: Ignore warnings

for subject = subjects
   
    %Loop over folders and find the correct tags
    sub_name =['sub-',num2str(subject, '%02d'),'/'];
    fprintf(['Creating  Vectors for Subject :', num2str(subject), '\n'])
    directory = [vector_dir sub_name];
    file_names = dir([directory 'volume_tags*.mat']);
    files = cell(numel(file_names),1);   
    for i=1:numel(file_names)
        files{i} = [directory file_names(i).name];
    end  
    
    %if multiple mat files in folder, load both and keep the mind-other one
    if  length(files)>1
        
        %check if file belongs in mine-other condition
        load(files{1})
        try 
            any('MINEOTHER' == task_type);
            tags = files{1};
        catch
            warning('First argument must be a string array, character vector, or cell array of character vectors.');
            tags = files{2};  
        end
        
        
    else
        tags = files{1};
    end


    
    load(tags)
    
    % some housekeeping stuff
    condition = strvcat(condition, 'Padding Line');
    response = strvcat(response, 'Padding Line');
    
    sync = (condition(:,1:4) == 'SYNC');
    osync = (condition(:,1:5) == 'OSYNC');
    mine = (response(:,1:4) == 'Mine');
    other = (response(:,1:5) == 'Other');
    
    sync_mine_onset = [];
    sync_other_onset = [];
    osync_mine_onset = [];
    osync_other_onset = [];
    sync_mine_duration = [];
    sync_other_duration = [];
    osync_mine_duration = [];
    osync_other_duration = [];
    
    % next 4 pieces of code will loop through the mat file and extract
    % times for each of the 2x2 interactions
    counter = 1;
    for ii = 1: size(condition,1)
        if (sync(ii,1) == 1 && mine(ii,1) == 1) && (sync(ii-1,1) == 0 || mine(ii-1,1) == 0)
            if isempty(sync_mine_onset)
                sync_mine_onset = [counter];
            else
                sync_mine_onset = [sync_mine_onset counter];
            end
            duration = 0;
            position = ii;
            while (sync(position ,1) == 1 && mine(position,1) == 1)
                duration = duration + 1;
                position = position + 1;
            end
            if isempty(sync_mine_duration)
                sync_mine_duration = [duration];
            else
                sync_mine_duration = [sync_mine_duration duration];
            end
        end
        counter = counter + 1;
    end
    
    counter = 1;
    for ii = 1: size(condition,1)
        if (sync(ii,1) == 1 && other(ii,1) == 1) && (sync(ii-1,1) == 0 || other(ii-1,1) == 0)
            if isempty(sync_other_onset)
                sync_other_onset = [counter];
            else
                sync_other_onset = [sync_other_onset counter];
            end
            duration = 0;
            position = ii;
            while (sync(position,1) == 1 && other(position,1) == 1)
                duration = duration + 1;
                position = position + 1;
            end
            if isempty(sync_other_duration)
                sync_other_duration = [duration];
            else
                sync_other_duration = [sync_other_duration duration];
            end
        end
        counter = counter + 1;
    end
    
    counter = 1;
    for ii = 1: size(condition,1)
        if (osync(ii,1) == 1 && mine(ii,1) == 1) && (osync(ii-1,1) == 0 || mine(ii-1,1) == 0)
            if isempty(osync_mine_onset)
                osync_mine_onset = [counter];
            else
                osync_mine_onset = [osync_mine_onset counter];
            end
            duration = 0;
            position = ii;
            while (osync(position ,1) == 1 && mine(position ,1) == 1)
                duration = duration + 1;
                position = position + 1;
            end
            if isempty(osync_mine_duration)
                osync_mine_duration = [duration];
            else
                osync_mine_duration = [osync_mine_duration duration];
            end
        end
        counter = counter + 1;
    end
    
    counter = 1;
    for ii = 1: size(condition,1)
        if (osync(ii,1) == 1 && other(ii,1) == 1) && (osync(ii-1,1) == 0 || other(ii-1,1) == 0)
            if isempty(osync_other_onset)
                osync_other_onset = [counter];
            else
                osync_other_onset = [osync_other_onset counter];
            end
            duration = 0;
            position = ii;
            while (osync(position ,1) == 1 && other(position,1) == 1)
                duration = duration + 1;
                position = position + 1;
            end
            if isempty(osync_other_duration)
                osync_other_duration = [duration];
            else
                osync_other_duration = [osync_other_duration duration];
            end
        end
        counter = counter + 1;
    end
    
    % save all variables in vectors struct
    vectors = {};
    vectors.names{1} = 'Feedback : SYNCHRONOUS, Response : MINE';
    vectors.onset{1} = sync_mine_onset;
    vectors.duration{1} = sync_mine_duration;
    vectors.TRonset{1} = sync_mine_onset * 2.14;
    vectors.TRduration{1} = sync_mine_duration * 2.14;
    vectors.names{2} = 'Feedback : SYNCHRONOUS, Response : OTHER';
    vectors.onset{2} = sync_other_onset;
    vectors.duration{2} = sync_other_duration;
    vectors.TRonset{2} = sync_other_onset * 2.14;
    vectors.TRduration{2} = sync_other_duration * 2.14;
    vectors.names{3} = 'Feedback : ASYNCHRONOUS, Response : MINE';
    vectors.onset{3} = osync_mine_onset;
    vectors.duration{3} = osync_mine_duration;
    vectors.TRonset{3} = osync_mine_onset * 2.14;
    vectors.TRduration{3} = osync_mine_duration* 2.14 ;
    vectors.names{4} = 'Feedback : ASYNCHRONOUS, Response : OTHER';
    vectors.onset{4} = osync_other_onset;
    vectors.duration{4} = osync_other_duration;
    vectors.TRonset{4} = osync_other_onset * 2.14;
    vectors.TRduration{4} = osync_other_duration * 2.14;
    
    name = tags(91:98);
    save_name = sprintf('vectors_%s.mat',name);
    
    save([directory save_name],'vectors');
end

