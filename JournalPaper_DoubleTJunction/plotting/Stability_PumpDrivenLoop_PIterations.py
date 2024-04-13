#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Plot natural circulation loop coupled results
- plot figures of interests
"""

import numpy as np
import matplotlib.pyplot as plt
import sys

fsize = [13.5,8]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 30})

v_ss = 0.2134 # m/s

# create separate figure for each Q
f1=plt.figure(1,figsize=fsize) # plot 
f2=plt.figure(2,figsize=fsize) # plot 
f3=plt.figure(3,figsize=fsize) # plot 

fname_coupled = '/coupled_nek_master_out_ExternalApp0_csv.csv'
fname_iter    = '/iterations.txt'
dname         = '../results/pumpLoop/'
dname_save    = '../figures/pumpLoop/'

# initialize lists
Psum_over   = []
Psum_sep   = []
labels_over = []
labels_sep = []

# dir names
dname_sep  = dname + 'Decomposition/'
dname_over = dname + 'Overlapping/'

fnames_sep  = ['ic_v8','ic_v12','ic_v13','ic_ss','ic_v3','ic_v2','ic_v11']
fnames_over = ['ic_v6','ic_v8','ic_v12','ic_v13','ic_ss','ic_v3','ic_v2','ic_v11','ic_v10']


for i,fname in enumerate(fnames_sep):

    if fname=='ic_v8':
        N_sum = 899
    elif fname=='ic_v12':
        N_sum = 747
    elif fname=='ic_v13':
        N_sum = 501 
    elif fname=='ic_ss':
        N_sum = 76 
    elif fname=='ic_v3':
        N_sum = 408 
    elif fname=='ic_v2':
        N_sum = 842 
    elif fname=='ic_v11':
        N_sum = 1093  # dt half of others
    else:
        sys.exit('no N_sum choice available for fname, in Separate')
        
        
    # separate domain
    data = np.genfromtxt(dname_sep+fname+fname_coupled, delimiter=',',names=True)
    
    time = data['time']
    v_init = data['toNekRS_velocity'][0]
               
    labels_sep.append(v_init/v_ss)

    Piter = np.genfromtxt(dname_sep+fname+fname_iter, delimiter=' ')[:,15]    
    Psum_sep.append(np.sum(Piter[:N_sum]))

for i,fname in enumerate(fnames_over):

    # overlapping domain
    N_sum = 5

    if fname=='ic_v6':
        N_sum = 6
    elif fname=='ic_v8':
        N_sum = 6
    elif fname=='ic_v12':
        N_sum = 5
    elif fname=='ic_v13':
        N_sum = 4 
    elif fname=='ic_ss':
        N_sum = 3 
    elif fname=='ic_v3':
        N_sum = 4 
    elif fname=='ic_v2':
        N_sum = 5 
    elif fname=='ic_v11':
        N_sum = 4  # dt half of others
    elif fname=='ic_v10':
        N_sum = 6  # dt half of others
    else:
        sys.exit('no N_sum choice available for fname, in Overlap')


    data = np.genfromtxt(dname_over+fname+fname_coupled, delimiter=',',names=True)
    
    time = data['time']
    v_init = data['toNekRS_velocity'][0]
               
    labels_over.append(v_init/v_ss)

    Piter = np.genfromtxt(dname_over+fname+fname_iter, delimiter=' ')[:,15]    
    Psum_over.append(np.sum(Piter[:N_sum]))

########################################################################################
# plotting

plt.figure(1)
plt.plot(labels_over,Psum_over,linewidth=5,marker='.',markersize=20,label='SAM-NekRS overlapping',color='tab:red')

plt.ylabel('Total NekRS P Iterations',fontsize=30)
plt.xlabel(r'$ \mathdefault{U}_{\mathdefault{initial}} \, \, / \, \mathdefault{U}_{\mathdefault{steady}}$',fontsize=40)

plt.grid()
plt.legend(loc=2,fontsize=25,framealpha=1)
plt.xlim([0,2.025])
plt.ylim([-0.5,30])
plt.xticks(np.arange(0, 2.25, 0.25)) # set x label's ticks
plt.tight_layout()
plt.savefig(dname_save + 'PumpLoop_overlapPiters.eps')


plt.figure(2)
plt.plot(labels_sep,Psum_sep,linewidth=5,marker='.',markersize=20,label='SAM-NekRS decomposition',color='tab:green')
plt.plot(labels_over,Psum_over,linewidth=5,marker='.',markersize=20,label='SAM-NekRS overlapping',color='tab:red')

plt.ylabel('Total NekRS P Iterations',fontsize=30)
plt.xlabel(r'$ \mathdefault{U}_{\mathdefault{initial}} \, \, / \, \mathdefault{U}_{\mathdefault{steady}}$',fontsize=40)

plt.grid()
plt.legend(loc=2,fontsize=25,framealpha=1)
plt.xlim([0,2.025])
plt.ylim([-200,6100])
plt.xticks(np.arange(0, 2.25, 0.25)) # set x label's ticks
plt.tight_layout()
plt.savefig(dname_save + 'PumpLoop_bothPiters.eps')
