function make_first_level_contrasts(subjects,path_to_mats, negative)
% Create the first level contrasts HEART data 
%
% Args : Subjects(list) - Subjects to be analyzed 
%        Path_to_mats(string) - Folder with first level evaluated design matrices
%        Negative(boolean) - If specified as TRUE, will also created negative contrasts

for subject = subjects
    
    sub_name =['sub-',num2str(subject, '%02d')];
    fprintf(['Creating  Positive Contrasts for Subject :', num2str(subject), '\n'])
    
    % Create Positive (t-statistic) Effects
    % Positive Effect of Feedback
    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(strcat(path_to_mats,sub_name,'/SPM.mat'));
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Positive Effect of Feedback';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1 1 -1 -1];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    % Positive Effect of Response
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Positive Effect of Response';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [1 -1 1 -1];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

    % Create Interactions
    % Positive Interaction Feedback x Response
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Positive Interaction Feedback x Response';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [1 -1 -1 1];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    % Create Simple Effects
    % Simple Synch
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Simple Synch(Pos)';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.convec = [1 -1 0 0];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    % Simple Asynch
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Simple Asynch(Pos)';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.convec = [0 0 1 -1];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    % Simple Mine
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Simple Mine(Pos)';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.convec = [1 0 -1 0];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    % Simple Other
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'Simple Other(Pos)';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.convec = [0 1 0 -1];
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    
    % ============================================================================
    % Create Main (F-statistic) Effects
    fprintf(['Creating  F-Contrasts Contrasts for Subject :', num2str(subject), '\n'])
    % Main Effect of Feedback
    matlabbatch{1}.spm.stats.con.consess{8}.fcon.name = 'Main Effect of Feedback';
    matlabbatch{1}.spm.stats.con.consess{8}.fcon.weights = [1 1 -1 -1];
    matlabbatch{1}.spm.stats.con.consess{8}.fcon.sessrep = 'none';
    % Main Effect of Response
    matlabbatch{1}.spm.stats.con.consess{9}.fcon.name = 'Main Effect of Response';
    matlabbatch{1}.spm.stats.con.consess{9}.fcon.weights = [1 -1 1 -1];
    matlabbatch{1}.spm.stats.con.consess{9}.fcon.sessrep = 'none';
    
    % Create Interactions
    % Main Interaction Feedback x Response
    matlabbatch{1}.spm.stats.con.consess{10}.fcon.name = 'Main Effect of Interaction';
    matlabbatch{1}.spm.stats.con.consess{10}.fcon.weights = [1 -1 -1 1];
    matlabbatch{1}.spm.stats.con.consess{10}.fcon.sessrep = 'none';
    
    if negative
        
        fprintf(['Creating Negative Contrasts for Subject :', num2str(subject), '\n'])
        % Create Negative (t-statistic) Effects
        % Negative Effect of Feedback
         matlabbatch{1}.spm.stats.con.consess{11}.tcon.name = 'Negative Effect of Feedback';
        matlabbatch{1}.spm.stats.con.consess{11}.tcon.convec = [-1 -1 1 1];
        matlabbatch{1}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
        % Negative Effect of Response
        matlabbatch{1}.spm.stats.con.consess{12}.tcon.name = 'Negative Effect of Response';
        matlabbatch{1}.spm.stats.con.consess{12}.tcon.convec = [1 -1 1 -1];
        matlabbatch{1}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
        
        % Create Interactions
        % Negative Interaction Feedback x Response
        matlabbatch{1}.spm.stats.con.consess{13}.tcon.name = 'Negative Interaction Feedback x Response';
        matlabbatch{1}.spm.stats.con.consess{13}.tcon.convec = [-1 1 1 -1];
        matlabbatch{1}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
       
        % Create Simple Effects
        % Simple Synch
        matlabbatch{1}.spm.stats.con.consess{14}.tcon.name = 'Simple Synch(Neg)';
        matlabbatch{1}.spm.stats.con.consess{14}.tcon.convec = [-1 1 0 0];
        matlabbatch{1}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
        % Simple Asynch
        matlabbatch{1}.spm.stats.con.consess{15}.tcon.name = 'Simple Synch(Neg)';
        matlabbatch{1}.spm.stats.con.consess{15}.tcon.convec = [0 0 -1 1];
        matlabbatch{1}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
        % Simple Mine
        matlabbatch{1}.spm.stats.con.consess{16}.tcon.name = 'Simple Mine(Neg)';
        matlabbatch{1}.spm.stats.con.consess{16}.tcon.convec = [-1 0 1 0];
        matlabbatch{1}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
        % Simple Other
        matlabbatch{1}.spm.stats.con.consess{17}.tcon.name = 'Simple Other(Neg)';
        matlabbatch{1}.spm.stats.con.consess{17}.tcon.convec = [0 -1 0 1];
        matlabbatch{1}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
        % Eye
        matlabbatch{1}.spm.stats.con.consess{18}.fcon.name = 'Eye';
        matlabbatch{1}.spm.stats.con.consess{18}.fcon.convec = eye(4);
        matlabbatch{1}.spm.stats.con.consess{18}.fcon.sessrep = 'none';
        
    end
    

    
    matlabbatch{1}.spm.stats.con.delete = 1;
    spm_jobman('run',matlabbatch);
    
 end


