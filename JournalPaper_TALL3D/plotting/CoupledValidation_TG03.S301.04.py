# -*- coding: utf-8 -*-
"""
Plotting results for STH/CFD benchmark T04
"""
import numpy as np
import matplotlib.pyplot as plt

###############################################################################
# import data - experiments
dir_exp = '../experimentData/TG03.S301.04/'
# flow rates, kg/s
FM1_FR_exp = np.genfromtxt(dir_exp+'FM1.FR.csv', delimiter=',')
FM2_FR_exp = np.genfromtxt(dir_exp+'FM2.FR.csv', delimiter=',')
FM3_FR_exp = np.genfromtxt(dir_exp+'FM3.FR.csv', delimiter=',')

# temperatures, C
TC1_0000_exp = np.genfromtxt(dir_exp+'TC1.0000.csv', delimiter=',')
TC1_2641_exp = np.genfromtxt(dir_exp+'TC1.2641.csv', delimiter=',')
TC2_1211_exp = np.genfromtxt(dir_exp+'TC2.1211.csv', delimiter=',')
TC2_2111_exp = np.genfromtxt(dir_exp+'TC2.2111.csv', delimiter=',')
TC3_4036_exp = np.genfromtxt(dir_exp+'TC3.4036.csv', delimiter=',')
TC3_5830_exp = np.genfromtxt(dir_exp+'TC3.5830.csv', delimiter=',')

# sam standalone
fname = '../simulations/TG03.S301.04/samAlone/gold/tall_impeuler_csv.csv'

# coupled Simulation
dname = '../simulations/TG03.S301.04/overlap/gold/' #use mass average temperature

# initialize arrays
lab_coup = ['SAM-STARCCM+ coupled']
col_coup = ['tab:red']

sim_1 = np.genfromtxt(dname+'sam_csv.csv', delimiter=',', names=True)

dt_offset_sim = 10 # time offset in coupled simulation

###############################################################################
# plotting parameters
lwidth_sim = 5    # linewidth
lwidth_exp = 6    # linewidth for experiments
tmin       = -10    # min time for plotting
tmax       = 3000 # max time for plotting
msize      = 12    # marker size for experiment FR data
msize_tc   = 8    # marker size for experiment TC data

color_exp  = 'k'
color_exp2 = 'k'
color_sam  = 'tab:blue'
lstyle_sim = '-'
lstyle_exp = ''

lstyle_sam = '-'

plot_samalone = True

fsize = [18,18]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 22})
f_leg = 22
f_title = 24
pad_title = 10

###############################################################################
# sam data
sam_data = np.genfromtxt(fname, delimiter=',',names=True)

# time, seconds
time  = sam_data['time']
# flow rates in each leg, kg/s
FM1FR = sam_data['FM1FR']
FM2FR = sam_data['FM2FR']
FM3FR = sam_data['FM3FR']
FM4FR = sam_data['FM4FR']
# temperatures converted to C
dT_CtoK = 0 #-273.15
T_MH_in  = sam_data['TC10000'] - 273.15 + dT_CtoK
T_MH_out = sam_data['TC12641'] - 273.15 + dT_CtoK
T_TS_in  = sam_data['TC21211'] - 273.15 + dT_CtoK
T_TS_out = sam_data['TC22111'] - 273.15 + dT_CtoK
T_HX_in  = sam_data['TC35830'] - 273.15 + dT_CtoK
T_HX_out = sam_data['TC34036'] - 273.15 + dT_CtoK

# pressure drops , Pa
dP_TS = sam_data['dP_TS']

###############################################################################
###############################################################################
# Main heater leg
###############################################################################
###############################################################################
fig, axs = plt.subplots(3, 2, sharex=True, figsize=fsize)
# flow rate
j = 0
k = 0

axs[j,k].plot(FM1_FR_exp[:,0],
          FM1_FR_exp[:,1], \
          color     = color_exp, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize, \
          linewidth = lwidth_exp, \
          label     = 'Experiment'
          )    

if plot_samalone:
    axs[j,k].plot(time,
              FM1FR, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              label     ='SAM standalone'
              )

axs[j,k].plot(sim_1['time']-dt_offset_sim,
          sim_1['FM1FR'], \
          color     = col_coup[0], \
          linestyle = lstyle_sim , \
          linewidth = lwidth_sim, \
          label     = lab_coup[0]
          )    
    
axs[j,k].axis(xmin=tmin,xmax=tmax)
axs[j,k].axis(ymin=-0.2,ymax=0.8)
axs[j,k].set_title('MH: LBE flow rate (kg/s)', fontsize=f_title, pad=pad_title)
axs[j,k].tick_params(axis='x', bottom=False, labelbottom=False)
axs[j,k].grid()  
axs[j,k].legend(loc='upper right',fontsize=f_leg, markerscale=2,
                framealpha=1.0)

# temperature
k = 1

p1, = axs[j,k].plot(TC1_0000_exp[:,0],
          TC1_0000_exp[:,1]+dT_CtoK, \
          color     = color_exp, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize_tc, \
          linewidth = lwidth_exp, \
          ) 

if plot_samalone:
    axs[j,k].plot(time,
              T_MH_in, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              )

axs[j,k].plot(sim_1['time'] - dt_offset_sim,
          sim_1['TC10000']-273.15, \
          color     = col_coup[0], \
          linestyle = lstyle_sim, \
          linewidth = lwidth_sim, \
          )
    
p2, = axs[j,k].plot(TC1_2641_exp[:,0],
          TC1_2641_exp[:,1]+dT_CtoK, \
          color     = color_exp2, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize_tc, \
          linewidth = lwidth_exp, \
          label     = 'Experiment'
          )

if plot_samalone:
    p3, = axs[j,k].plot(time,
              T_MH_out, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              label     ='SAM standalone'
              )    

p4, = axs[j,k].plot(sim_1['time'] - dt_offset_sim,
          sim_1['TC12641']-273.15, \
          color     = col_coup[0], \
          linestyle = lstyle_sim, \
          linewidth = lwidth_sim, \
          label     = lab_coup[0]
          )

axs[j,k].axis(xmin=tmin,xmax=tmax)
axs[j,k].axis(ymin=175+dT_CtoK,ymax=425+dT_CtoK)
axs[j,k].set_title('MH: inlet/outlet temperatures ($\degree$C)',
                   fontsize=f_title, pad=pad_title)

axs[j,k].tick_params(axis='x', bottom=False, labelbottom=False)
axs[j,k].grid()   

###############################################################################
###############################################################################
# Test section leg
###############################################################################
###############################################################################


# flow rate
j = 1
k = 0

axs[j,k].plot(FM2_FR_exp[:,0],
          FM2_FR_exp[:,1], \
          color     = color_exp, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize, \
          linewidth = lwidth_exp, \
          label     = 'Experiment'
          )    

if plot_samalone:
    axs[j,k].plot(time,
              FM2FR, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              label     ='SAM standalone'
              )

axs[j,k].plot(sim_1['time']-dt_offset_sim,
          sim_1['FM2FR'], \
          color     = col_coup[0], \
          linestyle = lstyle_sim , \
          linewidth = lwidth_sim, \
          label     = lab_coup[0]
          )    
    
axs[j,k].axis(xmin=tmin,xmax=tmax)
axs[j,k].axis(ymin=-0.25,ymax=0.8)
axs[j,k].set_title('TS: LBE flow rate (kg/s)', fontsize=f_title, pad=pad_title)
axs[j,k].tick_params(axis='x', bottom=False, labelbottom=False)
axs[j,k].grid()   

# temperature
k = 1

axs[j,k].plot(TC2_1211_exp[:,0],
          TC2_1211_exp[:,1]+dT_CtoK, \
          color     = color_exp, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize_tc, \
          linewidth = lwidth_exp, \
          )

if plot_samalone:
    axs[j,k].plot(time,
              T_TS_in, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              )

axs[j,k].plot(sim_1['time'] - dt_offset_sim,
          sim_1['TC21211']-273.15, \
          color     = col_coup[0], \
          linestyle = lstyle_sim, \
          linewidth = lwidth_sim, \
          )

axs[j,k].plot(TC2_2111_exp[:,0],
          TC2_2111_exp[:,1]+dT_CtoK, \
          color     = color_exp2, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize_tc, \
          linewidth = lwidth_exp, \
          label     = 'Experiment'
          )

if plot_samalone:
    axs[j,k].plot(time,
              T_TS_out, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              label     ='SAM standalone'
              )    

axs[j,k].plot(sim_1['time'] - dt_offset_sim,
          sim_1['TC22111']-273.15, \
          color     = col_coup[0], \
          linestyle = lstyle_sim, \
          linewidth = lwidth_sim, \
          label     = lab_coup[0]
          )
    
axs[j,k].axis(xmin=tmin,xmax=tmax)
axs[j,k].axis(ymin=180+dT_CtoK,ymax=350+dT_CtoK)
axs[j,k].set_title('TS: inlet/outlet temperatures ($\degree$C)', fontsize=f_title, pad=pad_title)
axs[j,k].tick_params(axis='x', bottom=False, labelbottom=False)
axs[j,k].grid()   

###############################################################################
###############################################################################
# HX leg
###############################################################################
###############################################################################
# flow rate
j = 2
k = 0

axs[j,k].plot(FM3_FR_exp[:,0],
          FM3_FR_exp[:,1], \
          color     = color_exp, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize, \
          linewidth = lwidth_exp, \
          label     = 'Experiment'
          )    

if plot_samalone:
    axs[j,k].plot(time,
              FM3FR, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              label     ='SAM standalone'
              )

axs[j,k].plot(sim_1['time']-dt_offset_sim,
          sim_1['FM3FR'], \
          color     = col_coup[0], \
          linestyle = lstyle_sim , \
          linewidth = lwidth_sim, \
          label     = lab_coup[0]
          )    
    
axs[j,k].axis(xmin=tmin,xmax=tmax)
axs[j,k].axis(ymin=0.2,ymax=0.7)
axs[j,k].set_title('HX: LBE flow rate (kg/s)', fontsize=f_title, pad=pad_title)
axs[j,k].set_xlabel('Time (s)')
axs[j,k].grid()   

# temperature
k = 1

axs[j,k].plot(TC3_5830_exp[:,0],
          TC3_5830_exp[:,1]+dT_CtoK, \
          color     = color_exp2, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize_tc, \
          linewidth = lwidth_exp, \
          )

if plot_samalone:
    axs[j,k].plot(time,
              T_HX_in, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              )

axs[j,k].plot(sim_1['time'] - dt_offset_sim,
          sim_1['TC35830']-273.15, \
          color     = col_coup[0], \
          linestyle = lstyle_sim, \
          linewidth = lwidth_sim, \
          )

axs[j,k].plot(TC3_4036_exp[:,0],
          TC3_4036_exp[:,1]+dT_CtoK, \
          color     = color_exp, \
          linestyle = lstyle_exp, \
          marker = '.', \
          markersize = msize_tc, \
          linewidth = lwidth_exp, \
          label     = 'Experiment'
          )

if plot_samalone:
    axs[j,k].plot(time,
              T_HX_out, \
              color     = color_sam, \
              linestyle = lstyle_sam, \
              linewidth = lwidth_sim, \
              label     ='SAM standalone'
              )    

axs[j,k].plot(sim_1['time'] - dt_offset_sim,
          sim_1['TC34036']-273.15, \
          color     = col_coup[0], \
          linestyle = lstyle_sim, \
          linewidth = lwidth_sim, \
          label     = lab_coup[0]
          )
        
axs[j,k].axis(xmin=tmin,xmax=tmax)
axs[j,k].axis(ymin=165+dT_CtoK,ymax=340+dT_CtoK)
axs[j,k].set_title('HX: inlet/outlet temperatures ($\degree$C)', fontsize=f_title, pad=pad_title)
axs[j,k].set_xlabel('Time (s)')
axs[j,k].grid()   
plt.tight_layout()
fig.subplots_adjust(hspace=0.15,wspace=0.15)
plt.savefig('../figures/TG03.S301.04/SamVsCoup_all.eps')
