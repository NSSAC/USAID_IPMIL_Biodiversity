###########################################################################
# Preprocessing vectors for computing Boyce index in R.
# AA
###########################################################################

import pandas as pd
from pdb import set_trace

# get presence probabilities
predictedPresence=pd.read_excel('input/predicted_presence.xlsx')[['X','Y','Logistic prediction','Test or train']]
predictedPresence=predictedPresence.rename(columns={'X':'x','Y':'y','Logistic prediction':'p','Test or train':'mode'})
# create observations column from presence data
predictedPresence['obs']=predictedPresence.p # =1
predictedPresence['ptest']=predictedPresence['mode'].str.contains('test')*predictedPresence.p
predictedPresence=predictedPresence.drop('mode',axis=1)

# get pseudo absence probabilities
psuedoAbsence=pd.read_excel('input/pseudo_absences.xlsx',sheet_name='Sheet1')[['x','y','logistic']]
psuedoAbsence=psuedoAbsence.rename(columns={'logistic':'p'})
# create observations column from absence data
psuedoAbsence['obs']=0
psuedoAbsence['ptest']=0

# append and sort by lat-lon
dataForR=pd.concat([predictedPresence,psuedoAbsence],sort=True).sort_values(['x','y'])

# dump to csv
dataForR.to_csv('observations_predictions.csv',index=False)
