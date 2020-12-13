% just some clearning / init
clc;clear
spm fmri
addpath /home/rantanplan/Documents/Paris/heart-project-code/fmri/fmri_pipeline/fmri_code
subjects = [01 02 03 06 07 08 09 10 11  13 14 15 16 17 18 19 20];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Vector Creation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vector_dir = '/home/rantanplan/Documents/Paris/heart-project-code/fmri/heart_vectors/';
create_vectors(subjects,vector_dir)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define necessary variables

path_to_data  = '/home/rantanplan/Documents/Paris/heart_img_data/'; %path to img in bids format
TR =  2.14;
NSLICE = 44;
SLICE_ORDER = [1:44];
tpm_dir = '/home/rantanplan/Documents/spm12/tpm/';

preprocess(subjects,path_to_data,tpm_dir,TR,NSLICE,SLICE_ORDER)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First Level Analysis %%%%%%%%%%%%%%%%%%%%%%

%Define needed variables for first level analysis

path_to_data  = '/home/rantanplan/Documents/Paris/heart_img_data/'; %path to img data
output_dir = '/home/rantanplan/Documents/Paris/heart-project-code/fmri/fmri_pipeline/heart_output/1st_Order/'; %path to make folders with results
vector_dir = '/home/rantanplan/Documents/Paris/heart-project-code/fmri/heart_vectors/'; %path with vectors for the factorial design
negative = 1; % make negative contrasts - change to 0 for only pos

%Create first level matrix
make_first_level_matrix(subjects,path_to_data, output_dir, vector_dir)
%Create first level contrasts
make_first_level_contrasts(subjects,output_dir, negative)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second Level Analysis %%%%%%%%%%%%%%%%%%%%%

%Define needed variables for first level analysis
contrast_map = struct(); % tracker of contrasts names and filenames
contrast_map(1).name = 'Positive Effect of Feedback';contrast_map(1).file = 'con_0001.nii';
contrast_map(2).name = 'Positive Effect of Response';contrast_map(2).file = 'con_0002.nii';
contrast_map(3).name = 'Positive Effect of Interaction';contrast_map(3).file = 'con_0003.nii';
contrast_map(4).name = 'Simple Synch(Pos)';contrast_map(4).file = 'con_0004.nii';
contrast_map(5).name = 'Simple Asynch(Pos)';contrast_map(5).file = 'con_0005.nii';
contrast_map(6).name = 'Simple Mine(Pos)';contrast_map(6).file = 'con_0006.nii';
contrast_map(7).name = 'Simple Other(Pos)';contrast_map(7).file = 'con_0007.nii';
contrast_map(8).name = 'Main Effect of Feedback';contrast_map(8).file = 'ess_0008.nii';
contrast_map(9).name = 'Main Effect of Response';contrast_map(9).file = 'ess_0009.nii';
contrast_map(10).name = 'Main Effect of Interaction';contrast_map(10).file = 'ess_0010.nii';
contrast_map(11).name = 'Negative Effect of Feedback';contrast_map(11).file = 'con_0011.nii';
contrast_map(12).name = 'Negative Effect of Response';contrast_map(12).file = 'con_0012.nii';
contrast_map(13).name = 'Negative Effect of Interaction';contrast_map(13).file = 'con_0013.nii';
contrast_map(14).name = 'Simple Synch(Neg)';contrast_map(14).file = 'con_0014.nii';
contrast_map(15).name = 'Simple Asynch(Neg)';contrast_map(15).file = 'con_0015.nii';
contrast_map(16).name = 'Simple Mine(Neg)';contrast_map(16).file = 'con_0016.nii';
contrast_map(17).name = 'Simple Other(Neg)'; contrast_map(17).file = 'con_0017.nii';


path_to_contrasts = '/home/rantanplan/Documents/Paris/heart-project-code/fmri/fmri_pipeline/heart_output/1st_Order'; %path to first level contrasts
path_to_whole_brain_dir = '/home/rantanplan/Documents/Paris/heart-project-code/fmri/fmri_pipeline/heart_output/2nd_Order/Whole_Brain/';
path_covariate_dir = '/home/rantanplan/Documents/Paris/heart-project-code/fmri/fmri_pipeline/heart_output/2nd_Order/covariates/'; %path to make folders with results

negative = 1; % include negative contrasts

%Create Second Level Matrixes for each contrasts
make_second_level_matrix(contrast_map, subjects, path_to_contrasts,path_to_whole_brain_dir,negative)
%Create Second Level Contrasts
make_second_level_contrasts(contrast_map,path_to_whole_brain_dir,negative)

% Create second level covariate contrasts
covariates = [0.5 0.695652174 0.47826087 0.28 0.72 0.56 0.333333333 0.72 0.72 0.407407407 0.7 0.545454545 0.64 0.44 0.458333333 0.608695652 0.571428571];

make_second_level_covar_matrix(contrast_map, subjects, path_to_contrasts,path_covariate_dir,covariates, negative)
make_second_level_contrasts(contrast_map,path_covariate_dir,negative)
