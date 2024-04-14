# -*- coding: utf-8 -*-
"""
Plotting results for initial state of abtr plof transient
"""

import numpy as np
import matplotlib.pyplot as plt


plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 28})

###############################################################################
# sam standalone model
fname_sam = '../simulations/steadystate/abtr-complete-plof_impeuler_csv.csv'

sam = np.genfromtxt(fname_sam, delimiter=',',names=True)

# csv files from SAM's exodus output
fname_exo = '../simulations/steadystate/Coolant_temperature_CH1.csv'
CH1_coolant_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)
fname_exo = '../simulations/steadystate/Coolant_temperature_CH2.csv'
CH2_coolant_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)
fname_exo = '../simulations/steadystate/Coolant_temperature_CH3.csv'
CH3_coolant_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)
fname_exo = '../simulations/steadystate/Coolant_temperature_CH4.csv'
CH4_coolant_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)
fname_exo = '../simulations/steadystate/Coolant_temperature_CH5.csv'
CH5_coolant_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)

# channel 1 fuel and cladding temps
fname_exo = '../simulations/steadystate/Fuel_temperature_CH1.csv'
CH1_fuel_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)

fname_exo = '../simulations/steadystate/Cladding_temperature_CH1.csv'
CH1_clad_temp = np.genfromtxt(fname_exo, delimiter=',',names=True)

lab_ch1  = 'Peak assembly'
lab_ch2  = 'Inner core'
lab_ch3  = 'Fuel test'
lab_ch4  = 'Outer core'
lab_ch5  = 'Reflector and material test'

col_ch1 = 'tab:blue'
col_ch2 = 'tab:orange'
col_ch3 = 'tab:green'
col_ch4 = 'tab:red'
col_ch5 = 'tab:purple'

###############################################################################
# plotting parameters
lwidth = 4    # linewidth
tmin   = -10 # min time for plotting
tmax   = 1000 # max time for plotting
dT_CtoK = 273.15

fsize1 = [18,10]
fsize2 = [10,10]
fsize3 = [13,10]

# parse fuel temp file for inner and outer fuel temps
CH1_fuel_innertemp   = np.array([])
CH1_fuel_innertemp_z = np.array([])

CH1_fuel_outertemp   = np.array([])
CH1_fuel_outertemp_z = np.array([])

for i in range(len(CH1_fuel_temp)):
    
    # pull inner temps
    if CH1_fuel_temp['Points1'][i]==-1.009:
        CH1_fuel_innertemp = np.append(CH1_fuel_innertemp, CH1_fuel_temp['T_solid'][i])
        CH1_fuel_innertemp_z = np.append(CH1_fuel_innertemp_z, CH1_fuel_temp['Points2'][i])
   
    # pull outer temps
    if CH1_fuel_temp['Points1'][i]==-1.006:
        CH1_fuel_outertemp   = np.append(CH1_fuel_outertemp, CH1_fuel_temp['T_solid'][i])
        CH1_fuel_outertemp_z = np.append(CH1_fuel_outertemp_z, CH1_fuel_temp['Points2'][i])
             

# parse clad temp file for inner and outer clad temps
CH1_clad_innertemp   = np.array([])
CH1_clad_innertemp_z = np.array([])

CH1_clad_outertemp   = np.array([])
CH1_clad_outertemp_z = np.array([])

for i in range(len(CH1_clad_temp)):
    
    # pull inner temps
    if CH1_clad_temp['Points1'][i]==-1.0055:
        CH1_clad_innertemp = np.append(CH1_clad_innertemp, CH1_clad_temp['T_solid'][i])
        CH1_clad_innertemp_z = np.append(CH1_clad_innertemp_z, CH1_clad_temp['Points2'][i])
   
    # pull outer temps
    if CH1_clad_temp['Points1'][i]==-1.005:
        CH1_clad_outertemp   = np.append(CH1_clad_outertemp, CH1_clad_temp['T_solid'][i])
        CH1_clad_outertemp_z = np.append(CH1_clad_outertemp_z, CH1_clad_temp['Points2'][i])
             

###############################################################################
###############################################################################
# Axial power peaking factor
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize2)

z = np.array([0.0, 0.0200, 0.0600, 0.100, 0.140, 0.180, 0.220, 0.260, 0.300, 
              0.340, 0.380, 0.420, 0.460, 0.500, 0.540, 0.580, 0.620, 0.660,
              0.700, 0.740, 0.780, 0.800])

ppf = np.array([7.818e-1, 8.12035e-1, 8.72501e-1, 9.43054e-1, 1.01107, 1.04739, 
                1.09779, 1.13790, 1.16662, 1.17569, 1.18022, 1.17255, 1.15267,
                1.13305, 1.08829, 1.03142, 9.62681e-1, 9.08601e-1, 8.11380e-1,
                7.04156e-1, 5.90929e-1, 5.34316e-1])
plt.plot(z,
          ppf,
          marker='.',
          markersize=25,
          color = 'k',
          linewidth = lwidth)

plt.ylabel('Power peaking factor (-)')
plt.xlabel('Axial position in active core (m)')
plt.xlim([0,0.8])
plt.ylim([0,1.2])
plt.grid()   
plt.tight_layout()
plt.savefig('../figures/ppf.eps')

###############################################################################
###############################################################################
# reactor power and pump head
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize3)

plt.plot(sam['time'],
          sam['reactorpower']/250e6,
          label = 'Input reactor power',
          color = 'k',
          linewidth = lwidth)

plt.plot(sam['time'],
          sam['Pump_ppump_head']/415100,
          label = 'Input pump head',
          color = 'tab:red',
          linewidth = lwidth)

plt.ylabel('Normalized value (-)')
plt.xlabel('Time (s)')
plt.xlim([tmin,420]) # pump head = 0 after 420 s
plt.ylim([0,1.01])
plt.grid()   
plt.legend(framealpha = 1)
plt.tight_layout()
plt.savefig('../figures/Normalized_power_pump.eps')

###############################################################################
###############################################################################
# Axial coolant temperatures
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize3)

plt.plot(CH1_coolant_temp['arc_length'],
         CH1_coolant_temp['temperature'] - dT_CtoK, 
         color = col_ch1,
         label = lab_ch1,
         linewidth = lwidth)

plt.plot(CH2_coolant_temp['arc_length'],
         CH2_coolant_temp['temperature'] - dT_CtoK, 
         color = col_ch2,
         label = lab_ch2,
         linewidth = lwidth)

plt.plot(CH3_coolant_temp['arc_length'],
         CH3_coolant_temp['temperature'] - dT_CtoK, 
         color = col_ch3,
         label = lab_ch3,
         linewidth = lwidth)

plt.plot(CH4_coolant_temp['arc_length'],
         CH4_coolant_temp['temperature'] - dT_CtoK, 
         color = col_ch4,
         label = lab_ch4,
         linewidth = lwidth)

plt.plot(CH5_coolant_temp['arc_length'],
         CH5_coolant_temp['temperature'] - dT_CtoK, 
         color = col_ch5,
         label = lab_ch5,
         linewidth = lwidth)


plt.ylabel('Temperature (C)')
plt.xlabel('Axial position in active core (m)')
plt.xlim([0,0.8])
# plt.xlim([0,1.2])
plt.grid()   
plt.legend(framealpha = 1, loc=4,fontsize=25)
plt.tight_layout()
plt.savefig('../figures/Initial_CoolantTemperatures.eps')

###############################################################################
###############################################################################
# Axial peak fuel temperatures
###############################################################################
###############################################################################
fig = plt.figure(figsize=fsize3)

plt.plot(CH1_fuel_innertemp_z,
         CH1_fuel_innertemp - dT_CtoK, 
         color = col_ch1,
         label = 'Fuel centerline',
         marker = '.',
         markersize = 20,
         linewidth = lwidth)

plt.plot(CH1_fuel_outertemp_z,
         CH1_fuel_outertemp - dT_CtoK, 
         color = col_ch2,
         label = 'Fuel surface',
         marker = '.',
         markersize = 20,
         linewidth = lwidth)

plt.plot(CH1_clad_innertemp_z,
         CH1_clad_innertemp - dT_CtoK, 
         color = col_ch3,
         label = 'Cladding inner',
         marker = '.',
         markersize = 20,
         linewidth = lwidth)

plt.plot(CH1_clad_outertemp_z,
         CH1_clad_outertemp - dT_CtoK, 
         color = col_ch4,
         label = 'Cladding surface',
         marker = '.',
         markersize = 20,
         linewidth = lwidth)

plt.plot(CH1_coolant_temp['arc_length'],
         CH1_coolant_temp['temperature'] - dT_CtoK, 
         color = col_ch5,
         label = 'Coolant bulk',
         linewidth = lwidth)


plt.ylabel('Temperature (C)')
plt.xlabel('Axial position in active core (m)')
plt.xlim([0, 0.8])
plt.ylim([600-dT_CtoK, 950-dT_CtoK])
plt.grid()   
plt.legend(framealpha = 1, loc=4)
plt.tight_layout()
plt.savefig('../figures/Initial_PeakAssemply_CoolantTemperatures.eps')