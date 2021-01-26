import pandas as pd
import numpy as np
from scipy.io import savemat
import os

def csv_to_spm_vectors(csv_path):

    for root, dirs, files in os.walk(csv_path):
        for name in files:
            if name.endswith(".csv"):
                csv_file = os.path.join(root, name)

                df = pd.read_csv(csv_file,delimiter=";")
                sub_name = csv_file[-10:-4]

                cleanup = ['onsets','durations']
                for key in cleanup:
                    for ii,_ in enumerate(df[key]):
                        string = df[key][ii].replace("\n","").replace(",","")[1:-1].split(" ")
                        string = list(filter(None, string))
                        array = np.array(string,dtype=np.float64)
                        df[key][ii]=array

                new_dict = {"sub":sub_name,
                    "sync_onset":df["onsets"][0],
                    "osync_onset":df["onsets"][1],
                    "mine_onset":df["onsets"][2],
                    "other_onset":df["onsets"][3],
                    "sync_duration":df["durations"][0],
                    "osync_duration":df["durations"][1]}
                
                output_name = csv_path + sub_name + "_vectors.mat"
                savemat(output_name,{"vectors":new_dict})