#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 14:25:00 2021

@author: paradeisios
"""

import numpy as np

def get_log_vectors(log):

    """
    A function that extracts MINE/OTHER responses and SYNC/ASYNC blocks onsets 
    and durations from the HEART logfiles.
    i. A reference is specified as the start of the experiment. The reference is the first Keypress: 5
    
    ii. To find MINE/OTHER response times, the function loops over the logfile and finds whether the 
    subject pressed Keypress: 1 (MINE) or Keypress: 2 (OTHER).
    
    iii. To find SYNC/ASYNC block onsets, the function loops over the logfile and finds the first Keypress: 5 in the block,
    by finding the onset timing of the block (specified in the logfile as Started) and going forwards, searching for the 
    first keypress 5.
    
    iv. To find SYNC/ASYNC duration, the function loops over the logfile and finds the final Keypress: 5 in the block,
    by finding the last timing of the block (specified in the logfile as Finished) and going backwards, searching for the 
    first keypress 5. Then the onsets are substracted from the endings of the block
    
    The reference is substracted from both MINE/OTHER and SYNC/ASYNC vectors.
    
    INPUT: Log_file (Log) ----  Log file containg experiment data
    
    OUTPUT: vectors(dict) ----Dictionary with the number of the subject and  the 2 onset lists 
    for MINE/OTHER responses,  and 2 onset lists and 2 duration lists for SYNC/ASYNC blocks.
    """

    
    # Get the data from the log file and clean them a bit
    data = []
    with open(log) as file:
        keep=False
        for line in file:
            if ("INSTRUCTION (56) Finished" in line):
                keep = True
            if keep:
                data.append(line.split("\t"))
            
    reference = None #specify beginning of the experiment (first keypress: 5)
    
    for line in data:
        line[0] = float(line[0].replace(" ",""))
        line[-1] = line[-1].replace("\n","")
    
        if (reference == None) and ('Keypress: 5' in line):
            reference = line[0]
    
    ##########################################################################
    ############################### GET RESPONSE ONSETS ######################
    mine = []
    other = []
    
    for ii in range(len(data)-2):
        
        # finished is a conditional to make sure the button press occurs after
        # the probe and is not a random mid-block misclick
        
        if ("Keypress: 1" in data[ii] ) and ("Finished" in data[ii+2][-1]):
            mine.append(data[ii][0])
        elif ("Keypress: 2" in data[ii] ) and ("Finished" in data[ii+2][-1]):
            other.append(data[ii][0])
    
    mine = np.array(mine) - reference
    other= np.array(other) - reference
    
    ##########################################################################
    ######################## GET FEEBACK BLOCK ONSET AND END #################
    
    sync_onset   = []
    sync_ending  = []
    async_onset  = []
    async_ending = []
    
    # first get ONLY onsets
    for ii in range(len(data)):
        
        # find line in logfiles that indicates block ONSET
        if ("Started" in data[ii][-1]) and ("INSTRUCTION" not in data[ii][-1]):
            
            # while searching, the script will look forward an index to find 
            # the first keypress (indicating the onset of the block)
            if "-SYNC" in data[ii][-1]:
                index = ii
                while "Keypress: 5" not in data[index]:
                    index+=1
                sync_onset.append(data[index][0])
            
            elif "-OSYNC" in data[ii][-1]:
    
                index = ii
                while "Keypress: 5" not in data[index]:
                    index+=1
                async_onset.append(data[index][0])
        
        # find line in logfiles that indicates block END
        if ("Finished" in data[ii][-1]) and ("INSTRUCTION" not in data[ii][-1]) :
            
            # while searching, the script will look backward an index to find 
            # the first keypress (indicating the onset of the block)
            if "-SYNC" in data[ii][-1]:
                index = ii
                while "Keypress: 5" not in data[index]:
                    index-=1
                sync_ending.append(data[index][0])
        
            elif "-OSYNC" in data[ii][-1]:
                index = ii
                while "Keypress: 5" not in data[index]:
                    index-=1
                async_ending.append(data[index][0])
    
    sync_onset = np.array(sync_onset)-reference
    async_onset = np.array(async_onset)-reference
    sync_ending = np.array(sync_ending)-reference
    async_ending = np.array(async_ending)-reference
    
    sync_duration = np.array(sync_ending) - np.array(sync_onset) 
    async_duration = np.array(async_ending) - np.array(async_onset)
    
    vectors = {"name"           : log[2:5]+log[:2],
               "sync_onset"     : sync_onset,
               "sync_duration"  : sync_duration,
               "async_onset"    : async_onset,
               "async_duration" : async_duration,
               "mine"           : mine,
               "other"          : other}
    
    return vectors

