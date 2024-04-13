#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Plot natural circulation loop coupled results
- plot figures of interests
"""

import numpy as np
import matplotlib.pyplot as plt
import sys

fsize = [13.5,8.75]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 34})


L_over = 1.42 # m, length of overlapping domain component

dP_ss = 12.07
q_heat = 7.49     # kW

v_ss = 0.23352091314745


# create separate figure for each Q
f3=plt.figure(1,figsize=fsize) # plot 

fname_coupled ='/coupled_nek_master_out_ExternalApp0_csv.csv'
fname_iter    ='/iterations.txt'
dname         = '../results/natCircLoop/Overlapping/'
dname_save    = '../figures/natCircLoop/'

# initialize lists
Psum   = []
labels = []


# dirs to loop through
fnames = ['Q1_v15','Q1_v11','Q1_v12','Q1_v18','Q1_v6','Q1_v17','Q1_v13','Q1_v14','Q1_v16']

# tolerance = 1e-3*u_steady
for i,fname in enumerate(fnames):

    if fname=='Q1_v15':
        N_sum = 60 #57
    elif fname=='Q1_v11':
        N_sum = 58 #54
    elif fname=='Q1_v12':
        N_sum = 54 #45
    elif fname=='Q1_v18':
        N_sum = 48 #44 
    elif fname=='Q1_v6':
        N_sum = 24 #24
    elif fname=='Q1_v17':
        N_sum = 44 #44 
    elif fname=='Q1_v13':
        N_sum = 45 #45 
    elif fname=='Q1_v14':
        N_sum = 57 #45 
    elif fname=='Q1_v16':
        N_sum = 60 #55 
    else:
        sys.exit('no N_sum choice available for fname, in overlap')
        
    
    data = np.genfromtxt(dname+fname+fname_coupled, delimiter=',',names=True)
    
    time = data['time']

    v_init = data['toNekRS_velocity'][0]
    labels.append(v_init/v_ss)

    Piter = np.genfromtxt(dname+fname+fname_iter, delimiter=' ')[:,15]    
    Psum.append(np.sum(Piter[:N_sum]))

########################################################################################
# plotting settings
plt.figure(1)
plt.plot(labels,Psum,linewidth=5,marker='.',markersize=20,color='tab:red',label='SAM-NekRS overlapping')

plt.ylabel('Total NekRS P Iterations')
plt.xlabel(r'$ \mathdefault{U}_{\mathdefault{initial}} \, \, / \, \mathdefault{U}_{\mathdefault{steady}}$',fontsize=38)

plt.grid()
plt.xlim([0.9,1.1])
plt.ylim([-5,160])
plt.legend(loc=2,fontsize=28,framealpha=1)
plt.tight_layout()
plt.savefig(dname_save + 'NatCircLoop_Overlap_Piterations.eps')