   
# =============================================================================
# HAVE ALL LOG FILES IN THE SAME FOLDER    
# =============================================================================

import os
import pandas as pd

def  processor(filename):
   
    ####### open  file and get lines with condition and response key #######
    
    file = open(filename,'r')
    data = []
    
    for line in file :
        if ('MINEOTHER' in line) and ('Finished' in line):
            data.append(line)
    file.close()
    
    ###### break into conditions and responses   #######     
    
    condition = []
    response = []
    corrects = []
    for line in data:
        x = line.split()
        condition.append(x[2])
        response.append(x[6])
     ##### get correct key responses
        if (x[2] == 'MINEOTHER-SYNC' and x[6] == '1') or (x[2] == 'MINEOTHER-OSYNC' and x[6] == '2') :
            corrects.append(1)
        else:
            corrects.append(0)
    
    #print(condition);print(len(condition)); print(response);print(len(response))
    
    ####### transform condition for dataframe #######
                  
    for i in range(len(condition)):
        if condition[i] == 'MINEOTHER-SYNC':
            condition[i] = 1
        else:
            condition[i] = 2
            
    #print(condition);print(len(condition)) 
     
        
        
        
    ###################################################################
        
    ####### open the file
    file = open(filename,'r')
    data = []
    for line in file:
        data.append(line)
    #print(data)
    file.close()
    
    ####### get the line set with the last stimulus and the response
    
    times = []
    for i in range(len(data)) :
        if ('MINEOTHER' in data[i]) and ('Finished' in data[i]):
            #print(data[i])
            times.append(data[i-2])
        
        
            index_minus = 0
            while True:
                if 'Stim' in data[i-2-index_minus]:
                    times.append(data[i-2-index_minus])
                    break
                else:
                    index_minus = index_minus + 1
                    
    ###### separate and take only times
    
    times_present = []
    times_response = []
    
    for i in range(len(times)):
        x = times[i].rsplit()
        if i%2 == 0:
            times_response.append(float(x[0]))
        else:
            times_present.append(float(x[0]))
        
    ##### calculate reaction times    
    reaction_time = [x1 - x2 for (x1, x2) in zip(times_response, times_present)]  

     
            
    
    ##### names
    
    names = []
    for item in range(len(reaction_time)):
        name = list(filename)
        name = 's'+ str(int(''.join(name[2:5])) - 247)
        names.append(name)
    
    
    ##### individual dataframe
    final_results = {}
    final_results['Subject'] = names
    final_results['Condition']= condition
    final_results['Response'] = response
    final_results['Reaction_Time'] = reaction_time
    final_results['Corrects'] = corrects
    
  
        
    df_results = pd.DataFrame(final_results)
    return(df_results)   


####### loop through folder, transform into dataframe, concatenate and export #######
def analysis(dirname):
    
    results = []
    for name in os.listdir(dirname):
        results.append(processor(name))
    global finals
    finals = pd.concat(results)
    finals['Response'] = finals['Response'].str.replace('Timeout', '')
    
    finals.to_csv(r'C:\Users\User\Documents\Academia\Thesis\Methods\Behaviour\Individual_Logs\heart_behav_data.csv', index = False, header=True)
    print(finals)
    

        
        
    

