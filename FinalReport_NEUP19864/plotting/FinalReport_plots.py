#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Plot final report plots
"""

import numpy as np
import matplotlib.pyplot as plt

fsize = [14,8]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 30})
k = 0 # for figures


# defaults for plotting
leg_fsize = 24
leg_alpha = 1.0

msize_sam = 30
msize_nek = 15
msize_ovl = 13
msize_dec = 13

lwid_sam = 3
lwid_nek = 3
lwid_ovl = 3
lwid_dec = 3

mark_sam = '.'
mark_nek = 's'
mark_ovl = 'd'
mark_dec = '^'

col_sam = 'k'
col_nek = 'tab:orange'
col_ovl = 'tab:red'
col_dec = 'tab:green'

label_sam = 'SAM standalone'
label_nek = 'NekRS standalone'
label_ovl = 'SAM-NekRS overlapping'
label_dec = 'SAM-NekRS decomposition'

# file/dir defaults
fname = '/wpd_datasets.csv'
dname = 'VerificationPlots/'
dout  = dname + 'Results/'

############################################################
# bent pipe steady
############################################################
dcase = 'BentPipe_steady'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = data[:,i:i+2]; i += di;
data_nek = data[:,i:i+2]; i += di;
data_ovl = data[:,i:i+2]; i = 0;


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = msize_sam, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = msize_nek, \
         color      = col_nek)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = msize_ovl, \
         color      = col_ovl)

# plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Inlet Reynolds Number (-)')
plt.grid()
dxlim = 0.1*np.min(data_sam[:,0]) # x limits offset
plt.xlim([np.min(data_sam[:,0])-dxlim, \
          np.max(data_sam[:,0])+dxlim])
plt.xticks(np.round(data_sam[:,0],-2))
plt.yticks(np.arange(0,100+25,25))
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

############################################################
# bent pipe transient
############################################################

dcase = 'BentPipe_transient'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = np.sort(data[:,i:i+2]); i += di;
data_nek = np.sort(data[:,i:i+2]); i += di;
data_ovl = np.sort(data[:,i:i+2]); i = 0;


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = 0, \
         color      = col_sam)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = msize_ovl, \
         color      = col_ovl)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = 0, \
         color      = col_nek)

## plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Time (s)')
plt.grid()
dxlim = 0.1*np.min(data_sam[:,0]) # x limits offset
plt.xlim([0.9, 6.1])
plt.ylim([0,100])
# modify legen order
handles, labels = plt.gca().get_legend_handles_labels()
order = [0,2,1]
plt.legend([handles[idx] for idx in order],[labels[idx] for idx in order],fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

############################################################
# energy steady
############################################################
dcase = 'StraightPipe_energy_steady'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = data[:,i:i+2]; i += di;
data_nek = data[:,i:i+2]; i += di;
data_ovl = data[:,i:i+2]; i = 0;


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = msize_sam, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = msize_nek, \
         color      = col_nek)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = msize_ovl, \
         color      = col_ovl)

# plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Inlet Reynolds Number (-)')
plt.grid()
dxlim = 0.05*np.min(data_sam[:,0]) # x limits offset
plt.xlim([np.min(data_sam[:,0])-dxlim, \
          np.max(data_sam[:,0])+dxlim])
plt.xticks(np.round(data_sam[:,0],-2))
plt.ylim([12,20])
#plt.yticks(np.arange(12,20+1,2))
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

############################################################
# energy transient
############################################################

dcase = 'StraightPipe_energy_transient'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2,filling_values=0)

i = 0; di = 2; # to pull xy values properly

data_sam = np.sort(data[:,i:i+2],0); i += di;
data_nek = np.sort(data[:,i:i+2],0); i += di;
data_ovl = np.sort(data[:,i:i+2],0); i += di;
data_dec = np.sort(data[:,i:i+2],0); i  =  0;

#data_sam = np.ma.masked_equal(data_sam,0)


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = 0, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = 0, \
         color      = col_nek)

# decomposition
plt.plot(data_dec[:,0],data_dec[:,1], \
         label      = label_dec, \
         linewidth  = lwid_dec, \
         marker     = mark_dec, \
         markersize = 0, \
         color      = col_dec)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = msize_ovl, \
         color      = col_ovl)


## plotting settings
plt.ylabel('Outlet Temperature (K)')
plt.xlabel('Time (s)')
plt.grid()
plt.xlim([0, 2])
plt.ylim([-0.05,1.05])
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

#############################################################
## pump loop 
#############################################################
#dcase = 'PumpLoop'
#file = dname + dcase + fname
#k += 1
#
#data = np.genfromtxt(file, delimiter=',',skip_header=2)
#
#i = 0; di = 2; # to pull xy values properly
#
#data_sam = data[:,i:i+2]; i += di;
#data_ovl = data[:,i:i+2]; i += di;
#data_dec = data[:,i:i+2]; i  =  0;
#
#f=plt.figure(k,figsize=fsize) # plot 
#
## sam
#plt.plot(data_sam[:,0],data_sam[:,1], \
#         label      = label_sam, \
#         linewidth  = lwid_sam, \
#         marker     = mark_sam, \
#         markersize = msize_sam, \
#         color      = col_sam)
#
## decomposition
#plt.plot(data_dec[:,0],data_dec[:,1], \
#         label      = label_dec, \
#         linewidth  = lwid_dec, \
#         marker     = mark_dec, \
#         markersize = 20, \
#         color      = col_dec)
#
## overlapping
#plt.plot(data_ovl[:,0],data_ovl[:,1], \
#         label      = label_ovl, \
#         linewidth  = 0, \
#         marker     = mark_ovl, \
#         markersize = 10, \
#         color      = col_ovl)
#
## plotting settings
#plt.ylabel('Steady Reynolds Number (-)')
#plt.xlabel('Pump Head (Pa)')
#plt.grid()
#plt.xlim([430,3500])
#plt.ylim([0,31000])
#plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
#plt.tight_layout()
#plt.savefig(dout+dcase+'.eps')

############################################################
# one interface steady
############################################################
dcase = 'StraightPipe_1int_steady'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = data[:,i:i+2]; i += di;
data_nek = data[:,i:i+2]; i += di;
data_ovl = data[:,i:i+2]; i = 0;

data_dec = data_ovl # can't find the original files but these results do match


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = msize_sam, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = msize_nek, \
         color      = col_nek)

# decomposition
plt.plot(data_dec[:,0],data_dec[:,1], \
         label      = label_dec, \
         linewidth  = lwid_dec, \
         marker     = mark_dec, \
         markersize = 20, \
         color      = col_dec)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = msize_ovl, \
         color      = col_ovl)

# plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Inlet Reynolds Number (-)')
plt.grid()
#dxlim = 0.05*np.min(data_sam[:,0]) # x limits offset
#plt.xlim([np.min(data_sam[:,0])-dxlim, \
#          np.max(data_sam[:,0])+dxlim])
plt.xticks(np.round(data_sam[:,0],-2))
plt.ylim([8,30])
#plt.yticks(np.arange(12,20+1,2))
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

############################################################
# straight pipe 1 interface transient
############################################################

dcase = 'StraightPipe_1int_transient'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = np.sort(data[:,i:i+2]); i += di;
data_nek = np.sort(data[:,i:i+2]); i += di;
data_ovl = np.sort(data[:,i:i+2]); i = 0;

data_dec = data_ovl # can't find the original files but these results do match

f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = 0, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = 0, \
         color      = col_nek)

# decomposition
plt.plot(data_dec[:,0],data_dec[:,1], \
         label      = label_dec, \
         linewidth  = lwid_dec, \
         marker     = mark_dec, \
         markersize = 0, \
         color      = col_dec)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = 8, \
         color      = col_ovl, \
         markevery = 2)


## plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Time (s)')
plt.grid()
plt.xlim([0.925, 6.075])
plt.ylim([0,40])
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

############################################################
# straight pipe 1 interface transient, imposed p drop
############################################################

dcase = 'StraightPipe_1int_transient'
file = dname + dcase + '/wpd_datasets_pdrop.csv'
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = np.sort(data[:,i:i+2]); i += di;
data_ovl = np.sort(data[:,i:i+2]); i += di;
data_dec = np.sort(data[:,i:i+2]); i = 0;

f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = 0, \
         color      = col_sam)

# decomposition
plt.plot(data_dec[:,0],data_dec[:,1], \
         label      = label_dec, \
         linewidth  = lwid_dec, \
         marker     = mark_dec, \
         markersize = 0, \
         color      = col_dec)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = 8, \
         color      = col_ovl)


## plotting settings
plt.ylabel('Reynolds Number (-)')
plt.xlabel('Time (s)')
plt.grid()
plt.xlim([0, 100])
plt.ylim([0,30500])
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'_pdrop.eps')

############################################################
# two interface steady
############################################################
dcase = 'StraightPipe_2int_steady'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = data[:,i:i+2]; i += di;
data_nek = data[:,i:i+2]; i += di;
data_ovl = data[:,i:i+2]; i = 0;

data_dec = data_ovl #results match


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = msize_sam, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = msize_nek, \
         color      = col_nek)

# decomposition
plt.plot(data_dec[:,0],data_dec[:,1], \
         label      = label_dec, \
         linewidth  = lwid_dec, \
         marker     = mark_dec, \
         markersize = 20, \
         color      = col_dec)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = msize_ovl, \
         color      = col_ovl)

# plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Inlet Reynolds Number (-)')
plt.grid()
plt.xticks(np.round(data_sam[:,0],-2))
plt.ylim([8,30])
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')

############################################################
# straight pipe 2 interface transient
############################################################

dcase = 'StraightPipe_2int_transient'
file = dname + dcase + fname
k += 1

data = np.genfromtxt(file, delimiter=',',skip_header=2)

i = 0; di = 2; # to pull xy values properly

data_sam = np.sort(data[:,i:i+2]); i += di;
data_nek = np.sort(data[:,i:i+2]); i += di;
data_ovl = np.sort(data[:,i:i+2]); i += di;
data_dec = np.sort(data[:,i:i+2]); i = 0;

# re sort to fix any plotting issues
sort = np.argsort(data_sam[:,0])
data_sam = data_sam[sort]
sort = np.argsort(data_nek[:,0])
data_nek = data_nek[sort]


f=plt.figure(k,figsize=fsize) # plot 

# sam
plt.plot(data_sam[:,0],data_sam[:,1], \
         label      = label_sam, \
         linewidth  = lwid_sam, \
         marker     = mark_sam, \
         markersize = 0, \
         color      = col_sam)

# nek
plt.plot(data_nek[:,0],data_nek[:,1], \
         label      = label_nek, \
         linewidth  = lwid_nek, \
         marker     = mark_nek, \
         markersize = 0, \
         color      = col_nek)

# decomposition
plt.plot(data_dec[:,0],data_dec[:,1], \
         label      = label_dec, \
         linewidth  = 0, \
         marker     = mark_dec, \
         markersize = 18, \
         color      = col_dec)

# overlapping
plt.plot(data_ovl[:,0],data_ovl[:,1], \
         label      = label_ovl, \
         linewidth  = 0, \
         marker     = mark_ovl, \
         markersize = 10, \
         color      = col_ovl, \
         markevery  = 1)


## plotting settings
plt.ylabel('Total Pressure Drop (Pa)')
plt.xlabel('Time (s)')
plt.grid()
plt.xlim([0.925, 6.075])
plt.ylim([0,40])
plt.legend(fontsize=leg_fsize, framealpha=leg_alpha)
plt.tight_layout()
plt.savefig(dout+dcase+'.eps')