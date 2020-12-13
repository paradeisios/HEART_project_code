function make_first_level_matrix(subjects,path_to_data, output_dir, vector_dir)
% Create the first level factorial design matrix for the HEART data and
% evaluate it

% Args : Subjects(list) - Subjects to be analyzed 
%        Path_to_data(string) -Preprocesses img file location
%        Output_dir(string) - Location to create folders with the matrixes
%        Vector_dir(string) - Location of the vector MAT files

for subject = subjects
    subject = num2str(subject, '%02d')   
    directory = [path_to_data,'sub-', subject,'/func/'];
    disp(directory)  
    file_names = dir([directory 'swar*']);
    files = cell(numel(file_names),1);   
    regressor_names = dir([directory 'rp*']);
    files = cell(numel(regressor_names),1);    
    for i=1:numel(file_names)
        files{i} = [directory file_names(i).name];
    end  
    for i=1:numel(regressor_names)
        regressors{i} = [directory regressor_names(i).name];
    end


    mkdir([output_dir 'sub-' subject '/']);
    sub_vector_directory = [vector_dir 'sub-' subject '/'];
    vector = dir([sub_vector_directory 'vectors*']);
    vector_name = [sub_vector_directory vector.name];
    load(vector_name);
    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'First Order Model';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {cellstr(files)'};
    matlabbatch{2}.spm.stats.fmri_spec.dir = {[output_dir 'sub-' subject]};
    matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2.14;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 44;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 22;
    matlabbatch{2}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Named File Selector: First Order Model(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'Sync-Mine';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = vectors.onset{1}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = vectors.duration{1}' ;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'Sync-Other';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = vectors.onset{2}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = vectors.duration{2}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).name = 'ASync-Mine';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).onset = vectors.onset{3}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).duration = vectors.duration{3}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).name = 'ASync-Other';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).onset = vectors.onset{4}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).duration = vectors.duration{4}';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{2}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.multi_reg = cellstr(regressors)';
    matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{2}.spm.stats.fmri_spec.fact(1).name = 'Feedback';
    matlabbatch{2}.spm.stats.fmri_spec.fact(1).levels = 2;
    matlabbatch{2}.spm.stats.fmri_spec.fact(2).name = 'Response';
    matlabbatch{2}.spm.stats.fmri_spec.fact(2).levels = 2;
    matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
    
    spm_jobman('run', matlabbatch);
end
