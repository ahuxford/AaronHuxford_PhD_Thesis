#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Plot natural circulation loop coupled results
- plot figures of interests
"""

import numpy as np
import matplotlib.pyplot as plt

fsize = [13.5,8.75]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 30})

inletP_ss = 15.018842197261 # steady pressure, Pa

v_ss = 0.23352091314745 # steady velocity, m/s

mdot_nek = 0.532  # kg/s
mdot_sam = 0.5127 # kg/s
q_heat = 7.49     # kW


f=plt.figure(1,figsize=fsize) # plot 

fname_coupled ='/coupled_nek_master_out_ExternalApp0_csv.csv'

dname_save    = '../figures/natCircLoop/'

# Domain overlapping
dname_over = '../results/natCircLoop/Overlapping/'
fnames_over = ['Q1_v16']

plot_lines = []
for i,fname in enumerate(fnames_over):

    data = np.genfromtxt(dname_over+fname+fname_coupled, delimiter=',',names=True)
    
    time = data['time']
    
    dP_init = data['dP_overlap'][0]

    v_init = data['toNekRS_velocity'][0]
        
    l1 = plt.plot(np.arange(len(time)),data['p_inlet_interface']/1e6/inletP_ss, \
          label='Domain overlapping', \
          linestyle = '-', \
          color = 'tab:red', \
          linewidth = 5, \
          marker = '.', \
          markersize = 20)
        
    plot_lines.append(l1)

# Domain decomposition
dname  = '../results/natCircLoop/Decomposition/'
fnames = ['Q1_v4','Q1_v1','Q1_v2',]
labels = []
for i,fname in enumerate(fnames):


    data = np.genfromtxt(dname+fname+fname_coupled, delimiter=',',names=True)
    
    time = data['time']
    
    if fname == 'Q1_v6':
        dP_init = data['dP_overlap'][0]
    else:
        dP_init = data['NekRS_pressureDrop'][0]

    v_init = data['toNekRS_velocity'][0]

    if i == 0:
        lcolor = 'tab:blue' 
        lstyle = '-' 
    elif i == 1:
        lcolor = 'tab:purple' 
        lstyle = '-' 
    elif i == 2:
        lcolor = 'tab:orange' 
        lstyle = '-'
        
    l1 = plt.plot(np.arange(len(time)),data['p_inlet_interface']/1e6/inletP_ss, \
          label=r'$ \mathdefault{U}_{\mathdefault{initial}} \, / \, \mathdefault{U}_{\mathdefault{steady}}$'+' = {:.2f}'.format(v_init/v_ss), \
          linestyle = lstyle, \
          color = lcolor, \
          linewidth = 5, \
          marker = '.', \
          markersize = 20)
    
    plt.plot(np.arange(len(time))[-1],data['p_inlet_interface'][-1]/1e6/inletP_ss, \
          color = 'k', \
          marker = 'X', \
          markersize = 25)

    plot_lines.append(l1)
    labels.append(r'$ \mathdefault{U}_{\mathdefault{initial}} \, / \, \mathdefault{U}_{\mathdefault{steady}}$'+' = {:.2f}'.format(v_init/v_ss))



########################################################################################
# plotting settings
# plt.figure(3)
plt.ylabel(r'$\mathdefault{P}_{\mathdefault{interface}}   \, \, / \, \, \mathdefault{P}_{\mathdefault{steady}} $',fontsize=38)
plt.xlabel('Time step')
plt.grid()
plt.xlim([0,31])

legend1 = plt.legend(plot_lines[0], ["SAM-NekRS overlapping"], loc=3,framealpha=1)
plt.legend([l[0] for l in plot_lines[1:]],labels, loc=2, title="SAM-NekRS decomposition",framealpha=1)
plt.gca().add_artist(legend1)

plt.tight_layout()
plt.savefig(dname_save+'NatCircLoop_InterfacePressure.eps')