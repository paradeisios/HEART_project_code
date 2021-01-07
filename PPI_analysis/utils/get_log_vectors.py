#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan  7 14:25:00 2021

@author: paradeisios
"""

import numpy as np

def get_log_vectors(log):
    
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

