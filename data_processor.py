import os 
from os.path import join
import pandas as pd
import numpy as np

log_dir = "/home/paradeisios/Desktop/Individual_Logs/"
output_dir = "/home/paradeisios/Desktop/"

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

###############################################################################              
def reaction_time_df(log):
    # Extract feedback and response from key press lines in the log file
    data          =[]
    condition     =[]
    responses     =[]
    corrects      =[]
    response_time =[]
    probe_time    =[]
    reaction_time =[]
    subject       =[]

    with open(log,"r") as file:
        for line in file:
            data.append(line)

    for ii in range(len(data)):

        if ('MINEOTHER' in data[ii]) and ('Finished' in data[ii]): # Get file line with response data
            summ_line = data[ii].replace("\n","").rsplit("\t")

            response = summ_line[-1].rsplit(" ")[-1]
            responses.append(response) # Extract subject response(1=Mine, 2=Other)

            feedback = summ_line[-1].rsplit(" ")[0].rsplit("-")[-1]
            condition.append(feedback) # Extract feedback condition


            if (feedback == 'SYNC' and response == '1') or (feedback == 'OSYNC' and response == '2') :
                corrects.append("correct")
            else:
                corrects.append("wrong")

            response_time.append((data[ii-2]).split("\t")[0]) # Extract response time

            index_minus = 0 # Move backwards and find when probing was presented
            while True:
                if 'Stim' in data[ii-2-index_minus]:
                    probe_time.append((data[ii-2-index_minus]).rsplit("\t")[0])
                    break
                else:
                    index_minus = index_minus + 1

            reaction_time = [x1 - x2 for (x1, x2) in zip(np.float_(response_time), np.float_(probe_time))] 

    subject = [mapping[log[-12:-7]] for i in range(len(reaction_time))]


    results = pd.DataFrame()
    results['Subject'] = subject
    results['Condition']= condition
    results['Response'] = responses
    results['Corrects'] = corrects
    results['RT'] = reaction_time

    return results

##########################################################################

df = []
for log in os.listdir(log_dir):
    if log.endswith("log"):
        results = reaction_time_df(join(log_dir,log))
        df.append(results)
df = pd.concat(df)

df.to_csv(join(output_dir,"HEART_reaction_time.csv"),index = False, header=True)


            
