# -*- coding: utf-8 -*-
"""
Plotting results for coupling of abtr plof transient
"""

import numpy as np
import matplotlib.pyplot as plt

fsize = [14,10]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 34})

leg_fsize = 32

###############################################################################
# sam standalone model
fname_sam = '../simulations/samAlone/gold/abtr-complete-plof_impeuler_csv.csv'

# overlap coupled
fname_over  = '../simulations/overlap/gold/sam_csv.csv'

sam      = np.genfromtxt(fname_sam, delimiter=',',names=True)
overlap  = np.genfromtxt(fname_over, delimiter=',',names=True)
###############################################################################
# plotting parameters
lwidth = 4    # linewidth
tmin   = -0   # min time for plotting
tmax   = 1000 # max time for plotting

lab_sam  = 'SAM standalone'
lab_over =  'SAM-STARCCM+ coupled'

color_sam  = 'tab:blue'
lstyle_sam = '-'

color_ov1  = 'tab:orange'
lstyle_ov1 = '-'

dT_CtoK = 273.15
###############################################################################
###############################################################################
# Flow Rate, core
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize)

max_sam = 1225.813558901775 #1232.479285847203 #1231.0705427657372
plt.semilogy(sam['time'],
          (sam['CH1_outlet_flow']+sam['CH2_outlet_flow']+sam['CH3_outlet_flow']+sam['CH4_outlet_flow'])/max_sam,
          label = lab_sam ,
          color = color_sam,
          linewidth = lwidth)

max_ovl = 1225.8
plt.semilogy(overlap['time'],
          overlap['left_TDV1massflow']/max_ovl,
          label = lab_over ,
          color = 'tab:orange',
          linewidth = lwidth,
          linestyle = lstyle_ov1)

plt.ylabel('Normalized flow rate (-)')
plt.xlabel('Time (s)')
plt.xlim([tmin,tmax])
plt.ylim([0.01,1.2])
plt.grid()   
plt.legend(framealpha = 1)
plt.tight_layout()
plt.savefig('../figures/Coupled_coreflow.eps')

###############################################################################
###############################################################################
# Outlet Temperatures
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize)

# mass-flow averaged temperature in SAM
core_sam_tot   = sam['CH1_outlet_flow']+sam['CH2_outlet_flow']+sam['CH3_outlet_flow']+sam['CH4_outlet_flow']
core_sam_Twght = sam['CH1_outlet_T']*sam['CH1_outlet_flow'] + sam['CH2_outlet_T']*sam['CH2_outlet_flow'] + sam['CH3_outlet_T']*sam['CH3_outlet_flow'] + sam['CH4_outlet_T']*sam['CH4_outlet_flow']

plt.plot(sam['time'],
          core_sam_Twght/core_sam_tot - dT_CtoK,
          label = lab_sam+', Core Inlet',
          color = color_sam,
          linewidth = lwidth)

plt.plot(sam['time'],
          sam['IHX_inlet_T'] - dT_CtoK,
          label = lab_sam+', IHX Outlet',
          color = 'tab:green',
          linewidth = lwidth)

plt.plot(overlap['time'] ,
          overlap['left_TDJ1temperature'] - dT_CtoK,
          label = lab_over+', Core Inlet',
          color = 'tab:orange',
          linewidth = lwidth,
          linestyle = '--')

plt.plot(overlap['time'] ,
          overlap['right_T_bc'] - dT_CtoK,
          label = lab_over+', IHX Outlet',
          color = 'tab:red',
          linewidth = lwidth,
          linestyle = '--')

plt.ylabel('Temperature (C)')
plt.xlabel('Time (s)')
plt.xlim([tmin,tmax])
plt.ylim([650 - dT_CtoK,835 - dT_CtoK])
plt.grid()   
plt.legend(framealpha = 1,fontsize=26)
plt.tight_layout()
plt.savefig('../figures/Coupled_hotpooltemp.eps')

###############################################################################
###############################################################################
# Maximum Temperature, cladding
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize)

plt.plot(sam['time'],
          sam['max_Tci_core'] - dT_CtoK,
          label = lab_sam,
          linewidth = lwidth)

plt.plot(overlap['time'],
          overlap['max_Tci_core'] - dT_CtoK,
          label = lab_over,
          linestyle = '-',
          linewidth = lwidth)

plt.plot(sam['time'],
          0*sam['time'] + 600,
          label = 'HT-9 maximum allowable',
          color = 'k',
          linestyle = '--',
          linewidth = lwidth)

plt.ylabel('Temperature (C)')
plt.xlabel('Time (s)')
plt.xlim([tmin,tmax])
plt.ylim([650 - dT_CtoK,880 - dT_CtoK])
plt.grid()   
plt.legend(framealpha = 1, loc=4)
plt.tight_layout()
plt.savefig('../figures/Coupled_claddingtemp.eps')