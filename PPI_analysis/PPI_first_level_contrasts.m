subjects = [01 02 03 06 07 08 09 10 11  13 14 15 16 17 18 19 20];
mat_path = '/home/rantanplan/Documents/Paris/HEART_PPI/output/first_level/';
for subject = subjects
    
    sub_name =['sub-',num2str(subject, '%02d')];
    fprintf(['Creating  Positive Contrasts for Subject :', num2str(subject), '\n'])
    
    matlabbatch = [];
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(strcat(mat_path,sub_name,'/SPM.mat'));
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Positive Effect of Feedback';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Negative Effect of Feedback';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Positive Effect of Response';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.convec = [0 0 1 -1];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Positive Effect of Response';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.convec = [0 0 -1 1];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.delete = 1;
    spm_jobman('run',matlabbatch);
end