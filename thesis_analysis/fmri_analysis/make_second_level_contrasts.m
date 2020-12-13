function make_second_level_contrasts(contrast_map,path_to_mats,negative)
% Create second level contrasts for the HEART data

% Args : Path_to_mats(string) - Design matrix location
%        Contrast_map(struct) - A struct with two fields(contrast name and
%                               contrast name file for the contrasts created at 
%                               the first level
if negative == 1
    contrasts = length(contrast_map);
else
    contrasts = 10;
end
for ii = 1:contrasts
    mat_path = [path_to_mats contrast_map(ii).name '/SPM.mat'];
    matlabbatch{1}.spm.stats.con.spmmat = {mat_path};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = [contrast_map(ii).name];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.delete = 0;
    spm_jobman('run', matlabbatch);
end
