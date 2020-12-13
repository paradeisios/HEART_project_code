#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Dec 13 17:45:52 2020

@author: paradeisios
"""

import os 
from os.path import join
import scipy.io as sio
import numpy as np

from utils import get_response_onsets, get_feedback_blocks

log_dir =   "/home/paradeisios/Desktop/logs/"
mat_dir =   "/home/paradeisios/Desktop/sub-01/"
onset_dir = "/home/paradeisios/Desktop/onsets/"
feedback_dir = "/home/paradeisios/Desktop/feedback/"

mapping = dict(GS248="sub_01",
               CM249="sub_02",
               WT250="sub_03",
               XA251="sub_04",
               GS252="sub_05",
               LT253="sub_06",
               MU254="sub_07",
               CG255="sub_08",
               PJ256="sub_09",
               EM257="sub_10",
               YJ258="sub_11",
               GA259="sub_12",
               AF260="sub_13",
               MT261="sub_14",
               CL262="sub_15",
               CG263="sub_16",
               TW265="sub_17",
               BP267="sub_18",
               CS268="sub_19",
               TC269="sub_20")


### Loop through folder with logfiles and extract onset times for the response (MINE / OTHER) events
for log in os.listdir(log_dir):
    if log.endswith(".log"):
        
        log_file = join(log_dir, log)
        output_name = join(onset_dir, mapping[log[:5]]+ "_response_onsets.mat")
        
        onsets = get_response_onsets(join(log_dir,log))
        sio.savemat(output_name,{"response_onsets":onsets})

### Loop through folder with mat files and extract onsets and durations for each of the two
### feedback conditions (Synchronous / Asynchronous)

for mat in os.listdir(mat_dir):
    
    if mat.endswith(".mat"):
        mat_file = sio.loadmat(join(mat_dir,mat))
        
        if "task_type" in mat_file.keys():
            if 'MINEOTHER' in mat_file["task_type"]:

                blocks = get_feedback_blocks(join(mat_dir,mat))
                output_name = join(feedback_dir, mapping[mat[-9:-7]+mat[-12:-9]]+ "_feedback.mat")
                sio.savemat(output_name,{"feedback":blocks})
            
            
    