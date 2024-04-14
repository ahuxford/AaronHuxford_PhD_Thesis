# -*- coding: utf-8 -*-
"""
Plot final ss temperatures (natural circulation)
"""

import numpy as np
import matplotlib.pyplot as plt


# plotting settings
fsize_h = [14,10]
fsize_v = [10,14]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 30})

#------------------------------------------------------------------------------
# directories for data
#
# Experiments
#
dname_exp = '../experimentData/TG03.S301.04/'
T_BP_exp  = np.genfromtxt(dname_exp+'BP_initial.csv' , delimiter=',')
T_IPT_exp = np.genfromtxt(dname_exp+'IPT_initial.csv', delimiter=',')
T_ILW_exp = np.genfromtxt(dname_exp+'ILW_initial.csv', delimiter=',')
T_CIP_exp = np.genfromtxt(dname_exp+'CIP_initial.csv', delimiter=',')

#
# Simulation
#
dname_sim = '../simulations/cfdValidationAlone/forcedCirculation/gold/'
T_BP_sim  = np.genfromtxt(dname_sim+'BP_initial.csv' , delimiter=',')
T_IPT_sim = np.genfromtxt(dname_sim+'IPT_initial.csv', delimiter=',')
T_ILW_sim = np.genfromtxt(dname_sim+'ILW_initial.csv', delimiter=',')
T_CIP_sim = np.genfromtxt(dname_sim+'CIP_initial_2.csv', delimiter=',')

lab1 = 'STAR-CCM+ CFD model'

# extra for plotting
L_exp = 0.25 # reference vertical coordinate from experiment
dT = 273.15  # convert K to C (different than other plot script, lol sorry)
Terr = 2.2   # error in exp TC data

lwidth = 0  # line width
msize  = 20
lsize  = 28 # legend font size
ewidth = 4  # error bar line thickness
ecap   = 10 # 
emsize = 18

#------------------------------------------------------------------------------
# Bottom Plate 
plt.figure(figsize=fsize_h)

# Simulation
plt.plot(T_BP_sim[:,0],T_BP_sim[:,1]+273.15-dT,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)
# Experiment
plt.errorbar(T_BP_exp[:,0],T_BP_exp[:,1]-dT,\
          yerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          label=r'Experiment',\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('Bottom Plate (BP)',fontsize=42)
plt.xlabel('Radial coordinate (m)',fontsize=38)
if dT==0:
    plt.ylabel('Temperature (K)',fontsize=42)
else:
    plt.ylabel(r'Temperature ($^{\circ}$C)',fontsize=42)
plt.xlim(0.15,0)
plt.ylim(234+273.15-dT,265+273.15-dT)
plt.legend(loc=1,fontsize=lsize,framealpha=1)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/ForceCirc_BP.eps')

#------------------------------------------------------------------------------
# In pool
plt.figure(figsize=fsize_v)

# Simulation
plt.plot(T_IPT_sim[:,0]+273.15-dT,T_IPT_sim[:,1]-L_exp,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)

# Experiment
plt.errorbar(T_IPT_exp[:,1]-dT,T_IPT_exp[:,0],
          xerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          label=r'Experiment',\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('In Pool TCs (IPT)',fontsize=42)
if dT==0:
    plt.xlabel('Temperature (K)',fontsize=42)
else:
    plt.xlabel(r'Temperature ($^{\circ}$C)',fontsize=42)
plt.ylim(-0.0025,0.205)
plt.xlim(245+273.15-dT,265+273.15-dT)
plt.xticks(ticks=plt.xticks()[0], labels=plt.xticks()[0].astype(int))
plt.grid()
frame1 = plt.gca()
frame1.axes.yaxis.set_ticklabels([])
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/ForceCirc_IPT.eps')

#------------------------------------------------------------------------------
# Inner wall
plt.figure(figsize=fsize_v)

# Simulation
plt.plot(T_ILW_sim[:,0]+273.15-dT,T_ILW_sim[:,1]-L_exp,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)

# Experiment
plt.errorbar(T_ILW_exp[:,1]-dT,T_ILW_exp[:,0],
          xerr=Terr,\
          capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          label=r'Experiment',\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('Inner Lateral Wall (ILW)',fontsize=42)
plt.ylim(-0.0025,0.205)
plt.xlim(250+273.15-dT,275+273.15-dT)
plt.ylabel('Distance from drum bottom (m)',fontsize=38)
if dT==0:
    plt.xlabel('Temperature (K)',fontsize=42)
else:
    plt.xlabel(r'Temperature ($^{\circ}$C)',fontsize=42)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/ForceCirc_ILW.eps')

#------------------------------------------------------------------------------
# Circular Inner Plate (CIP)
plt.figure(figsize=fsize_h)

# Simulation
plt.plot(T_CIP_sim[:,0],T_CIP_sim[:,1]+273.15-dT,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)
# Experiment
plt.errorbar(T_CIP_exp[:,0],T_CIP_exp[:,1]-dT,\
          yerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          label=r'Experiment',\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('Circular Inner Plate (CIP)',fontsize=42)
plt.xlabel('Radial coordinate (m)',fontsize=38)
if dT==0:
    plt.ylabel('Temperature (K)',fontsize=42)
else:
    plt.ylabel(r'Temperature ($^{\circ}$C)',fontsize=42)
plt.xlim(0.098,-0.002)
Tmin = 510
Tmax = 535
dT_plot = 273 # dT for plotting purposes
plt.ylim(Tmin-dT_plot+3,Tmax-dT_plot-2)
plt.yticks(np.arange(Tmin-dT_plot+3, Tmax+5-dT_plot-2, 5))
#plt.yticks(ticks=plt.yticks()[0], labels=plt.yticks()[0].astype(int))
# plt.legend(loc=1,fontsize=lsize,framealpha=1)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/ForceCirc_CIP.eps')
