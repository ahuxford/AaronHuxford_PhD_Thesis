# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import matplotlib.pyplot as plt

fsize = [9,5]

###############################################################################
# import files

D = 0.05
R = D/2

# IMPORTANT NOTE
# I had precision issues in nekRS when using polynomial order > 10, so only use
# order <= 10!

n_poly_u = 10
n_poly_k = 10
n_poly_t = 6

data = np.genfromtxt('Time6p8_LinePlot.csv', delimiter=',',names=True)


plt.figure(figsize=fsize)

plt.plot(data['arc_length']-R,data['x_velocity'], \
          color='k', \
          linestyle = '-')
    
plt.ylabel('Velocity (-)')
plt.xlabel('Radius -)')
plt.grid()
plt.xlim([0,R])
# plt.ylim([0,0.55])
plt.tight_layout()

Rad = (data['arc_length']-R)>0
x_rad = data['arc_length'][Rad]-R
y_vel = data['x_velocity'][Rad]
y_vel[np.isnan(y_vel)] = 0

z_vel = np.polyfit(x_rad, y_vel, n_poly_u)
p_vel = np.poly1d(z_vel)

xp = np.linspace(0, R, 100)
xp_est = np.linspace(0, R, 10000)

plt.plot(xp,p_vel(xp), \
          color='red', \
          linestyle = '--')

# test normalization

plt.plot(xp,p_vel(xp)/0.424 * 0.424, \
          color='orange', \
          linestyle = '--')

    

# ###############################################################################
    
y_k = data['s1'][Rad]
y_k[np.isnan(y_k)] = 0
z_k = np.polyfit(x_rad, y_k, n_poly_k)
p_k = np.poly1d(z_k)
    
plt.figure(figsize=fsize)
plt.plot(data['arc_length']-D/2,data['s1'], \
          color='k', \
          linestyle = '-')

plt.plot(xp,p_k(xp), \
          color='red', \
          linestyle = '--')

tke_est = z_k[0]*xp_est**n_poly_k + \
          z_k[1]*xp_est**(n_poly_k-1) + \
          z_k[2]*xp_est**(n_poly_k-2) + \
          z_k[3]*xp_est**(n_poly_k-3) + \
           z_k[4]*xp_est**(n_poly_k-4) + \
           z_k[5]*xp_est**(n_poly_k-5) + \
           z_k[6]*xp_est**(n_poly_k-6) + \
           z_k[7]*xp_est**(n_poly_k-7) + \
           z_k[8]*xp_est**(n_poly_k-8) + \
           z_k[9]*xp_est**(n_poly_k-9) + \
           z_k[10]*xp_est**(n_poly_k-10)

plt.plot(xp_est,tke_est , \
          color='blue', \
          linestyle = '--')
    
plt.ylabel('tke (-)')
plt.xlabel('Radius -)')
plt.grid()
plt.xlim([0,R])
# plt.ylim([0,0.00175])
plt.tight_layout()

###############################################################################

y_tau = data['s2'][Rad]
y_tau[np.isnan(y_tau)] = 0
z_tau = np.polyfit(x_rad, y_tau, n_poly_t)
p_tau = np.poly1d(z_tau)

plt.figure(figsize=fsize)
plt.plot(data['arc_length']-D/2,data['s2'], \
          color='k', \
          linestyle = '-')

plt.plot(xp,p_tau(xp), \
          color='red', \
          linestyle = '--')
    
    
tau_est = z_tau[0]*xp_est**n_poly_t + \
          z_tau[1]*xp_est**(n_poly_t-1) + \
          z_tau[2]*xp_est**(n_poly_t-2) + \
          z_tau[3]*xp_est**(n_poly_t-3) + \
          z_tau[4]*xp_est**(n_poly_t-4) + \
          z_tau[5]*xp_est**(n_poly_t-5) + \
          z_tau[6]*xp_est**(n_poly_t-6)    
          
plt.plot(xp_est,tau_est , \
          color='blue', \
          linestyle = '--')
    
plt.ylabel('tau (-)')
plt.xlabel('Radius -)')
plt.grid()
plt.xlim([0,R])
# plt.ylim([0,0.11])
plt.tight_layout()

