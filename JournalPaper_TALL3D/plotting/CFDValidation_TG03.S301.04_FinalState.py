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
T_BP_exp  = np.genfromtxt(dname_exp+'BP_final.csv' , delimiter=',')
T_IPT_exp = np.genfromtxt(dname_exp+'IPT_final.csv', delimiter=',')
T_ILW_exp = np.genfromtxt(dname_exp+'ILW_final.csv', delimiter=',')
T_OLW_exp = np.genfromtxt(dname_exp+'OLW_final.csv', delimiter=',')

#
# Simulation
#
dname_sim = '../simulations/cfdValidationAlone/naturalCirculation/gold/'
T_BP_sim  = np.genfromtxt(dname_sim+'NatCirc_SST_LBEcp_mdot0p28_BP.csv' , delimiter=',')
T_IPT_sim = np.genfromtxt(dname_sim+'NatCirc_SST_LBEcp_mdot0p28_IPT.csv', delimiter=',')
T_ILW_sim = np.genfromtxt(dname_sim+'NatCirc_SST_LBEcp_mdot0p28_ILW.csv', delimiter=',')
T_OLW_sim = np.genfromtxt(dname_sim+'NatCirc_SST_LBEcp_mdot0p28_OLW.csv', delimiter=',')

lab1 = 'STAR-CCM+ CFD model'

# extra for plotting
L_exp = 0.25 # reference vertical coordinate from experiment
dT = 0 # 273.15       # convert from C to K
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
plt.plot(T_BP_sim[:,0],T_BP_sim[:,1]+dT,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)
# Experiment
plt.errorbar(T_BP_exp[:,0],T_BP_exp[:,1]+dT,\
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
    plt.ylabel(r'Temperature ($^{\circ}$C)',fontsize=42)
else:
    plt.ylabel('Temperature (K)',fontsize=42)
plt.xlim(0.15,0)
plt.ylim(200+dT,235+dT)
plt.legend(loc=1,fontsize=lsize,framealpha=1)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/NatCirc_BP.eps')

#------------------------------------------------------------------------------
# In pool
plt.figure(figsize=fsize_v)

# Simulation
plt.plot(T_IPT_sim[:,0]+dT,T_IPT_sim[:,1]-L_exp,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)

# Experiment
plt.errorbar(T_IPT_exp[:,0]+dT,T_IPT_exp[:,1]-L_exp,
          xerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          label=r'Experiment',\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('In Pool TCs (IPT)',fontsize=42)
if dT==0:
    plt.xlabel(r'Temperature ($^{\circ}$C)',fontsize=42)
else:
    plt.xlabel('Temperature (K)',fontsize=42)
plt.ylim(-0.0025,0.205)
plt.xlim(220+dT,310+dT)
plt.grid()
frame1 = plt.gca()
frame1.axes.yaxis.set_ticklabels([])
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/NatCirc_IPT.eps')

#------------------------------------------------------------------------------
# Inner wall
plt.figure(figsize=fsize_v)

# Simulation
plt.plot(T_ILW_sim[:,0]+dT,T_ILW_sim[:,1]-L_exp,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)

# Experiment
plt.errorbar(T_ILW_exp[:,0]+dT,T_ILW_exp[:,1]-L_exp,
          xerr=Terr,\
          capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          label=r'Experiment',\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('Inner Lateral Wall (ILW)',fontsize=42)
if dT==0:
    plt.xlabel(r'Temperature ($^{\circ}$C)',fontsize=42)
else:
    plt.xlabel('Temperature (K)',fontsize=42)
plt.ylim(-0.0025,0.205)
plt.xlim(220+dT,315+dT)
plt.grid()
frame1 = plt.gca()
frame1.axes.yaxis.set_ticklabels([])
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/NatCirc_ILW.eps')

#------------------------------------------------------------------------------
# Outer wall
plt.figure(figsize=fsize_v)

# Simulation
plt.plot(T_OLW_sim[:,0]+dT,T_OLW_sim[:,1]-L_exp,label=lab1 ,\
          color='tab:red',\
          linewidth=lwidth,\
          marker = '.',\
          markersize = msize)

# Experiment
plt.errorbar(T_OLW_exp[:,0]+dT,T_OLW_exp[:,1]-L_exp,label=r'Experiment',\
          xerr=Terr,capsize=ecap,elinewidth=ewidth,markeredgewidth=ewidth,\
          color='k',\
          linestyle = '',\
          marker = '.',\
          markersize = emsize)
    
# plotting settings
plt.title('Outer Lateral Wall (OLW)',fontsize=42)
plt.ylabel('Distance from drum bottom (m)',fontsize=38)
if dT==0:
    plt.xlabel(r'Temperature ($^{\circ}$C)',fontsize=42)
else:
    plt.xlabel('Temperature (K)',fontsize=42)
plt.ylim(-0.0025,0.205)
plt.xlim(220+dT,325+dT)
plt.grid()
plt.tight_layout()
plt.savefig('../figures/cfdValidationAlone/NatCirc_OLW.eps')
