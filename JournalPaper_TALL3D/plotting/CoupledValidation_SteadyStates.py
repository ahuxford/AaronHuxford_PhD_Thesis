
# -*- coding: utf-8 -*-
"""
Plotting results for STH/CFD benchmark T03, with previous calibration
"""
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.legend_handler import HandlerTuple

from mpl_toolkits.axes_grid1.inset_locator import zoomed_inset_axes
from mpl_toolkits.axes_grid1.inset_locator import mark_inset

###############################################################################
color_ind = 'k'

lab_sam = 'SAM standalone'
color_sam  = 'tab:blue'

plt_zoom = True # plot zoomed in view near zero

lab_coup = 'SAM-STARCCM+ coupled'
color_coup = 'tab:red'

dT_CtoK = 0 #273.15 # convert C to K

###############################################################################
# plotting parameters
lwidth = 3 # line width
msize_sam  = 15 # marker size
msize_coup = 30 # marker size

mark_sam = 's'

fsize = [16,8]
plt.rcParams['font.family'] = 'serif'
plt.rcParams.update({'font.size': 22})
f_leg = 17.5
f_title = 24
pad_title = 10

# data information
N_state = 2
N_vals  = 9

exp_t04  = np.ones([N_state,N_vals])
exp_t03  = np.ones([N_state,N_vals])
exp_t10  = np.ones([N_state,N_vals])
sam_t04  = np.ones([N_state,N_vals])
sam_t03  = np.ones([N_state,N_vals])
sam_t10  = np.ones([N_state,N_vals])
coup_t04 = np.ones([N_state,N_vals])
coup_t03 = np.ones([N_state,N_vals])
coup_t10 = np.ones([N_state,N_vals])

# identity
identity = np.array([np.arange(-1000,1000),np.arange(-1000,1000)])
d_id_1 = 0.05 # first  line off of indentity
d_id_2 = 0.1  # second line off of indentity

dT_sig1 = 10
dT_sig2 = 20

d_lstyle_1 = (0, (9, 6))
d_lstyle_2 = (0, (1, 3))



# initial states
k = 0
# experiment, T04
exp_t04[k,0] = 2
exp_t04[k,1] = 1.3
exp_t04[k,2] = 3.3
exp_t04[k,3] = 234   + dT_CtoK
exp_t04[k,4] = 246.5 + dT_CtoK
exp_t04[k,5] = 234   + dT_CtoK
exp_t04[k,6] = 255.5 + dT_CtoK
exp_t04[k,7] = 250   + dT_CtoK
exp_t04[k,8] = 234   + dT_CtoK
# experiment, T03
exp_t03[k,0] = 2.8
exp_t03[k,1] = 1.9
exp_t03[k,2] = 4.7
exp_t03[k,3] = 272 + dT_CtoK
exp_t03[k,4] = 275 + dT_CtoK
exp_t03[k,5] = 273 + dT_CtoK
exp_t03[k,6] = 309 + dT_CtoK
exp_t03[k,7] = 291 + dT_CtoK
exp_t03[k,8] = 270 + dT_CtoK
# experiment, T10
exp_t10[k,0] = 2.9
exp_t10[k,1] = 1.7
exp_t10[k,2] = 4.6
exp_t10[k,3] = 231   + dT_CtoK
exp_t10[k,4] = 251.1 + dT_CtoK
exp_t10[k,5] = 232.6 + dT_CtoK
exp_t10[k,6] = 230   + dT_CtoK
exp_t10[k,7] = 241   + dT_CtoK
exp_t10[k,8] = 231   + dT_CtoK
# sam standalone, T04
sam_t04[k,0] = 1.883
sam_t04[k,1] = 1.402
sam_t04[k,2] = 3.284
sam_t04[k,3] = 234.94 + dT_CtoK 
sam_t04[k,4] = 246.02 + dT_CtoK
sam_t04[k,5] = 234.75 + dT_CtoK
sam_t04[k,6] = 253.87 + dT_CtoK
sam_t04[k,7] = 248.60 + dT_CtoK
sam_t04[k,8] = 235.42 + dT_CtoK
# sam standalone, T03
sam_t03[k,0] = 2.686
sam_t03[k,1] = 2.048
sam_t03[k,2] = 4.734
sam_t03[k,3] = 266.95 + dT_CtoK 
sam_t03[k,4] = 268.34 + dT_CtoK
sam_t03[k,5] = 266.79 + dT_CtoK
sam_t03[k,6] = 301.01 + dT_CtoK
sam_t03[k,7] = 281.80 + dT_CtoK
sam_t03[k,8] = 267.22 + dT_CtoK
# sam standalone, T10
sam_t10[k,0] = 2.685
sam_t10[k,1] = 1.858
sam_t10[k,2] = 4.543
sam_t10[k,3] = 220.87 + dT_CtoK 
sam_t10[k,4] = 242.41 + dT_CtoK
sam_t10[k,5] = 220.75 + dT_CtoK
sam_t10[k,6] = 220.61 + dT_CtoK
sam_t10[k,7] = 233.01 + dT_CtoK
sam_t10[k,8] = 220.95 + dT_CtoK
# sam-starccm coupled, T04
coup_t04[k,0] = 2.062
coup_t04[k,1] = 1.237
coup_t04[k,2] = 3.300
coup_t04[k,3] = 235.62 + dT_CtoK 
coup_t04[k,4] = 245.62 + dT_CtoK
coup_t04[k,5] = 234.80 + dT_CtoK
coup_t04[k,6] = 254.21 + dT_CtoK
coup_t04[k,7] = 248.32 + dT_CtoK
coup_t04[k,8] = 235.33 + dT_CtoK
# sam-starccm coupled, T03
coup_t03[k,0] = 2.928
coup_t03[k,1] = 1.829
coup_t03[k,2] = 4.757
coup_t03[k,3] = 267.99 + dT_CtoK 
coup_t03[k,4] = 269.22 + dT_CtoK
coup_t03[k,5] = 267.38 + dT_CtoK
coup_t03[k,6] = 307.38 + dT_CtoK
coup_t03[k,7] = 283.05 + dT_CtoK
coup_t03[k,8] = 268.39 + dT_CtoK
# sam-starccm coupled, T10
coup_t10[k,0] = 2.948
coup_t10[k,1] = 1.619
coup_t10[k,2] = 4.564
coup_t10[k,3] = 220.77 + dT_CtoK 
coup_t10[k,4] = 240.42 + dT_CtoK
coup_t10[k,5] = 220.65 + dT_CtoK
coup_t10[k,6] = 220.45 + dT_CtoK
coup_t10[k,7] = 232.84 + dT_CtoK
coup_t10[k,8] = 220.83 + dT_CtoK

# final states
k = 1
# experiment, T04
exp_t04[k,0] = 0.235
exp_t04[k,1] = 0.29
exp_t04[k,2] = 0.5252
exp_t04[k,3] = 206   + dT_CtoK 
exp_t04[k,4] = 289   + dT_CtoK 
exp_t04[k,5] = 207.5 + dT_CtoK 
exp_t04[k,6] = 301   + dT_CtoK 
exp_t04[k,7] = 284   + dT_CtoK 
exp_t04[k,8] = 215.6 + dT_CtoK 
# experiment, T03
exp_t03[k,0] = 0.0163855   # average
exp_t03[k,1] = 0.5508630   # average
exp_t03[k,2] = 0.5689829   # average
exp_t03[k,3] = 219.60446 + dT_CtoK   # average
exp_t03[k,4] = 333.50328 + dT_CtoK   # average
exp_t03[k,5] = 219.80    + dT_CtoK 
exp_t03[k,6] = 339.77    + dT_CtoK 
exp_t03[k,7] = 333.29    + dT_CtoK 
exp_t03[k,8] = 229.03    + dT_CtoK 
# experiment, T10
exp_t10[k,0] = 0.625
exp_t10[k,1] = -0.07
exp_t10[k,2] = 0.555
exp_t10[k,3] = 183   + dT_CtoK 
exp_t10[k,4] = 279.3 + dT_CtoK 
exp_t10[k,5] = 231.5 + dT_CtoK 
exp_t10[k,6] = 246.3 + dT_CtoK 
exp_t10[k,7] = 274   + dT_CtoK 
exp_t10[k,8] = 189.3 + dT_CtoK 
# sam standalone, T04
sam_t04[k,0] = 0.244
sam_t04[k,1] = 0.275
sam_t04[k,2] = 0.519
sam_t04[k,3] = 209.96 + dT_CtoK 
sam_t04[k,4] = 293.06 + dT_CtoK
sam_t04[k,5] = 209.57 + dT_CtoK
sam_t04[k,6] = 308.26 + dT_CtoK
sam_t04[k,7] = 295.04 + dT_CtoK
sam_t04[k,8] = 212.70 + dT_CtoK
# sam standalone, T03
sam_t03[k,0] = 0.030
sam_t03[k,1] = 0.528
sam_t03[k,2] = 0.558
sam_t03[k,3] = 224.05 + dT_CtoK 
sam_t03[k,4] = 334.19 + dT_CtoK
sam_t03[k,5] = 227.22 + dT_CtoK
sam_t03[k,6] = 359.86 + dT_CtoK
sam_t03[k,7] = 351.28 + dT_CtoK
sam_t03[k,8] = 234.22 + dT_CtoK
# sam standalone, T10
sam_t10[k,0] = 0.576
sam_t10[k,1] = -0.0360
sam_t10[k,2] = 0.540
sam_t10[k,3] = 186.95 + dT_CtoK 
sam_t10[k,4] = 287.28 + dT_CtoK
sam_t10[k,5] = 236.79 + dT_CtoK
sam_t10[k,6] = 248.55 + dT_CtoK
sam_t10[k,7] = 284.33 + dT_CtoK
sam_t10[k,8] = 189.38 + dT_CtoK
# sam-starccm coupled, T04
coup_t04[k,0] = 0.257
coup_t04[k,1] = 0.276
coup_t04[k,2] = 0.533
coup_t04[k,3] = 205.6 + dT_CtoK
coup_t04[k,4] = 286.9 + dT_CtoK
coup_t04[k,5] = 204.9 + dT_CtoK
coup_t04[k,6] = 301.7 + dT_CtoK
coup_t04[k,7] = 288.1 + dT_CtoK
coup_t04[k,8] = 211.6 + dT_CtoK 
# sam-starccm coupled, T03
coup_t03[k,0] = 0.038
coup_t03[k,1] = 0.5235
coup_t03[k,2] = 0.5615
coup_t03[k,3] = 224.4 + dT_CtoK 
coup_t03[k,4] = 325.4 + dT_CtoK 
coup_t03[k,5] = 227.1 + dT_CtoK 
coup_t03[k,6] = 362   + dT_CtoK 
coup_t03[k,7] = 350   + dT_CtoK 
coup_t03[k,8] = 234   + dT_CtoK 
# sam-starccm coupled, T10
coup_t10[k,0] = 0.592
coup_t10[k,1] = -0.044
coup_t10[k,2] = 0.548
coup_t10[k,3] = 187.86 + dT_CtoK 
coup_t10[k,4] = 285.54 + dT_CtoK
coup_t10[k,5] = 239.87 + dT_CtoK
coup_t10[k,6] = 253.29 + dT_CtoK
coup_t10[k,7] = 282.66 + dT_CtoK
coup_t10[k,8] = 189.36 + dT_CtoK


###############################################################################
###############################################################################
fig, axs = plt.subplots(1, 2, figsize=fsize)
# flow rate
k = 0

axs[k].plot(identity[0,:],
          identity[1,:], \
          color     = color_ind, \
          linestyle = '-', \
          linewidth = lwidth, \
          )   

p1, = axs[k].plot(identity[0,:],
          identity[1,:]*(1+d_id_1), \
          color     = color_ind, \
          linestyle = d_lstyle_1, \
          )   

axs[k].plot(identity[0,:],
          identity[1,:]*(1-d_id_1), \
          color     = color_ind, \
          linestyle = d_lstyle_1, \
          )   

p2, = axs[k].plot(identity[0,:],
          identity[1,:]*(1+d_id_2), \
          color     = color_ind, \
          linestyle = d_lstyle_2, \
          )   

axs[k].plot(identity[0,:],
          identity[1,:]*(1-d_id_2), \
          color     = color_ind, \
          linestyle = d_lstyle_2, \
          )

#axs[k].plot(identity_fm[0,:],
#          identity_fm[1,:]*(1 + abs(FM_uncertainty(identity_fm[1,:])/100)), \
#                  color     = 'tab:orange', \
#          linestyle = '--', \
#          )
#
#axs[k].plot(identity_fm[0,:],
#          identity_fm[1,:]*(1 - abs(FM_uncertainty(identity_fm[1,:])/100)), \
#                  color     = 'tab:orange', \
#          linestyle = '--', \
#          )
#print(FM_uncertainty(identity_fm[1,:]))
#
#print(identity_fm[1,:]*(1 + FM_uncertainty(identity_fm[1,:])/100))

# SAM standalone
p3 = axs[k].plot(sam_t04[:,:3],
          exp_t04[:,:3], \
          color     = color_sam, \
          linestyle = '', \
          marker = mark_sam , \
          markersize = msize_sam,\
          mec = 'k'
          )    

axs[k].plot(sam_t03[:,:3],
          exp_t03[:,:3], \
          color     = color_sam, \
          linestyle = '', \
          marker = mark_sam , \
          markersize = msize_sam,\
          mec = 'k'
          )    

axs[k].plot(sam_t10[:,:3],
          exp_t10[:,:3], \
          color     = color_sam, \
          linestyle = '', \
          marker = mark_sam , \
          markersize = msize_sam,\
          mec = 'k'
          )    

# SAM-STARCCM coupled
p4 = axs[k].plot(coup_t04[:,:3],
          exp_t04[:,:3], \
          color     = color_coup, \
          linestyle = '', \
          marker = '.', \
          markersize = msize_coup,\
          mec = 'k'
          )    

axs[k].plot(coup_t03[:,:3],
          exp_t03[:,:3], \
          color     = color_coup, \
          linestyle = '', \
          marker = '.', \
          markersize = msize_coup,\
          mec = 'k'
          )  

axs[k].plot(coup_t10[:,:3],
          exp_t10[:,:3], \
          color     = color_coup, \
          linestyle = '', \
          marker = '.', \
          markersize = msize_coup,\
          mec = 'k'
          )  


axs[k].set_aspect('equal', 'box')
axs[k].axis(xmin=-0.15,xmax=5.0)
axs[k].axis(ymin=-0.15,ymax=5.0)
axs[k].set_xlabel('Model')
axs[k].set_ylabel('Experiment')
axs[k].set_title('Leg LBE flow rates (kg/s)', fontsize=f_title, pad=pad_title)
axs[k].grid()  
axs[k].legend([p1, p2],
              [r'$\pm$ '+str(round(100*d_id_1))+'$\%$',
                r'$\pm$ '+str(round(100*d_id_2))+'$\%$'],
              handler_map={tuple: HandlerTuple(ndivide=None)},
              loc='upper left',
              fontsize=f_leg+4,
              framealpha = 1)

# zoomed in view
if plt_zoom:
    axins = zoomed_inset_axes(axs[k],2.5,loc=4)
    axins.set_xlim(-0.15,0.7)
    axins.set_ylim(-0.15,0.7)
    axins.grid()
    axins.set_aspect('equal', 'box')
    plt.xticks(visible=False)
    plt.yticks(visible=False)
    # identity
    axins.plot(identity[0,:],
              identity[1,:], \
              color     = color_ind, \
              linestyle = '-', \
              linewidth = lwidth, \
              )
    axins.plot(identity[0,:],
              identity[1,:]*(1+d_id_1), \
              color     = color_ind, \
              linestyle = d_lstyle_1, \
              )
    axins.plot(identity[0,:],
              identity[1,:]*(1-d_id_1), \
              color     = color_ind, \
              linestyle = d_lstyle_1, \
              )  
    axins.plot(identity[0,:],
              identity[1,:]*(1+d_id_2), \
              color     = color_ind, \
              linestyle = d_lstyle_2, \
              )
    axins.plot(identity[0,:],
              identity[1,:]*(1-d_id_2), \
              color     = color_ind, \
              linestyle = d_lstyle_2, \
              ) 
#    axins.plot(identity_fm[0,:],
#              identity_fm[1,:]*(1 + FM_uncertainty(identity_fm[1,:])/100), \
#              color     = 'tab:orange', \
#              linestyle = '--', \
#              )
#    axins.plot(identity_fm[0,:],
#              identity_fm[1,:]*(1 - FM_uncertainty(identity_fm[1,:])/100), \
#              color     = 'tab:orange', \
#              linestyle = '--', \
#              )

    # sam standalone
    axins.plot(sam_t04[:,:3],
              exp_t04[:,:3], \
              color     = color_sam, \
              linestyle = '', \
              marker = mark_sam , \
              markersize = msize_sam,\
              mec = 'k'
              )
    axins.plot(sam_t03[:,:3],
              exp_t03[:,:3], \
              color     = color_sam, \
              linestyle = '', \
              marker = mark_sam , \
              markersize = msize_sam,\
              mec = 'k'
              )   
    axins.plot(sam_t10[:,:3],
              exp_t10[:,:3], \
              color     = color_sam, \
              linestyle = '', \
              marker = mark_sam , \
              markersize = msize_sam,\
              mec = 'k'
              )  
    # SAM-STARCCM coupled
    axins.plot(coup_t04[:,:3],
              exp_t04[:,:3], \
              color     = color_coup, \
              linestyle = '', \
              marker = '.', \
              markersize = msize_coup,\
              mec = 'k'
              )    
    axins.plot(coup_t03[:,:3],
              exp_t03[:,:3], \
              color     = color_coup, \
              linestyle = '', \
              marker = '.', \
              markersize = msize_coup,\
              mec = 'k'
              )    
    axins.plot(coup_t10[:,:3],
              exp_t10[:,:3], \
              color     = color_coup, \
              linestyle = '', \
              marker = '.', \
              markersize = msize_coup,\
              mec = 'k'
              )    

    mark_inset(axs[k], axins, loc1=3, loc2=4, fc="none", ec='0.5')

###############################################################################
###############################################################################
# temperature
k = 1

axs[k].plot(identity[0,:],
          identity[1,:], \
          color     = color_ind, \
          linestyle = '-', \
          linewidth = lwidth, \
          )   

p1, = axs[k].plot(identity[0,:],
          identity[1,:]+dT_sig1, \
          color     = color_ind, \
          linestyle = d_lstyle_1, \
          )   

axs[k].plot(identity[0,:],
          identity[1,:]-dT_sig1, \
          color     = color_ind, \
          linestyle = d_lstyle_1, \
          )   

p2, = axs[k].plot(identity[0,:],
          identity[1,:]+dT_sig2, \
          color     = color_ind, \
          linestyle = d_lstyle_2, \
          )   

axs[k].plot(identity[0,:],
          identity[1,:]-dT_sig2, \
          color     = color_ind, \
          linestyle = d_lstyle_2, \
          )   

# SAM standalone
p3 = axs[k].plot(sam_t04[:,3:],
          exp_t04[:,3:], \
          color     = color_sam, \
          linestyle = '', \
          marker = mark_sam, \
          markersize = msize_sam,\
          mec = 'k'
          )    

axs[k].plot(sam_t03[:,3:],
          exp_t03[:,3:], \
          color     = color_sam, \
          linestyle = '', \
          marker = mark_sam, \
          markersize = msize_sam,\
          mec = 'k'
          )    

axs[k].plot(sam_t10[:,3:],
          exp_t10[:,3:], \
          color     = color_sam, \
          linestyle = '', \
          marker = mark_sam, \
          markersize = msize_sam,\
          mec = 'k'
          )  

# SAM-STARCCM coupled
p4 = axs[k].plot(coup_t04[:,3:],
          exp_t04[:,3:], \
          color     = color_coup, \
          linestyle = '', \
          marker = '.', \
          markersize = msize_coup,\
          mec = 'k'
          )    
 
axs[k].plot(coup_t03[:,3:],
          exp_t03[:,3:], \
          color     = color_coup, \
          linestyle = '', \
          marker = '.', \
          markersize = msize_coup,\
          mec = 'k'
          )  
 
axs[k].plot(coup_t10[:,3:],
          exp_t10[:,3:], \
          color     = color_coup, \
          linestyle = '', \
          marker = '.', \
          markersize = msize_coup,\
          mec = 'k'
          )  

axs[k].set_aspect('equal', 'box')
axs[k].axis(xmin=175+dT_CtoK,xmax=375+dT_CtoK)
axs[k].axis(ymin=175+dT_CtoK,ymax=375+dT_CtoK)
axs[k].set_xlabel('Model')
axs[k].set_ylabel('Experiment')
axs[k].set_title('Leg inlet/outlet temperatures ($\degree$C)', fontsize=f_title, pad=pad_title)
#axs[k].set_title('Leg inlet/outlet temperatures (K)', fontsize=f_title, pad=pad_title)
axs[k].grid()   
axs[k].legend([p1, p2, p3[0], p4[0]],
              ['$\pm$ '+str(dT_sig1)+' $\degree$C',
                '$\pm$ '+str(dT_sig2)+' $\degree$C',
                lab_sam,
                lab_coup],
              handler_map={tuple: HandlerTuple(ndivide=None)},
              loc='upper left',
              fontsize=f_leg,
              framealpha = 1)
plt.tight_layout()
plt.savefig('../figures/steadyStateValidation/identityplot.eps')


# calculate L2 norms

# sam standalone
sam_FR = np.sum([np.power((exp_t03[:,:3]    - sam_t03[:,:3]),2)\
                   ,np.power((exp_t04[:,:3] - sam_t04[:,:3]),2)\
                   ,np.power((exp_t10[:,:3] - sam_t10[:,:3]),2)])

sam_TC = np.sum([np.power((exp_t03[:,3:]    - sam_t03[:,3:]),2)\
                   ,np.power((exp_t04[:,3:] - sam_t04[:,3:]),2)\
                   ,np.power((exp_t10[:,3:] - sam_t10[:,3:]),2)])
    
sam_norm_FR = np.sqrt(sam_FR)
sam_norm_TC = np.sqrt(sam_TC)

sam_relerror = np.sum([np.power((exp_t03[:,:3]    - sam_t03[:,:3]),2)\
                   ,np.power((exp_t04[:,:3] - sam_t04[:,:3]),2)\
                   ,np.power((exp_t10[:,:3] - sam_t10[:,:3]),2)])


# SAM-STARCCM coupled
coup_FR = np.sum([np.power((exp_t03[:,:3]   - coup_t03[:,:3]),2)\
                   ,np.power((exp_t04[:,:3] - coup_t04[:,:3]),2)\
                   ,np.power((exp_t10[:,:3] - coup_t10[:,:3]),2)])

coup_TC = np.sum([np.power((exp_t03[:,3:]   - coup_t03[:,3:]),2)\
                   ,np.power((exp_t04[:,3:] - coup_t04[:,3:]),2)\
                   ,np.power((exp_t10[:,3:] - coup_t10[:,3:]),2)])


coup_norm_FR = np.sqrt(coup_FR)
coup_norm_TC = np.sqrt(coup_TC)

#
# take the square root of the sum of squares to obtain the L2 norm

print('FR L2 norms')
print(sam_norm_FR,coup_norm_FR)


print('TC L2 norms')
print(sam_norm_TC,coup_norm_TC)

#
#
#def FM_uncertainty(flowrate):
#    '''
#    Flow meter uncertainty as a function of flow rate
#    - Source: Yokogawa Technical Report English Edition Vol.53 No.2 (2010)
#
#    - Input: flow rate in kg/s
#    - Output: accuracy/uncertainty in percent
#    '''
#
#    zero_stab = 0.5          # kg/h
##    zero_stab = 100        # kg/h
#    zs_kgs = zero_stab/60/60 # kg/s
#
#    accuracy = np.ones(np.shape(flowrate))
#
#    for i,val in enumerate(flowrate):
#
#        if abs(val) < 0.005: val=np.sign(val)*0.005
#
#    accuracy[i] = 0.1 + 100*(zs_kgs/val)
#
#    return accuracy
#
#print(FM_uncertainty(np.array([0.3])))
#
##identity_fm = np.array([np.arange(-2,5.1,0.1),np.arange(-2,5.1,0.1)])
#
