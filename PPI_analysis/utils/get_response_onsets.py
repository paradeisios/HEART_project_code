# Boulakis Paradeisios ALexandros 
# 13/12/2020 

#  Create the onsets of the responses of the subjects to be used
#  as the timing of the event onset in the fmri first level design


def get_response_onsets(log):
    
    """
    A function that loops over a single suvbject log file 
    from the HEART recordings and returns the timing of the 
    decision key presses (whether response was MINE or OTHER)
    
    INPUT: log (log file) ----  Log file containg experiment data
    
    OUTPUT: onsets(dict) ---- Dictionary with the number of the 
    subjectand the 2 onset lists, one for MINE responses and one 
    for OTHER.
    
    """
    with open(log,"r") as log_file:

        mine_onsets = []
        other_onsets = []
        for line in log_file:
            line = line.replace("\n","").split("\t")
            if(line[2]=="Keypress: 1"):
                mine_onsets.append(float(line[0].replace(" ","")))
            elif(line[2]=="Keypress: 2"):
                other_onsets.append(float(line[0].replace(" ","")))
            
        onsets = {"subject":log[-12:-7],
                    "mine_onset":mine_onsets,
                    "other_onset":other_onsets}
            
        return onsets
