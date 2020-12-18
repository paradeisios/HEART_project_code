# Boulakis Paradeisios ALexandros 
# 13/12/2020 

#  Create the onsets of the responses of the subjects to be used
#  as the timing of the event onset in the fmri first level design
import numpy as np
import scipy.io as sio
from utils.get_feedback_blocks import get_feedback_blocks

def get_response_onsets(mat_file):
    
    """
    A function that loops over a single suvbject log file 
    from the HEART recordings and returns the timing of the 
    decision key presses (whether response was MINE or OTHER)
    
    INPUT: log (log file) ----  Log file containg experiment data
    
    OUTPUT: onsets(dict) ---- Dictionary with the number of the 
    subjectand the 2 onset lists, one for MINE responses and one 
    for OTHER.
    
    """
    
    mat_file = mat_file
    mat = sio.loadmat(mat_file)
    blocks = get_feedback_blocks(mat_file)
    onsets = np.concatenate((blocks["sync_onset"]+blocks["sync_duration"],
                             blocks["async_onset"]+blocks["async_duration"]),
                             axis=None)
    mine_onset = []
    other_onset = []            
    for onset in onsets:
        if mat["response"][onset-1] == "Mine ":
            mine_onset.append(onset)
        else:
            other_onset.append(onset)

    onsets = {"name":mat_file[-12:-7],
              "mine_onsets":np.sort(np.array(mine_onset)),
              "other_onsets":np.sort(np.array(other_onset))}


    return onsets
