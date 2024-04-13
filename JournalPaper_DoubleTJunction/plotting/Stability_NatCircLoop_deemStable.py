#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Plot natural circulation loop coupled results
- plot figures of interests
"""

import numpy as np
import matplotlib.pyplot as plt

plt.rcParams.update({'font.size': 13})


fsize = [10,8]

L_over = 1.42 # m, length of overlapping domain component

dP_ss = 12.07
inletP_ss = 15.018842197261

v_ss = 0.23352091314745

mdot_nek = 0.532  # kg/s
mdot_sam = 0.5127 # kg/s
q_heat = 7.49     # kW

# tol = 5e-4 # stable tolerance
tol = 1e-3*v_ss # stable tolerance

f2=plt.figure(2,figsize=fsize) # plot 
f3=plt.figure(3,figsize=fsize) # plot 

fname_coupled ='/coupled_nek_master_out_ExternalApp0_csv.csv'

dname         = '../results/natCircLoop/Overlapping/'

fnames = ['Q1_v15','Q1_v11','Q1_v12','Q1_v18','Q1_v6','Q1_v17','Q1_v13','Q1_v14','Q1_v16']

for i,fname in enumerate(fnames):


    data = np.genfromtxt(dname+fname+fname_coupled, delimiter=',',names=True)
    
    time = data['time']
               
    dP_init = data['coupled_nekdP'][0]*L_over    
        
    plt.figure(3)
    plt.plot(np.arange(len(time)),data['p_in']/1e6/inletP_ss, \
              label=fname+r', $\frac{dP_i}{dP_s}$'+' = {:.2f}'.format(dP_init/dP_ss), \
              linestyle = '-')     


    vel  = data['toNekRS_velocity']
    v_init = data['toNekRS_velocity'][0]
    
    dt = data['time'][1]
    
    dvdt_old = 1e9
    dvdt_new = 0.0
    
    for k in range(len(time)-1):
        
        dvdt_new = np.abs(vel[k+1]-vel[k])/dt   
        # print(dv)
        
        if (np.abs(dvdt_new - dvdt_old)) < tol:
            print(fname, 'dvdt =',dvdt_new, 'time =',time[k], 'N_sum =',k)
            break
        
        dvdt_old = dvdt_new
        
        v_init = data['toNekRS_velocity'][0]

    plt.figure(2)
    plt.plot(np.arange(len(time)),data['toNekRS_velocity']/v_ss, \
              # label=fname+r', $\frac{dP_i}{dP_s}$'+' = {:.2f}'.format(dP_init/dP_ss), \
              label=fname+r', $\frac{v_i}{v_s}$'+' = {:.2f}'.format(v_init/v_ss), \
              linestyle = '-')     
        
    
########################################################################################
# plotting settings
plt.figure(3)
plt.ylabel(r'$\frac{Interface \, \, P}{Steady \, \, P}$',rotation=0,labelpad=40,fontsize=18)
plt.xlabel('Time step')
plt.grid()
plt.xlim([0,30])
plt.legend(loc=1)
plt.title('Driving Heat = '+str(q_heat)+' (kW)')
plt.tight_layout()

plt.figure(2)
plt.ylabel(r'$\frac{Velocity}{Steady \, \, Velocity}$',rotation=0,labelpad=40,fontsize=18)
plt.xlabel('Time step')
plt.grid()
plt.xlim([0,40])
plt.legend(loc=1)
plt.title('Driving Heat = '+str(q_heat)+' (kW)')
plt.tight_layout()