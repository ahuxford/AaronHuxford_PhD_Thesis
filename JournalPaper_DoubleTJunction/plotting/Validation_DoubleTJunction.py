# -*- coding: utf-8 -*-
"""
Plot all results
"""

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import StrMethodFormatter
import sys

# plotting settings
fsize = [12,6]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 26})

###############################################################################
# inputs

multiple_flows = True # for plot second and third flow throughs
conc_integrals = True # for plot conc. integrals

U_wgt_concInt = False # conc. integral, weight cfd tracer with velocity profile?

t_end = 35.2 # end time for concentration integrals

xlims = [[0,5.0],[10,35]] # xlimits for each plot

###############################################################################
###############################################################################
# import files

dname_save = '../figures/doubleTJunction/'

# experiment data, DT 1 1 15 x
exp_data = np.genfromtxt('../results/doubleTJunction/experiment/DT_1_1_15.x', delimiter='   ')
exp_tdelay = 4.5 # from Bertolotto's matlab ANS_special_issue.m time_offset array

# trace-cfx coupled
trace_cfx_data = np.genfromtxt('../results/doubleTJunction/bertolotto_traceCFX/2008_10_15_trans_1_1_tst_expl_fine_boron_00500.csv', delimiter=',',names=True)
trace_cfx_tdelay = 2.0 # from Bertolotto's matlab ANS_special_issue.m time_offset array
fact_trace_cfx = 0.01  # normalization factor

# SAM
sam_dir = '../results/doubleTJunction/sam_alone/'
sam_col = 'tab:blue'
sam_lab = r'SAM standalone'

sam_data = np.genfromtxt(sam_dir+'sam_csv.csv', delimiter=',',names=True)
sam_dict = {}
sam_dict.update({'dirs':[sam_dir]})
sam_dict.update({'time':[sam_data['time']]})
sam_dict.update({'wm1':[sam_data['tracer_WM1']]})
sam_dict.update({'wm2':[sam_data['tracer_WM2']]})
sam_dict.update({'wm3':[sam_data['tracer_WM3']]})
sam_dict.update({'color':[sam_col]})
sam_dict.update({'label':[sam_lab]})

N_sam = len(sam_dict['dirs']) # number of sam files to plot

# SAM-NekRS coupled, domain overlapping
over_dict = {}
over_dict['dir'] = ['../results/doubleTJunction/overlapping/']
over_dict['label'] = [r'SAM-NekRS coupled']
over_dict['color'] = ['tab:red']

N_over = len(over_dict['dir']) # for plotting

# extra for plotting
lwidth = 5 # line width
fsize_label = 26

###############################################################################
###############################################################################

if multiple_flows:

    for i_lim,xlim in enumerate(xlims):

        if i_lim==0:
            plt.rcParams['ytick.major.pad']='5' # y label tick padding
        elif i_lim==1:
            plt.rcParams['ytick.major.pad']='10'

        else:
            sys.exit('xlims out of index')        

        ###############################################################################
        ###############################################################################
        # Wire mesh 1 (WM1)
        ###############################################################################
        ###############################################################################
        plt.figure(figsize=fsize)

        if i_lim==0:
            plt.ylim([0,1.0])
            lstyle='--'

        elif i_lim==1:
            plt.ylim([0,0.25])
            lstyle='--'
        else:
            sys.exit('xlims out of index')
            
        # Experiment [Bertolotto] data, wire mesh 1
        plt.plot(exp_data[:,0] - exp_tdelay,exp_data[:,1],label=r'Experiment [Bertolotto]',\
                  color='black',\
                  linestyle = '-',\
                  linewidth=lwidth)

        # trace-cfx
        plt.plot(trace_cfx_data['Time'] - trace_cfx_tdelay ,trace_cfx_data['Monitor_Point_inlet_solute_2_SolIn2']/fact_trace_cfx, \
                  label=r'TRACE-CFX [Bertolotto]', \
                  color='tab:orange', \
                  linestyle=lstyle, \
                  linewidth=lwidth)
    
        # SAM standalone
        for i in range(N_sam):
            plt.plot(sam_dict['time'][i],sam_dict['wm1'][i], \
                      label=sam_dict['label'][i], \
                      color=sam_dict['color'][i], \
                      linestyle = lstyle,\
                      linewidth=lwidth)
    
        # SAM-NekRS separate-domain 
        for i in range(N_over):           
            dirname = over_dict['dir'][i]
            over_col = over_dict['color'][i]
            over_lab = over_dict['label'][i]
            over_data = np.genfromtxt(dirname+'/nek_main_out_sub0_csv.csv', delimiter=',',names=True)
        
            plt.plot(over_data['time'],over_data['toNekRS_tracer'], \
                      label=over_lab, \
                      color=over_col, \
                      linestyle=lstyle,\
                       linewidth=lwidth)
    
    
        # plotting settings
        plt.ylabel('Concentration (-)')
        plt.grid()
        plt.gca().xaxis.label.set_visible(False)
        plt.xlim(xlim)    
        
        
        if i_lim==0:
            plt.gca().yaxis.set_major_formatter(StrMethodFormatter('{x:,.1f}')) # decimal places

            legend1 = plt.legend(fontsize=23) 
            plt.legend(["WM1"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
            plt.gca().add_artist(legend1)

        else:
            plt.gca().yaxis.set_major_formatter(StrMethodFormatter('{x:,.2f}')) # decimal places

            legend1 = plt.legend(fontsize=23) 
            plt.legend(["WM1"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
            plt.gca().add_artist(legend1)        


        plt.tight_layout()
        plt.savefig(dname_save+'ConvAvg_WM1_flow'+str(i_lim)+'.eps')
        ###############################################################################
        ###############################################################################
        # Wire mesh 2 (WM2)
        ###############################################################################
        ###############################################################################
        plt.figure(figsize=fsize)
    
        # Experiment [Bertolotto] data, wire mesh 2
        plt.plot(exp_data[:,0]- exp_tdelay,exp_data[:,2],label=r'Experiment [Bertolotto]',color='black',\
                 linewidth=lwidth)

    
        # trace-cfx
        plt.plot(trace_cfx_data['Time'] - trace_cfx_tdelay ,trace_cfx_data['Monitor_Point_outlet_solute_2_SolOut2']/fact_trace_cfx, \
                  label=r'TRACE-CFX [Bertolotto]', \
                  color='tab:orange', \
                  linestyle='--',\
                  linewidth=lwidth)
    
        # SAM standalone
        for i in range(N_sam):
            plt.plot(sam_dict['time'][i],sam_dict['wm2'][i], \
                      label=sam_dict['label'][i], \
                      color=sam_dict['color'][i], \
                      linestyle = '--',\
                      linewidth=lwidth)
                
        # SAM-NekRS separate-domain    
        for i in range(N_over):           
            dirname = over_dict['dir'][i]
            over_col = over_dict['color'][i]
            over_lab = over_dict['label'][i]
            lstyle = '--'
            over_data_time = np.nan_to_num(np.genfromtxt(dirname+'/Time_avg.txt', delimiter=',')[1:,1])
            over_data_wm2  = np.nan_to_num(np.genfromtxt(dirname+'/S3_WM2_avg.txt', delimiter=',')[1:,1])
        
            plt.plot(over_data_time, over_data_wm2, \
                      label=over_lab, \
                      color=over_col, \
                      linestyle=lstyle,\
                      linewidth=lwidth)
    
    
        # plotting settings
        plt.ylabel('Concentration (-)')
        plt.grid()
        
        plt.xlim(xlim)    
    
        if i_lim==0:
            plt.ylim([0,0.6])
            plt.gca().yaxis.set_major_formatter(StrMethodFormatter('{x:,.1f}')) # decimal places
            lstyle = '--'
            
        elif i_lim==1:
            plt.ylim([0,0.2])
            plt.gca().yaxis.set_major_formatter(StrMethodFormatter('{x:,.2f}')) # 2 decimal places

        else:
            sys.exit('xlims out of index')
        
        plt.legend(["WM2"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
        plt.tight_layout()
        plt.savefig(dname_save+'ConvAvg_WM2_flow'+str(i_lim)+'.eps')
    
        ###############################################################################
        ###############################################################################
        # Wire mesh 3 (WM3)
        ###############################################################################
        ###############################################################################
        plt.figure(figsize=fsize)
    
        # Experiment [Bertolotto] data, wire mesh 3
        plt.plot(exp_data[:,0]- exp_tdelay,exp_data[:,3],label=r'Experiment [Bertolotto]',color='black',\
                 linewidth=lwidth)
    
        # trace-cfx
        plt.plot(trace_cfx_data['Time'] - trace_cfx_tdelay ,trace_cfx_data['Monitor_Point_outlet_solute_1_SolOut1']/fact_trace_cfx, \
                  label=r'TRACE-CFX [Bertolotto]', \
                  color='tab:orange', \
                  linestyle='--',\
                  linewidth=lwidth)
    
        # SAM standalone
        for i in range(N_sam):
            plt.plot(sam_dict['time'][i],sam_dict['wm3'][i], \
                      label=sam_dict['label'][i], \
                      color=sam_dict['color'][i], \
                      linestyle = '--',\
                      linewidth=lwidth)
                
        # SAM-NekRS separate-domain    
        for i in range(N_over):   
            dirname = over_dict['dir'][i]
            over_col = over_dict['color'][i]
            over_lab = over_dict['label'][i]
            lstyle = '--'
            over_data_time = np.nan_to_num(np.genfromtxt(dirname+'/Time_avg.txt', delimiter=',')[1:,1])
            over_data_wm3  = np.nan_to_num(np.genfromtxt(dirname+'/S3_WM3_avg.txt', delimiter=',')[1:,1])
        
            plt.plot(over_data_time, over_data_wm3, \
                      label=over_lab, \
                      color=over_col, \
                      linestyle=lstyle,\
                      linewidth=lwidth) 
                
        # plotting settings
        plt.ylabel('Concentration (-)')
        plt.xlabel('Time (s)')
        plt.grid()
        plt.xlim(xlim)    
    
        if i_lim==0:
            plt.ylim([0,0.5])
            plt.gca().yaxis.set_major_formatter(StrMethodFormatter('{x:,.1f}')) # decimal places

        elif i_lim==1:
            plt.ylim([0,0.1])
            plt.gca().yaxis.set_major_formatter(StrMethodFormatter('{x:,.2f}')) # decimal places
            
        else:
            sys.exit('xlims out of index')
    
        plt.legend(["WM3"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
        plt.tight_layout()
        plt.savefig(dname_save+'ConvAvg_WM3_flow'+str(i_lim)+'.eps')


###############################################################################
###############################################################################
# Concentration integrals
###############################################################################
###############################################################################

if conc_integrals:

    plt.rcParams['ytick.major.pad']='5' # y label tick padding
    
    # experiment
    exp_time  = exp_data[:,0]
    exp_dt    = np.mean(np.ediff1d(exp_time))
    exp_t_int = np.arange(0.5*exp_dt,exp_time[-1]+0.5*exp_dt,exp_dt) - exp_tdelay
    
    exp_wm1 = exp_data[:,1]
    exp_wm2 = exp_data[:,2]
    exp_wm3 = exp_data[:,3]
        
    int_wm1 = np.zeros(np.shape(exp_t_int)); int_wm2 = np.copy(int_wm1); int_wm3 = np.copy(int_wm1)
    
    # integrate
    for i,val in enumerate(exp_t_int):
        
        if val < t_end:
            # experiment
            int_wm1[i] = np.trapz(exp_wm1[:i+1],dx=exp_dt)
            int_wm2[i] = np.trapz(exp_wm2[:i+1],dx=exp_dt)
            int_wm3[i] = np.trapz(exp_wm3[:i+1],dx=exp_dt)   

    # trace-cfx
    trace_cfx_time  = trace_cfx_data['Time']
    trace_cfx_dt    = np.mean(np.ediff1d(trace_cfx_time))
    trace_cfx_t_int = np.arange(0.5*trace_cfx_dt,trace_cfx_time[-1]+0.5*trace_cfx_dt,trace_cfx_dt) - trace_cfx_tdelay
    
    trace_cfx_wm1 = trace_cfx_data['Monitor_Point_inlet_solute_2_SolIn2']/fact_trace_cfx
    trace_cfx_wm2 = trace_cfx_data['Monitor_Point_outlet_solute_2_SolOut2']/fact_trace_cfx
    trace_cfx_wm3 = trace_cfx_data['Monitor_Point_outlet_solute_1_SolOut1']/fact_trace_cfx
        
    int_wm1_trace_cfx = np.zeros(np.shape(trace_cfx_t_int)); 
    int_wm2_trace_cfx = np.copy(int_wm1_trace_cfx); 
    int_wm3_trace_cfx = np.copy(int_wm1_trace_cfx); 
    
    # integrate
    for i,val in enumerate(trace_cfx_t_int):
        
        if val < t_end:
            # experiment
            int_wm1_trace_cfx[i] = np.trapz(trace_cfx_wm1[:i+1],dx=trace_cfx_dt)
            int_wm2_trace_cfx[i] = np.trapz(trace_cfx_wm2[:i+1],dx=trace_cfx_dt)
            int_wm3_trace_cfx[i] = np.trapz(trace_cfx_wm3[:i+1],dx=trace_cfx_dt)

    # SAM standalone 
    sam_time = sam_dict['time'][0]
    dirname = sam_dict['dirs'][0]
    
    dt_sam    = sam_time[1]
    sam_t_int = np.arange(0.5*dt_sam,sam_time[-1]+0.5*dt_sam,dt_sam)
    int_wm1_sam = np.zeros(np.shape(sam_t_int));
    int_wm2_sam = np.zeros(np.shape(sam_t_int));
    int_wm3_sam = np.zeros(np.shape(sam_t_int));
    
    # integrate
    for j,val in enumerate(sam_t_int):
        
        if val < t_end: # time
            int_wm1_sam[j] = np.trapz(sam_dict['wm1'][0][:j+1],dx=dt_sam)
            int_wm2_sam[j] = np.trapz(sam_dict['wm2'][0][:j+1],dx=dt_sam)
            int_wm3_sam[j] = np.trapz(sam_dict['wm3'][0][:j+1],dx=dt_sam)
    
    
    # SAM-NekRS separate-domain
    dirname = over_dict['dir'][0]
    over_col = over_dict['color'][0]
    over_lab = over_dict['label'][0]
    lstyle = '--'
    
    over_data_time = np.nan_to_num(np.genfromtxt(dirname+'/Time_avg.txt', delimiter=',')[1:,1])


    if U_wgt_concInt: # weight CFD with velocity?
        over_wm2w = np.nan_to_num(np.genfromtxt(dirname+'/S3_WM2_avg_Uwgt.txt', delimiter=',')[1:,1])
        over_wm3w = np.nan_to_num(np.genfromtxt(dirname+'/S3_WM3_avg_Uwgt.txt', delimiter=',')[1:,1])
    else:
        over_wm2w = np.nan_to_num(np.genfromtxt(dirname+'/S3_WM2_avg.txt', delimiter=',')[1:,1])
        over_wm3w = np.nan_to_num(np.genfromtxt(dirname+'/S3_WM3_avg.txt', delimiter=',')[1:,1])

    over_data = np.genfromtxt(dirname+'/nek_main_out_sub0_csv.csv', delimiter=',',names=True)
    
    dt_over1    = np.diff(over_data['time'][1],over_data['time'][0])
    over_t_int1 = np.arange(0.5*dt_over1,over_data_time[-1]+0.5*dt_over1,dt_over1)
    
    over_wm1      = np.nan_to_num(over_data['toNekRS_tracer'])
    int_wm1_over  = np.zeros(np.shape(over_t_int1));
    
    dt_over23    = np.diff(over_data_time[1],over_data_time[0])
    over_t_int23 = np.arange(0.5*dt_over23,over_data_time[-1]+0.5*dt_over23,dt_over23)
    
    int_wm2w_over = np.zeros(np.shape(over_t_int23));
    int_wm3w_over = np.zeros(np.shape(over_t_int23));
    
    # integrate for WM1 time points
    for i,val in enumerate(over_t_int1):
        
        if val < t_end: # time
            int_wm1_over[i]  = np.trapz(over_wm1[:i+1] ,dx=dt_over1)
    
    # integrate for WM2 and WM3 time points
    for i,val in enumerate(over_t_int23):
        
        if val < t_end: # time
            int_wm2w_over[i] = np.trapz(over_wm2w[:i+1],dx=dt_over23)
            int_wm3w_over[i] = np.trapz(over_wm3w[:i+1],dx=dt_over23)
    
    

            
    ###############################################################################
    ###############################################################################
    # wire mesh sensor 1
    plt.figure(figsize=fsize)
        
    # experiment
    plt.plot(exp_t_int,int_wm1,label=r'Experiment [Bertolotto]',color='black',\
             linewidth=lwidth)

    # trace-cfx
    plt.plot(trace_cfx_t_int,int_wm1_trace_cfx,\
              label=r'TRACE-CFX [Bertolotto]', \
              color='tab:orange', \
              linestyle='--',\
              linewidth=lwidth)
        
    # SAM standalone
    plt.plot(sam_t_int,int_wm1_sam,\
              label=sam_dict['label'][0], \
              color=sam_dict['color'][0], \
              linestyle = '--',\
             linewidth=lwidth)
        
    # SAM-NekRS separate-domain
    dirname = over_dict['dir'][0]
    over_col = over_dict['color'][0]
    over_lab = over_dict['label'][0]
    lstyle = '--'
    plt.plot(over_t_int1,int_wm1_over,\
              label=over_lab, \
              color=over_col,linestyle=lstyle,\
             linewidth=lwidth)
        
    # plotting settings
    plt.ylabel('Concentration integral (-)')
    plt.grid()
    legend1 = plt.legend(loc=4,fontsize=23)
    plt.legend(["WM1"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
    plt.gca().add_artist(legend1)
    plt.xlim([0,35])
    plt.ylim([0,2.5])
    plt.tight_layout()
    plt.savefig(dname_save+'ConcInt_WM1.eps')

    
    ###############################################################################
    ###############################################################################
    # wire mesh sensor 2
    plt.figure(figsize=fsize)
    
    # experiment
    plt.plot(exp_t_int,int_wm2,label=r'Experiment [Bertolotto]',color='black',\
             linewidth=lwidth)

    # trace-cfx
    plt.plot(trace_cfx_t_int,int_wm2_trace_cfx,\
              label=r'TRACE-CFX [Bertolotto]', \
              color='tab:orange', \
              linestyle='--',\
              linewidth=lwidth)

    # SAM standalone
    plt.plot(sam_t_int,int_wm2_sam,\
              label=sam_dict['label'][0], \
              color=sam_dict['color'][0], \
              linestyle = '--', \
             linewidth=lwidth)
        
    # SAM-NekRS separate-domain
    dirname = over_dict['dir'][0]
    over_col = over_dict['color'][0]
    over_lab = over_dict['label'][0]
    lstyle = '--'
    plt.plot(over_t_int23,int_wm2w_over,\
              label=over_lab, \
              color=over_col,linestyle=lstyle,\
             linewidth=lwidth)
        
    # plotting settings
    plt.ylabel('Concentration integral (-)')
    plt.grid()
    plt.legend(["WM2"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
    plt.xlim([0,35])
    plt.ylim([0,2])
    plt.tight_layout()
    plt.savefig(dname_save+'ConcInt_WM2.eps')

    ###############################################################################
    ###############################################################################
    # wire mesh sensor 3
    plt.figure(figsize=fsize)
    
    # experiment
    plt.plot(exp_t_int,int_wm3,label=r'Experiment [Bertolotto]',color='black',\
             linewidth=lwidth)

    # trace-cfx
    plt.plot(trace_cfx_t_int,int_wm3_trace_cfx,\
              label=r'TRACE-CFX [Bertolotto]', \
              color='tab:orange', \
              linestyle='--',\
              linewidth=lwidth)

    # SAM standalone
    plt.plot(sam_t_int,int_wm3_sam,\
              label=sam_dict['label'][0], \
              color=sam_dict['color'][0], \
              linestyle = '--', \
             linewidth=lwidth)

    # SAM-NekRS separate-domain
    dirname = over_dict['dir'][0]
    over_col = over_dict['color'][0]
    over_lab = over_dict['label'][0]
    lstyle = '--'
    plt.plot(over_t_int23,int_wm3w_over,\
              label=over_lab, \
              color=over_col,linestyle=lstyle,\
             linewidth=lwidth)

    # plotting settings
    plt.ylabel('Concentration integral (-)')
    plt.xlabel('Time (s)')
    plt.grid()
    plt.legend(["WM3"], loc=2,handletextpad=0, handlelength=0,frameon=False,fontsize=fsize_label)
    plt.xlim([0,35])
    plt.ylim([0,1])
    plt.tight_layout()
    plt.savefig(dname_save+'ConcInt_WM3.eps')
