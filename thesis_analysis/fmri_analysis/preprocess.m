
function preprocess(subjects,path_to_data,tpm_dir,TR,NSLICE,SLICE_ORDER)


TA = TR -(TR/NSLICE);

% Specify subject folders
filename = sprintf('Preprocess_Heart_%s.log',datestr(clock));
filepath = [path_to_data filename];
fid = fopen(filepath, 'wt');


for subject = subjects
    subject = num2str(subject, '%02d');
    fprintf(['Proccessing Subject :',  subject, '\n'])
    anat_directory = [path_to_data,'sub-', subject,'/anat/'];
    func_directory = [path_to_data,'sub-', subject,'/func/'];
    disp(anat_directory)
    disp(func_directory)
    
    anat_file_names = dir([anat_directory 'HEART*.img']);
    anat_files = cell(numel(anat_file_names),1);
    func_file_names = dir([func_directory 'HEART*.img']);
    func_files = cell(numel(func_file_names),1);
    
    
    for i=1:numel(anat_file_names)
        anat_files{i} = [anat_directory anat_file_names(i).name];
    end
    for i=1:numel(func_file_names)
        func_files{i} = [func_directory func_file_names(i).name];
    end
    %fprintf(fid,'Working on subject: %02s\n',subject);
    %fprintf(fid,'Start Time %s\n\n',datestr(clock));
    tic

    %%% File Selector
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Functional';
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files ={func_files};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'Anatomical';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {anat_files};
   
    matlabbatch{3}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Named File Selector: Functional(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{3}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{4}.spm.temporal.st.scans{1}(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{4}.spm.temporal.st.nslices = NSLICE;
    matlabbatch{4}.spm.temporal.st.tr = TR;
    matlabbatch{4}.spm.temporal.st.ta = TA;
    matlabbatch{4}.spm.temporal.st.so = SLICE_ORDER;
    matlabbatch{4}.spm.temporal.st.refslice = 22;
    matlabbatch{4}.spm.temporal.st.prefix = 'a';
    matlabbatch{5}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{5}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Named File Selector: Anatomical(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{5}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    matlabbatch{6}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Named File Selector: Anatomical(1) - Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{6}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{6}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{6}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{6}.spm.spatial.preproc.tissue(1).tpm = {sprintf('%sTPM.nii,1',tpm_dir)};
    matlabbatch{6}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{6}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(2).tpm = {sprintf('%sTPM.nii,2',tpm_dir)};
    matlabbatch{6}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{6}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(3).tpm = {sprintf('%sTPM.nii,3',tpm_dir)};
    matlabbatch{6}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{6}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(4).tpm = {sprintf('%sTPM.nii,4',tpm_dir)};
    matlabbatch{6}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{6}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(5).tpm = {sprintf('%sTPM.nii,5',tpm_dir)};
    matlabbatch{6}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{6}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(6).tpm = {sprintf('%sTPM.nii,6',tpm_dir)};
    matlabbatch{6}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{6}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{6}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{6}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{6}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{6}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{6}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{6}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{6}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{6}.spm.spatial.preproc.warp.write = [0 1];
    matlabbatch{7}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{7}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{7}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{7}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
    matlabbatch{7}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{7}.spm.spatial.normalise.write.woptions.prefix = 'w';
    matlabbatch{8}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{8}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
    matlabbatch{8}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{8}.spm.spatial.normalise.write.woptions.vox = [0.8 0.8 1.2];
    matlabbatch{8}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{8}.spm.spatial.normalise.write.woptions.prefix = 'w';
    matlabbatch{9}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{9}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{9}.spm.spatial.smooth.dtype = 0;
    matlabbatch{9}.spm.spatial.smooth.im = 0;
    matlabbatch{9}.spm.spatial.smooth.prefix = 's';
    
    fprintf(fid,'Preprocess Pieline- Start Time %s\n',datestr(clock));
    spm_jobman('run', matlabbatch);
    fprintf(fid,'End Time %s\n',datestr(clock));
    toc;
    a = toc;
    fprintf(fid,'Time Elapsed: %2f mins\n',(a/60));
    fprintf(fid, [repmat('-',1,50) '\n\n']);
%     fprintf(fid,'Reallignment- Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{1});
%     spm_jobman('run', matlabbatch{2});
%     fprintf(fid,'Reallignment- Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{3});
%     fprintf(fid,'Reallignment- End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'Slice Time Correction - Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{4});
%     fprintf(fid,'Slice Timne Correction - End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'Coregistration - Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{5});
%     fprintf(fid,'Coregistration - End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'Segmentaiton - Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{6});
%     fprintf(fid,'Segmentaiton - End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'Normalization of Functional Data - Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{7});
%     fprintf(fid,'Normalization of Functional Data - End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'Normalization of Anatomical Data - Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{8});
%     fprintf(fid,'Normalization of Anatomical Data - End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'Smoothing - Start Time %s\n',datestr(clock));
%     spm_jobman('run', matlabbatch{9});
%     fprintf(fid,'Smoothing - End Time %s\n\n',datestr(clock));
%     
%     fprintf(fid,'End Time %s\n',datestr(clock))
%     toc
%     a = toc
%     fprintf(fid,'Time Elapsed: %2f mins\n',(a/60))
%     fprintf(fid, [repmat('-',1,50) '\n\n'])

end

