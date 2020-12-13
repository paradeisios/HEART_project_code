function make_second_level_matrix(contrast_map, subjects, path_to_contrasts,output_dir, negative)
% Create the secondlevel factorial design matrix for the HEART data and estimate it

% Args : Contrast_map(struct) - A struct with two fields(contrast name and
%                               contrast name file for the contrasts created at 
%                               the first level
%        Subjects(list) - Subjects to be analyzed 
%        Path_to_contrasts(string) - First level contrast path
%        Output_dir(string) - Location to create folders with the matrixes
%        Negative(boolean) - 1 = Create Negative Contrasts, 0 = Just Positive

if negative == 1
    contrasts = length(contrast_map);
else
    contrasts = 10;
end
for ii = 1: contrasts
    
    mkdir([output_dir contrast_map(ii).name]);
    files = cell(numel(subjects,1));
    n = 1;
   
    for subject = subjects
        
        subject = num2str(subject, '%02d');
        directory = [path_to_contrasts,'/sub-', subject,'/'];
        files{n} = [directory contrast_map(ii).file];
        n = n+1;
        
    end
    
    matlabbatch{1}.spm.stats.factorial_design.dir = {[output_dir contrast_map(ii).name]};
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = cellstr(files)';
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    
    % Estimate model
    fprintf(['Estimating model :' contrast_map(ii).name])
    model_name = [output_dir contrast_map(ii).name '/SPM.mat'];
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {model_name};
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    spm_jobman('run', matlabbatch);

end