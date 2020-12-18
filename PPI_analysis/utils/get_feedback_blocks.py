# Boulakis Paradeisios ALexandros 
# 13/12/2020 

import scipy.io as sio
import numpy as np

def get_feedback_blocks(mat_file):
    
    '''
    A function that loops over a single suvbject matfile from the HEART 
    recordings, containing the task tyoe and the feedback condition per fMRI 
    scan and returns the onset and the duration of the feedback block (SYNC /
    ASYNC)

    INPUT: log (mat_file) ---- Mat file containg experiment data

    OUTPUT: onsets(dict) ---- Dictionary with the number of the subject,
    2 onset lists and 2 duration lists, one for each feedback condition.
    
    
    '''


    mat = sio.loadmat(mat_file,chars_as_strings=True,variable_names="condition")
    condition = mat["condition"].reshape(-1,1)
    condition = np.concatenate((condition,np.zeros((1,1))),axis=0)
    sync_onset=[]
    sync_duration=[]
    
    async_duration=[]
    async_onset=[]
    
    
    for index in range(len(condition)):
    
       
        if (condition[index] == "SYNC ") and (condition[index-1]!="SYNC "):
            sync_onset.append(index+1)
        
            count = 0
            position = index
            while(condition[position] == "SYNC "):
                count+=1
                position+=1
            sync_duration.append(count-1)
       
        if (condition[index] == "OSYNC") and (condition[index-1]!="OSYNC"):
            async_onset.append(index+1)
        
            count = 0
            position = index
            while(condition[position] == "OSYNC"):
                count+=1
                position+=1
            async_duration.append(count-1)
        
    blocks = {"name":mat_file[-12:-7],
          "sync_onset":np.array(sync_onset),
          "sync_duration":np.array(sync_duration),
          "async_onset":np.array(async_onset),
          "async_duration":np.array(async_duration)}
    
    return blocks

