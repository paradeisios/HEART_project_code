# Boulakis Paradeisios ALexandros 
# 13/12/2020 

#  Create the onsets of the responses of the subjects to be used
#  as the timing of the event onset in the fmri first level design
import numpy as np
import scipy.io as sio
from utils.get_feedback_blocks import get_feedback_blocks

def get_response_onsets(mat_file):
    
    """
    A function that extracts MINE/OTHER responses for the HEART experiment.
    The function estimates when the blocks started based on the get_feedback_block
    function. Then,based on the indexes of the final scan of the block, it finds 
    whether the subject responded as mine or other.
    
    INPUT: mat_file (mat) ----  Mat file containg experiment data
    
    OUTPUT: onsets(dict) ---- Dictionary with the number of the 
    subject and the 2 onset lists, one for MINE responses and one 
    for OTHER.
    
    """
    
    mat = sio.loadmat(mat_file)
    blocks = get_feedback_blocks(mat_file) 
    onsets = np.concatenate((blocks["sync_onset"]+blocks["sync_duration"],
                             blocks["async_onset"]+blocks["async_duration"]),
                             axis=None)
    mine_onset = []
    other_onset = []            
    for onset in onsets:
        if mat["response"][onset-1] in 'Mine   ' :
            mine_onset.append(onset)
        else:
            other_onset.append(onset)

    onsets = {"name":mat_file[-12:-7],
              "mine_onsets":np.sort(np.array(mine_onset)),
              "other_onsets":np.sort(np.array(other_onset))}


    return onsets
