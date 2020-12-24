% define fmri_path
fmri_path = '/home/rantanplan/Documents/Paris/heart_img_data/';
% define output_path 
output_path = '/home/rantanplan/Documents/Paris/HEART_PPI/output/first_level/';
% define feddback_path
feedback_path = '/home/rantanplan/Documents/Paris/HEART_PPI/heart_vectors/FEEDBACK/';
% define onset_path
onset_path = '/home/rantanplan/Documents/Paris/HEART_PPI/heart_vectors/RESPONSE/';
% define subjects 
subjects =  [01 02 03 06 07 08 09 10 11  13 14 15 16 17 18 19 20];

for subject = subjects
    subject = num2str(subject, '%02d');
    directory = [fmri_path,'sub-', subject,'/func/'];
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
    
    mkdir([output_path 'sub-' subject '/']);
    feedback = [feedback_path 'sub_' subject '_feedback.mat'];
    load(feedback)
    response = [onset_path 'sub_' subject '_responses.mat'];
    load(response)

    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'First Order Model';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {cellstr(files)'};
    matlabbatch{2}.spm.stats.fmri_spec.dir = {[output_path 'sub-' subject]};
    matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2.14;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 44;
    matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 22;
    matlabbatch{2}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Named File Selector: First Order Model(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'SYNC';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = double(feedback.sync_onset)';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = double(feedback.sync_duration)' ;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'ASYNC';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = double(feedback.async_onset)';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration =  double(feedback.async_duration)';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).name = 'MINE';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).onset = double(responses.mine_onsets)';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).duration = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).orth = 1;
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).name = 'OTHER';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).onset = double(responses.other_onsets)';
    matlabbatch{2}.spm.stats.fmri_spec.sess.cond(4).duration = 0;
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
