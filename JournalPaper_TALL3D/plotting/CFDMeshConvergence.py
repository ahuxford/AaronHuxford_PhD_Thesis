# -*- coding: utf-8 -*-
"""
Plot final ss temperatures (natural circulation)
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

# plotting settings
fsize_h = [14,10]
fsize_v = [10,14]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 30})

#------------------------------------------------------------------------------
# directories for data
dname_exp = '../experimentData/TG03.S301.04/'

# Experiments
T_BP_exp  = np.genfromtxt(dname_exp+'BP_final.csv' , delimiter=',')
T_IPT_exp = np.genfromtxt(dname_exp+'IPT_final.csv', delimiter=',')
T_ILW_exp = np.genfromtxt(dname_exp+'ILW_final.csv', delimiter=',')
T_OLW_exp = np.genfromtxt(dname_exp+'OLW_final.csv', delimiter=',')

# Simulations
dname_sims = np.array(['../simulations/cfdMeshConvergenceStudy/mesh28/gold/',\
                       '../simulations/cfdMeshConvergenceStudy/mesh30/gold/',\
                       '../simulations/cfdMeshConvergenceStudy/mesh32/gold/'
                      ])

# initialize arrays
N_sims = len(dname_sims)
 
T_BP_sims  = np.ones([N_sims,502,2]) # size based on number of sampling points
T_IPT_sims = np.ones([N_sims,202,2])
T_ILW_sims = np.ones([N_sims,202,2])
T_OLW_sims = np.ones([N_sims,402,2])

lab_sims = ["" for x in range(N_sims)]
col_sims = ["" for x in range(N_sims)]
lstyle_sims = ["" for x in range(N_sims)]

 
result = mcolors.TABLEAU_COLORS.items()
data = list(result)
col_all = np.array(data)

for ind, dname in enumerate(dname_sims):

    T_BP_sims[ind,:,:]  = np.sort(np.genfromtxt(dname+'natCirc_BP.csv' , delimiter=','),axis=0)
    T_IPT_sims[ind,:,:] = np.sort(np.genfromtxt(dname+'natCirc_IPT.csv', delimiter=','),axis=0)
    T_ILW_sims[ind,:,:] = np.sort(np.genfromtxt(dname+'natCirc_ILW.csv', delimiter=','),axis=0)
    T_OLW_sims[ind,:,:] = np.sort(np.genfromtxt(dname+'natCirc_OLW.csv', delimiter=','),axis=0)
    
    label = dname[39:45] # pull mesh label
    
    if label=='mesh32':
        lab_sims[ind] = '  32,000 elements' #'8,200'
        # lstyle_sims[ind] = (0,(2,1))
        lstyle_sims[ind] = '--'
        col_sims[ind] = 'tab:green'
    # elif label=='mesh29':
    #     lab_sims[ind] = '9,600'
    #     lstyle_sims[ind] = '--'
    elif label=='mesh30':
        lab_sims[ind] = '105,000 elements'
        lstyle_sims[ind] = '--'
        col_sims[ind] = 'tab:red'
    elif label=='mesh28':
        lab_sims[ind] = '629,000 elements'
        lstyle_sims[ind] = '-'
        col_sims[ind] = 'k'
    elif label=='mesh27':
        lab_sims[ind] = '192,000 elements' #'168,000'
        lstyle_sims[ind] = '--'
        col_sims[ind] = 'tab:green'
    elif label=='mesh25':
        lab_sims[ind] = '72,000 elements' #'48,000'
        lstyle_sims[ind] = (0,(1,1))
        col_sims[ind] = 'tab:green'
    # elif label=='mesh24':
    #     lab_sims[ind] = '18,000'
    #     lstyle_sims[ind] = '--'
    else:
        lab_sims[ind] = 'unknown'
        lstyle_sims[ind] = '-'
        col_sims[ind] = col_all[ind][0]



# extra for plotting
L_exp = 0.25 # reference vertical coordinate from experiment
dT = 0 #273.15
Terr = 2.2 # error in exp TC data

lwidth = 8  # line width
msize  = 20
lsize  = 32 # legend font size
ewidth = 3  # error bar line thickness
ecap   = 10 # 
emsize = 10

#------------------------------------------------------------------------------
# Bottom Plate 
plt.figure(figsize=fsize_h)


# Simulations
for j in range(N_sims):
    plt.plot(T_BP_sims[j,:,0],T_BP_sims[j,:,1]+dT,\
          label = lab_sims[j],\
          color = col_sims[j],\
          linewidth = lwidth,\
          linestyle = lstyle_sims[j],\
          marker = None,\
          markersize = msize)
    
# # Experiment
# plt.errorbar(T_BP_exp[:,0],T_BP_exp[:,1]+dT,\
#           yerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
#           label=r'Experiment',\
#           color='tab:red',\
#           linestyle = '',\
#           marker = '.',\
#           markersize = emsize)
    
# plotting settings
plt.title('Bottom Plate (BP)',fontsize=40)
plt.xlabel('Radial coordinate (m)',fontsize=34)
plt.ylabel('Temperature ($\degree$C)',fontsize=34)
#plt.ylabel('Temperature ($^\circ$C)',fontsize=34)
#plt.ylabel('Temperature (K)',fontsize=34)
plt.xlim(0.15,0)
plt.ylim(200+dT, 230+dT)
# plt.ylim(472.5,510)
# plt.legend(loc=3,fontsize=lsize,framealpha=1)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdMeshConvergenceStudy/MeshConvergence_BP.eps')

#------------------------------------------------------------------------------
# In pool
plt.figure(figsize=fsize_h)

# Simulations
for j in range(N_sims):
    plt.plot(T_IPT_sims[j,:,0]+dT,T_IPT_sims[j,:,1]-L_exp,\
          label = lab_sims[j],\
          color = col_sims[j],\
          linewidth = lwidth,\
          linestyle = lstyle_sims[j],\
          marker = None,\
          markersize = msize)

# # Experiment
# plt.errorbar(T_IPT_exp[:,0]+dT,T_IPT_exp[:,1]-L_exp,
#           xerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
#           label=r'Experiment',\
#           color='tab:red',\
#           linestyle = '',\
#           marker = '.',\
#           markersize = emsize)
    
# plotting settings
plt.title('In Pool TCs (IPT)',fontsize=40)
plt.ylabel('Distance from drum bottom (m)',fontsize=34)
plt.xlabel('Temperature ($\degree$C)',fontsize=34)
#plt.xlabel('Temperature ($^\circ$C)',fontsize=34)
#plt.xlabel('Temperature (K)',fontsize=34)
plt.ylim(0,0.2)
plt.xlim(225+dT,307.5+dT)
plt.legend(loc=4,fontsize=lsize,framealpha=1)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdMeshConvergenceStudy/MeshConvergence_IPT.eps')

# #------------------------------------------------------------------------------
# # Inner wall
# plt.figure(figsize=fsize_v)

# # Simulations
# for j in range(N_sims):
#     plt.plot(T_ILW_sims[j,:,0]+dT,T_ILW_sims[j,:,1]-L_exp,\
#           label = lab_sims[j],\
#           color = col_sims[j],\
#           linewidth = lwidth,\
#           marker = None,\
#           markersize = msize)
    
# # # Experiment
# # plt.errorbar(T_ILW_exp[:,0]+dT,T_ILW_exp[:,1]-L_exp,
# #           xerr=Terr,\
# #           capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
# #           label=r'Experiment',\
# #           color='tab:red',\
# #           linestyle = '',\
# #           marker = '.',\
# #           markersize = emsize)
    
# # plotting settings
# plt.title('Inner Wall Temperatures, Final')
# plt.ylabel('Distance from drum bottom (m)')
# plt.xlabel('Temperature (K)')
# plt.ylim(0,0.205)
# plt.legend(loc=4,fontsize=lsize)
# plt.grid()
# plt.tight_layout()
# plt.savefig('../figures/cfdMeshConvergenceStudy/MeshConvergence_ILW.png')

# #------------------------------------------------------------------------------
# # Outer wall
# plt.figure(figsize=fsize_v)

# # Simulations
# for j in range(N_sims):
#     plt.plot(T_OLW_sims[j,:,0]+dT,T_OLW_sims[j,:,1]-L_exp,\
#           label = lab_sims[j],\
#           color = col_sims[j],\
#           linewidth = lwidth,\
#           marker = None,\
#           markersize = msize)

    
# # # Experiment
# # plt.errorbar(T_OLW_exp[:,0]+dT,T_OLW_exp[:,1]-L_exp,label=r'Experiment',\
# #           xerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
# #           color='tab:red',\
# #           linestyle = '',\
# #           marker = '.',\
# #           markersize = emsize)
    
# # plotting settings
# plt.title('Outer Wall Temperatures, Final')
# plt.ylabel('Distance from drum bottom (m)')
# plt.xlabel('Temperature (K)')
# plt.ylim(0,0.205)
# plt.legend(loc=4,fontsize=lsize)
# plt.grid()
# plt.tight_layout()
# plt.savefig('../figures/cfdMeshConvergenceStudy/MeshConvergence_OLW.png')
