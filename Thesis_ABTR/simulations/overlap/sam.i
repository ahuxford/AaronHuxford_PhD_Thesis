# Coupled SAM-STARCCM model for ABTR-PLOF transient


# loosened tolerances 2x (work at 10x)
# same solver options as SAM only test
# with correct g
# without supg_max but custom overlap tau
# with weak_bc

[GlobalParams]
    global_init_P = 1e5
    global_init_V = 1
    global_init_T = 628.15
    Tsolid_sf = 1e-3

    gravity = '0 0 -9.81' # to be consistent with starccm

  [./PBModelParams]
    scaling_velocity = 10 # used in stabilization, tau_pspg
    low_advection_limit = 0.01
    pbm_scaling_factors = '1 1e-3 1e-6'
#    supg_max = true # need for stabilization near zero velocity! found this out via testing
  [../]
[]

[Problem]
   restart_file_base = sam_checkpoint_couple_ic_cp/LATEST
[]

[EOS]
  [./eos]
  	type = PBSodiumEquationOfState
  [../]
[]

[Functions]
  [time_stepper]
    type = PiecewiseConstant
    x = '-600 -598 -550 -11  -9.95    -0.1    50   100   175  400  1000'
#    y = ' 0.1 2.0  2.0  0.01 0.05     0.01  0.02  0.05   0.1  0.1   0.1' # dt 0.01 at start of transient drops outlet temperature too much
    y = ' 0.05 0.05  0.05  0.05 0.05     0.05  0.05  0.05   0.1  0.1   0.1' # works
#    y = ' 0.1 2.0  2.0  0.01 0.05     0.05  0.05  0.05   0.05  0.05   0.05' # try smaller dt
    direction = left
  []
  [./ppf_axial]
    type = PiecewiseLinear
    x = '0.0	0.0200	0.0600	0.100	0.140	0.180	0.220	0.260	0.300	0.340  	0.380
    	0.420	0.460	0.500	0.540	0.580	0.620	0.660	0.700	0.740  	0.780 	0.800'
    y = '7.818e-1 8.12035e-1 8.72501e-1 9.43054e-1 1.01107 1.04739 1.09779 1.13790 1.16662 1.17569 1.18022
    	 1.17255 1.15267 1.13305 1.08829 1.03142 9.62681e-1 9.08601e-1 8.11380e-1 7.04156e-1 5.90929e-1 5.34316e-1'
	axis = x
  [../]

  [./power_history]
    type = PiecewiseLinear
	x ='-1.000E+03	5.000E-01	1.000E+00	1.500E+00	2.000E+00	2.500E+00	3.000E+00	3.500E+00	4.000E+00	4.500E+00
		5.000E+00	5.500E+00	6.000E+00	6.500E+00	7.000E+00	7.500E+00	8.000E+00	8.500E+00	9.000E+00	9.500E+00
		1.000E+01	1.050E+01	1.100E+01	1.150E+01	1.200E+01	1.250E+01	1.300E+01	1.350E+01	1.400E+01	1.450E+01
		1.500E+01	1.550E+01	1.600E+01	1.650E+01	1.700E+01	1.750E+01	1.800E+01	1.850E+01	1.900E+01	1.950E+01
		2.000E+01	2.500E+01	3.000E+01	3.500E+01	4.000E+01	4.500E+01	5.000E+01	5.500E+01	6.000E+01	6.500E+01
		7.000E+01	7.500E+01	8.000E+01	8.500E+01	9.000E+01	9.500E+01	1.000E+02	1.100E+02	1.200E+02	1.300E+02
		1.400E+02	1.500E+02	1.600E+02	1.700E+02	1.800E+02	1.900E+02	2.000E+02	2.100E+02	2.200E+02	2.300E+02
		2.400E+02	2.500E+02	2.600E+02	2.700E+02	2.800E+02	2.900E+02	3.000E+02	3.200E+02	3.400E+02	3.600E+02
		3.800E+02	4.000E+02	4.500E+02	5.000E+02	5.500E+02	6.000E+02	6.500E+02	7.500E+02	1.000E+03	2.000E+03
		4.000E+03	6.000E+03	8.000E+03	1.000E+04	1.500E+04	2.000E+04	2.500E+04	3.000E+04	3.500E+04	4.000E+04 1e5'

	y ='1.000E+00	1.000E+00	9.969E-01	9.892E-01	9.784E-01	1.537E-01	1.390E-01	1.292E-01	1.215E-01	1.152E-01
		1.097E-01	1.050E-01	1.008E-01	9.710E-02	9.377E-02	9.077E-02	8.807E-02	8.561E-02	8.337E-02	8.132E-02
		7.944E-02	7.771E-02	7.611E-02	7.463E-02	7.325E-02	7.197E-02	7.077E-02	6.964E-02	6.858E-02	6.758E-02
		6.663E-02	6.574E-02	6.489E-02	6.408E-02	6.331E-02	6.258E-02	6.187E-02	6.120E-02	6.055E-02	5.993E-02
		5.933E-02	5.431E-02	5.049E-02	4.741E-02	4.485E-02	4.267E-02	4.078E-02	3.914E-02	3.769E-02	3.640E-02
		3.526E-02	3.425E-02	3.334E-02	3.252E-02	3.178E-02	3.111E-02	3.051E-02	2.946E-02	2.858E-02	2.784E-02
		2.720E-02	2.665E-02	2.617E-02	2.575E-02	2.537E-02	2.502E-02	2.471E-02	2.443E-02	2.417E-02	2.393E-02
		2.370E-02	2.349E-02	2.329E-02	2.310E-02	2.292E-02	2.276E-02	2.259E-02	2.229E-02	2.201E-02	2.175E-02
		2.151E-02	2.128E-02	2.076E-02	2.029E-02	1.987E-02	1.948E-02	1.912E-02	1.847E-02	1.715E-02	1.395E-02
		1.112E-02	9.789E-03	8.994E-03	8.448E-03	7.579E-03	7.040E-03	6.657E-03	6.359E-03	6.117E-03	5.911E-03 4e-3'
  [../]

  [./pump_p_coastdown]
    type = PiecewiseLinear
	x ='-1.000E+03	0.00E+00	4.00E-01	8.00E-01	1.20E+00	1.60E+00	2.00E+00	2.40E+00	2.80E+00	3.20E+00	3.60E+00
		4.00E+00	4.40E+00	4.80E+00	5.20E+00	5.60E+00	6.00E+00	6.40E+00	6.80E+00	7.20E+00	7.60E+00
		8.000E+00	1.000E+01	2.000E+01	3.000E+01	4.000E+01	5.000E+01	6.000E+01	7.000E+01	8.000E+01	9.000E+01
		1.000E+02	1.100E+02	1.200E+02	1.300E+02	1.400E+02	1.500E+02	1.600E+02	1.700E+02	1.800E+02	1.900E+02
		2.000E+02	2.100E+02	2.200E+02	2.300E+02	2.400E+02	2.500E+02	2.600E+02	2.700E+02	2.800E+02	2.900E+02
		3.000E+02	3.100E+02	3.200E+02	3.300E+02	3.400E+02	3.500E+02	3.600E+02	3.700E+02	3.800E+02	3.900E+02
		4.000E+02	4.100E+02	4.200E+02	1.00E+05'

	y ='1.000E+00	1.000E+00	9.671E-01	9.355E-01	9.050E-01	8.757E-01	8.476E-01	8.205E-01	7.945E-01	7.695E-01	7.455E-01
		7.225E-01	7.004E-01	6.792E-01	6.590E-01	6.395E-01	6.209E-01	6.031E-01	5.860E-01	5.697E-01	5.540E-01
		5.396E-01	4.749E-01	2.753E-01	1.773E-01	1.219E-01	8.812E-02	6.655E-02	5.206E-02	4.181E-02	3.425E-02
		2.850E-02	2.401E-02	2.043E-02	1.754E-02	1.516E-02	1.317E-02	1.151E-02	1.009E-02	8.869E-03	7.816E-03
		6.898E-03	6.094E-03	5.382E-03	4.752E-03	4.192E-03	3.692E-03	3.253E-03	2.814E-03	2.480E-03	2.132E-03
		1.866E-03	1.621E-03	1.397E-03	1.190E-03	9.999E-04	8.248E-04	6.642E-04	5.175E-04	3.841E-04	2.637E-04
		1.558E-04	5.989E-05		0			0'

	scale_factor = 415100
  [../]

  [./pump_s_coastdown]
    type = PiecewiseLinear
	x ='-1.000E+03	0.00E+00	4.00E-01	8.00E-01	1.20E+00	1.60E+00	2.00E+00	2.40E+00	2.80E+00	3.20E+00	3.60E+00
		4.00E+00	4.40E+00	4.80E+00	5.20E+00	5.60E+00	6.00E+00	6.40E+00	6.80E+00	7.20E+00	7.60E+00
		8.000E+00	1.000E+01	2.000E+01	3.000E+01	4.000E+01	5.000E+01	6.000E+01	7.000E+01	8.000E+01	9.000E+01
		1.000E+02	1.100E+02	1.200E+02	1.300E+02	1.400E+02	1.500E+02	1.600E+02	1.700E+02	1.800E+02	1.900E+02
		2.000E+02	2.100E+02	2.200E+02	2.300E+02	2.400E+02	2.500E+02	2.600E+02	2.700E+02	2.800E+02	2.900E+02
		3.000E+02	3.100E+02	3.200E+02	3.300E+02	3.400E+02	3.500E+02	3.600E+02	3.700E+02	3.800E+02	3.900E+02
		4.000E+02	4.100E+02	4.200E+02	1.00E+05'

	y ='1.000E+00	1.000E+00	9.671E-01	9.355E-01	9.050E-01	8.757E-01	8.476E-01	8.205E-01	7.945E-01	7.695E-01	7.455E-01
		7.225E-01	7.004E-01	6.792E-01	6.590E-01	6.395E-01	6.209E-01	6.031E-01	5.860E-01	5.697E-01	5.540E-01
		5.396E-01	4.749E-01	2.753E-01	1.773E-01	1.219E-01	8.812E-02	6.655E-02	5.206E-02	4.181E-02	3.425E-02
		2.850E-02	2.401E-02	2.043E-02	1.754E-02	1.516E-02	1.317E-02	1.151E-02	1.009E-02	8.869E-03	7.816E-03
		6.898E-03	6.094E-03	5.382E-03	4.752E-03	4.192E-03	3.692E-03	3.253E-03	2.814E-03	2.480E-03	2.132E-03
		1.866E-03	1.621E-03	1.397E-03	1.190E-03	9.999E-04	8.248E-04	6.642E-04	5.175E-04	3.841E-04	2.637E-04
		1.558E-04	5.989E-05		0			0'

	scale_factor = 40300
  [../]

  [./flow_secondary]
    type = PiecewiseLinear
	x ='-1.000E+03	0	        1	     1e5'
	y = '-1259   	-1259   	0  		 0'
	scale_factor = 0.002216 # 1/rhoA
  [../]

  [./flow_dhx]
    type = PiecewiseLinear
	x ='-1.000E+03 	0	   1	    1e5'
	y = '0  0	-6.478 	 -6.478'
	scale_factor = 0.046 # 1/rhoA
  [../]

# coupling functions
# coupled pipe 1
  [./left_p_fn1]
    type = ParsedFunction
    expression = left_p_bc1
    symbol_names = 'left_p_bc1'
    symbol_values = left_p_bc1
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./right_p_fn]
    type = ParsedFunction
    expression = right_p_bc
    symbol_names = 'right_p_bc'
    symbol_values = right_p_bc
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./left_T_fn1]
    type = ParsedFunction
    expression = left_T_bc1
    symbol_names = 'left_T_bc1'
    symbol_values = left_T_bc1
    execute_on = 'LINEAR NONLINEAR'
  [../]
# coupled pipe 2
  [./left_p_fn2]
    type = ParsedFunction
    expression = left_p_bc2
    symbol_names = 'left_p_bc2'
    symbol_values = left_p_bc2
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./left_T_fn2]
    type = ParsedFunction
    expression = left_T_bc2
    symbol_names = 'left_T_bc2'
    symbol_values = left_T_bc2
    execute_on = 'LINEAR NONLINEAR'
  [../]
# to IHX
  [./right_T_fn]
    type = ParsedFunction
    expression = right_T_bc
    symbol_names = 'right_T_bc'
    symbol_values = right_T_bc
    execute_on = 'LINEAR NONLINEAR'
  [../]
[]

[MaterialProperties]
  [./fuel-mat]
    type = HeatConductionMaterialProps
    k = 29.3
    Cp = 191.67
    rho = 1.4583e4
  [../]
  [./gap-mat]
    type = HeatConductionMaterialProps
    k = 64
    Cp = 1272
    rho = 865
  [../]
  [./clad-mat]
    type = HeatConductionMaterialProps
    k = 26.3
    Cp = 638
    rho = 7.646e3
  [../]
  [./ss-mat]
    type = HeatConductionMaterialProps
    k = 26.3
    Cp = 638
    rho = 7.646e3
  [../]
[]

[Components]
  [./reactor]
    type = ReactorPower
    initial_power = 250e6
    power_history = power_history
  [../]

######  Primary Loop  ######

  [./CH1]
    type = PBCoreChannel
    eos = eos
    position = '0 -1 0'
    orientation = '0 0 1'

    A = 4.9237e-3
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 1
    name_of_hs = 'fuel gap clad'
    Ts_init = 628.15
    n_heatstruct = 3
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465  0.00052'
    elem_number_of_hs = '10 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'

    power_fraction = '0.02248 0.0 0.0'
    power_shape_function = ppf_axial
  [../]

  [./CH1_LP]
    type = PBPipe
    eos = eos
    position = '0 -1 -0.6'
    orientation = '0 0 1'

    A = 4.9237e-3
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005 #0.002
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]

  [./CH1_UP]
    type = PBPipe
    eos = eos
    position = '0 -1 0.8'
    orientation = '0 0 1'

    A = 4.9237e-3
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./Branch_CH1_L]
    type = PBSingleJunction
    inputs = 'CH1_LP(out)'
    outputs = 'CH1(in)'
    eos = eos
  [../]
  [./Branch_CH1_U]
    type = PBSingleJunction
    inputs = 'CH1(out)'
    outputs = 'CH1_UP(in)'
    eos = eos
  [../]

  [./CH2]
    type = PBCoreChannel
    eos = eos
    position = '0 -0.5 0'
    orientation = '0 0 1'

    A = 0.11323
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 1
    name_of_hs = 'fuel gap clad'
    Ts_init = 628.15
    n_heatstruct = 3
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465  0.00052'
    elem_number_of_hs = '10 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'

    power_fraction = '0.41924 0.0 0.0'
    power_shape_function = ppf_axial
  [../]
  [./CH2_LP]
    type = PBPipe
    eos = eos
    position = '0 -0.5 -0.6'
    orientation = '0 0 1'

    A = 0.11323
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./CH2_UP]
    type = PBPipe
    eos = eos
    position = '0 -0.5 0.8'
    orientation = '0 0 1'

    A = 0.11323
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./Branch_CH2_L]
    type = PBSingleJunction
    inputs = 'CH2_LP(out)'
    outputs = 'CH2(in)'
    eos = eos
  [../]
  [./Branch_CH2_U]
    type = PBSingleJunction
    inputs = 'CH2(out)'
    outputs = 'CH2_UP(in)'
    eos = eos
  [../]

  [./CH3]
    type = PBCoreChannel
    eos = eos
    position = '0 0 0'
    orientation = '0 0 1'

    A = 0.029539
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 1
    name_of_hs = 'fuel gap clad'
    Ts_init = 628.15
    n_heatstruct = 3
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465  0.00052'
    elem_number_of_hs = '10 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'

    power_fraction = '0.09852 0.0 0.0'
    power_shape_function = ppf_axial
  [../]
  [./CH3_LP]
    type = PBPipe
    eos = eos
    position = '0 0 -0.6'
    orientation = '0 0 1'

    A = 0.029539
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./CH3_UP]
    type = PBPipe
    eos = eos
    position = '0 0 0.8'
    orientation = '0 0 1'

    A = 0.029539
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./Branch_CH3_L]
    type = PBSingleJunction
    inputs = 'CH3_LP(out)'
    outputs = 'CH3(in)'
    eos = eos
  [../]
  [./Branch_CH3_U]
    type = PBSingleJunction
    inputs = 'CH3(out)'
    outputs = 'CH3_UP(in)'
    eos = eos
  [../]


  [./CH4]
    type = PBCoreChannel
    eos = eos
    position = '0 0.5 0'
    orientation = '0 0 1'

    A = 0.14769
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 1
    name_of_hs = 'fuel gap clad'
    Ts_init = 628.15
    n_heatstruct = 3
    fuel_type = cylinder
    width_of_hs = '0.003015 0.000465  0.00052'
    elem_number_of_hs = '10 1 1'
    material_hs = 'fuel-mat gap-mat clad-mat'

    power_fraction = '0.43116 0.0 0.0'
    power_shape_function = ppf_axial
  [../]
  [./CH4_LP]
    type = PBPipe
    eos = eos
    position = '0 0.5 -0.6'
    orientation = '0 0 1'

    A = 0.14769
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./CH4_UP]
    type = PBPipe
    eos = eos
    position = '0 0.5 0.8'
    orientation = '0 0 1'

    A = 0.14769
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

	lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./Branch_CH4_L]
    type = PBSingleJunction
    inputs = 'CH4_LP(out)'
    outputs = 'CH4(in)'
    eos = eos
  [../]
  [./Branch_CH4_U]
    type = PBSingleJunction
    inputs = 'CH4(out)'
    outputs = 'CH4_UP(in)'
    eos = eos
  [../]


  [./CH5]
    type = PBCoreChannel
    eos = eos
    position = '0 1 0'
    orientation = '0 0 1'

    A = 0.153955129
    Dh = 1.694e-3
    length = 0.8
    n_elems = 20

    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 2113.6

    dim_hs = 1
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '6.32340e-3 7.0260e-4'
    elem_number_of_hs = '6 1'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.02860 0.0'
    power_shape_function = ppf_axial
  [../]
  [./CH5_LP]
    type = PBPipe
    eos = eos
    position = '0 1 -0.6'
    orientation = '0 0 1'

    A = 0.153955129
    Dh = 1.694e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 2113.6

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.001 #0.0035
    n_wall_elems = 1
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./CH5_UP]
    type = PBPipe
    eos = eos
    position = '0 1 0.8'
    orientation = '0 0 1'

    A = 0.153955129
    Dh = 1.694e-3

    length = 1.5
    n_elems = 4
    radius_i = 0.02

    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 2113.6

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.001 #0.0035
    n_wall_elems = 1
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  [../]
  [./Branch_CH5_L]
    type = PBSingleJunction
    inputs = 'CH5_LP(out)'
    outputs = 'CH5(in)'
    eos = eos
  [../]
  [./Branch_CH5_U]
    type = PBSingleJunction
    inputs = 'CH5(out)'
    outputs = 'CH5_UP(in)'
    eos = eos
  [../]

  [./IHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
#    position = '0 1.5 5.88'
    position = '0 1.5 6.02'
    orientation = '0 0 -1'
    A = 0.766
    A_secondary = 0.517
    Dh = 0.0186
    Dh_secondary = 0.014
    length = 3.71
    n_elems = 20
	initial_V_secondary = -2

    HTC_geometry_type = Pipe # pipe model
	HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 729
    HT_surface_area_density_secondary = 1080.1

    Twall_init = 628.15
    wall_thickness = 0.0041 #0.0033

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 2
  [../]

  [./pump_pipe]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 -1.5 3.61'
    orientation = '0 0 -1'

    A = 0.132
    Dh = 0.34
    length = 4.38
    n_elems = 4
    f = 0.001
    Hw = 0
  [../]

  [./pump_discharge]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 -1.5 -0.77'
    orientation = '0 1 0'

    A = 5.36
#    A = 0.44934  # for fast convergence
    Dh = 1
    length = 1.26
    n_elems = 3
    f = 0.001
    Hw = 0
  [../]


  [./inlet_plenum]
    type = PBVolumeBranch
    center = '0 0 -0.77'
    inputs = 'pump_discharge(out)'
    outputs = 'CH1_LP(in) CH2_LP(in) CH3_LP(in) CH4_LP(in) CH5_LP(in)'
	K = '0.2     0.5	5.2	  6.0	    13.8	12480' # considered density difference
    Area = 0.44934
	volume = 3.06

    initial_P = 3e5
    initial_T = 628.15
    eos = eos
    nodal_Tbc = true
  [../]

  [./inner_mix]
    type = PBVolumeBranch
    center = '0 0 2.3'
    inputs = 'CH1_UP(out) CH2_UP(out) CH3_UP(out) CH4_UP(out)'
    outputs = 'pipe1(in)'
    K = '0.5 0.5 0.5 0.5 0.0'
    Area= 1.10819
    initial_P = 1e5
    initial_T = 628.15
    volume = 1e-3
    eos = eos
  [../]
  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 2.3'
    orientation = '0 0 1'
    A = 1.10819
    Dh = 1.18785
    length = 1e-2
    n_elems = 1
    f = 0
    Hw = 0
  [../]

  [./outer_mix]
    type = PBVolumeBranch
    center = '0 1 2.3'
    inputs = 'CH5_UP(out)'
    outputs = 'pipe2(in)'
    K = '0.5 0.0'
    Area = 1.4932
    initial_P = 1e5
    initial_T = 628.15
    volume = 1e-4
    eos = eos
  [../]
  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 1 2.3'
    orientation = '0 0 1'
    A = 1.4932
    Dh = 1.37884
    length = 1e-2
    n_elems = 1
    f = 0
    Hw = 0
  [../]

###############################
# coupling for core
###############################
  [./left_TDV1]
    type = CoupledTDV
    input = 'pipe1(out)'
    eos = eos
    p_fn = left_p_fn1
    T_fn = left_T_fn1
    weak_bc = true
  [../]

  [./left_TDJ1]
    type = CoupledPPSTDJ
    input = 'Coupled_pipe1(in)'
    eos = eos
    v_bc = 1.0
    T_bc = 628.15
    postprocessor_vbc = left_v_bc1
    postprocessor_Tbc = left_T_bc1
  [../]

  [./Coupled_pipe1]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 2.31'
#    orientation = '0 1.5 3.57'
    orientation = '0 1.5 3.71'
    # based on pipe1
    A = 1.10819
#    Dh = 1.18785
    Dh = 0.001 # decrease Dh to lower fric fact calc in SAM


#    length  = 3.8723248830644 # pipe1 to IHX primary inlet
    length  = 4.0017621118702 # pipe1 to IHX primary inlet
    n_elems = 1

    tau_supg = 0.1
    tau_pspg = 0.1

    overlap_coupled = true
    overlap_pp = fric_pp1
  [../]

  [./right_TDV1]
    type = CoupledTDV
    input = 'Coupled_pipe1(out)'
    eos  = eos
    p_fn = right_p_fn
    T_fn = right_T_fn
#    T_fn = left_T_fn1 # force outlet T to be inlet T, to remove any convection effects
    weak_bc = true
  [../]

###############################
# coupling for reflector
###############################
  [./left_TDV2]
    type = CoupledTDV
    input = 'pipe2(out)'
    eos = eos
    p_fn = left_p_fn2
    T_fn = left_T_fn2
    weak_bc = true
  [../]

  [./left_TDJ2]
    type = CoupledPPSTDJ
    input = 'Coupled_pipe2(in)'
    eos = eos
    v_bc = 1.0
    T_bc = 628.15
    postprocessor_vbc = left_v_bc2
    postprocessor_Tbc = left_T_bc2
  [../]

  [./Coupled_pipe2]
    type = PBOneDFluidComponent
    eos  = eos
    position = '0 1 2.31'
#    orientation = '0 0.5 3.57'
    orientation = '0 0.5 3.71'
    # based on pipe2
    A = 1.4932
#    Dh = 1.37884
    Dh = 0.001 # decrease Dh to lower fric fact calc in SAM

#    length  = 3.604843963336 # pipe2 to IHX primary inlet
    length  = 3.7435411043556 # pipe2 to IHX primary inlet
    n_elems = 1

    tau_supg = 0.1
    tau_pspg = 0.1

    overlap_coupled = true
    overlap_pp = fric_pp2
  [../]

  [./right_TDV2]
    type = CoupledTDV
    input = 'Coupled_pipe2(out)'
    eos  = eos
    p_fn = right_p_fn
    T_fn = right_T_fn
#    T_fn = left_T_fn2 # force outlet T to be inlet T, to remove any convection effects
    weak_bc = true
  [../]

  [./right_TDVihx]
    type = CoupledPPSTDV
    input = 'IHX(primary_in)'
    eos   = eos
    p_bc = 1.262241e+05 # initial guess
    T_bc = 790.15       # initial guess
    postprocessor_pbc = right_p_bc
    postprocessor_Tbc = right_T_bc
  [../]
###############################
# end of coupling
###############################

  [./cold_pool]
    type = PBLiquidVolume
    center = '0 0 2.3'
    inputs = 'IHX(primary_out) DHX(primary_out)'
    outputs = 'pump_pipe(in) DHX(primary_in)'

    K = '0.1 0.1 0.2 0.1'
    Area =  23.96
    volume = 152.97

    initial_level = 5.5
    initial_T = 628.15
    initial_P = 3e5
    eos = eos
    covergas_component = 'cover_gas'
  [../]
  [./cover_gas]
	type = CoverGas
	n_liquidvolume = 1
	name_of_liquidvolume = 'cold_pool'
	initial_P = 1e5
	initial_Vol = 66.77
	initial_T = 783.15
  [../]

  [./Pump_p]
    type = PBPump
    eos = eos
    inputs = 'pump_pipe(out)'
    outputs = 'pump_discharge(in)'

    K = '1. 1.'
    Area = 0.055
    initial_P = 3e5

    Head = 415100
    Head_fn = pump_p_coastdown
  [../]

######  Secondary Loop  ######
  [./pipe8]
    type = PBOneDFluidComponent
    eos = eos
#    position = '0 2.7 2.17'
    position = '0 2.7 2.31'
    orientation = '0 -1 0'

    A = 0.092
    Dh = 0.34
    length = 1
    n_elems = 3
    f = 0.001
    Hw = 0
  [../]

  [./pipe9]
    type = PBOneDFluidComponent
    eos = eos
#    position = '0 1.7 5.88'
    position = '0 1.7 6.02'
    orientation = '0 1 0'

    A = 0.092
    Dh = 0.34
    length = 1
    n_elems = 3
    f = 0.001
    Hw = 0
  [../]

  [./NaHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
#    position = '0 2.7 5.88'
    position = '0 2.7 6.02'
    orientation = '0 0 -1'
    A = 0.766
    A_secondary = 0.517
    Dh = 0.0186
    Dh_secondary = 0.014
    length = 3.71
    n_elems = 20
	initial_V_secondary = -2.8

    HTC_geometry_type = Pipe # pipe model
	HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 729
    HT_surface_area_density_secondary = 1080.1

    Twall_init = 628.15
    wall_thickness = 0.002 #0.00174, 0.0008

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 2
  [../]

  [./Branch8]
    type = PBBranch
    inputs = 'pipe8(out)'
    outputs = 'IHX(secondary_in)'
    K = '0.05 0.05'
    Area = 0.092
    initial_P = 2e5
    eos = eos
  [../]

  [./Branch9]
    type = PBBranch
    inputs = 'IHX(secondary_out)'
    outputs = 'pipe9(in)'
    K = '0.0 0.0'
    Area = 0.092
    initial_P = 2e5
    eos = eos
  [../]

  [./Branch10]
    type = PBBranch
    inputs = 'pipe9(out) '
    outputs = 'NaHX(primary_in) pipe10(in)'
    K = '0.01 0.01 0.01'
    Area = 0.092
    initial_P = 2e5
    eos = eos
  [../]

  [./Pump_s]
    type = PBPump
    eos = eos
    inputs = 'NaHX(primary_out)'
    outputs = 'pipe8(in)'

    K = '0.1 0.1'
    Area = 0.766

    initial_P = 2e5

    Head = 40300
    Head_fn = pump_s_coastdown
  [../]

  [./pipe10]
    type = PBOneDFluidComponent
    eos = eos
#    position = '0 2.7 5.88'
    position = '0 2.7 6.02'
    orientation = '0 0 1'

    A = 0.092
    Dh = 0.34
    length = 0.1
    n_elems = 2
    f = 0.01
    Hw = 0
  [../]

  [./secondary_p]
  	type = PressureOutlet
  	input = 'pipe10(out)'
  	p_bc = '1e5'
	eos = eos
  [../]

######  Power conversion loop  ######

  [./NaLoop_in]
  	type = PBTDJ
	input = 'NaHX(secondary_in)'
	v_fn = flow_secondary
  	T_bc = 596.75
	eos = eos
	weak_bc = true
  [../]

  [./NaLoop_out]
  	type = PressureOutlet
  	input = 'NaHX(secondary_out)'
  	p_bc = '1e5'
	eos = eos
  [../]

######   DRACS loop    ######
  [./DHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    position = '0 -1.5 6.04'
    orientation = '0 0 -1'
    A = 0.024
    A_secondary = 0.024
    Dh = 0.037
    Dh_secondary = 0.037
    length = 2.35
    n_elems = 10

    HTC_geometry_type = Pipe # pipe model
	HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 108.1
    HT_surface_area_density_secondary = 108.1
#	tau_supg = 0.1
#	tau_supg_secondary = 0.1

    Twall_init = 628.15
	dim_wall = 1
    wall_thickness = 0.0045
    material_wall = ss-mat

    n_wall_elems = 2
  [../]

  [./DRACS_inlet]
  	type = PBTDJ
	input = 'DHX(secondary_in)'
	v_fn = flow_dhx
  	T_bc = 450.3
	eos = eos
	weak_bc = true
  [../]
  [./DRACS_outlet]
  	type = PressureOutlet
  	input = 'DHX(secondary_out)'
	p_bc = 1.3e5
	eos = eos
  [../]
[]

[Postprocessors]
  [./pump_flow]
    type = ComponentBoundaryFlow
    input = pump_pipe(in)
  [../]
  [./IHX_primaryflow]
    type = ComponentBoundaryFlow
    input = IHX(primary_in)
  [../]
  [./IHX_secondaryflow]
    type = ComponentBoundaryFlow
    input = IHX(secondary_in)
  [../]
  [./DHX_flow]
    type = ComponentBoundaryFlow
    input = DHX(primary_in)
  [../]
  [./IHX_inlet_T]
    type = ComponentBoundaryVariableValue
    input = IHX(primary_in)
    variable = temperature
  [../]
  [./CH1_velocity]
    type = ComponentBoundaryVariableValue
    input = CH1(in)
    variable = velocity
  [../]
  [./CH2_velocity]
    type = ComponentBoundaryVariableValue
    input = CH2(in)
    variable = velocity
  [../]
  [./CH3_velocity]
    type = ComponentBoundaryVariableValue
    input = CH3(in)
    variable = velocity
  [../]
  [./CH4_velocity]
    type = ComponentBoundaryVariableValue
    input = CH4(in)
    variable = velocity
  [../]
  [./CH5_velocity]
    type = ComponentBoundaryVariableValue
    input = CH5(in)
    variable = velocity
  [../]
  [./CH1_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH1_UP(out)
  [../]
  [./CH2_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH2_UP(out)
  [../]
  [./CH3_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH3_UP(out)
  [../]
  [./CH4_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH4_UP(out)
  [../]
  [./CH5_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH5_UP(out)
  [../]
  [./CH1_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH1_UP(out)
    variable = temperature
  [../]
  [./CH2_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH2_UP(out)
    variable = temperature
  [../]
  [./CH3_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH3_UP(out)
    variable = temperature
  [../]
  [./CH4_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH4_UP(out)
    variable = temperature
  [../]
  [./CH5_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH5_UP(out)
    variable = temperature
  [../]
  [./max_Tcoolant_core]
    type = NodalExtremeValue
    block = 'CH1:pipe CH2:pipe CH3:pipe CH4:pipe'
    variable = temperature
  [../]
  [./max_Tco_core]
    type = NodalExtremeValue
    block = 'CH1:pipe CH2:pipe CH3:pipe CH4:pipe'
    variable = Tw
  [../]
  [./max_Tci_core]
    type = NodalExtremeValue
    block = 'CH1:solid:clad CH2:solid:clad CH3:solid:clad CH4:solid:clad'
    variable = T_solid
  [../]
  [./max_Tf_core]
    type = NodalExtremeValue
    block = 'CH1:solid:fuel CH2:solid:fuel CH3:solid:fuel CH4:solid:fuel'
    variable = T_solid
  [../]
  [./max_Tcoolant_Ref]
    type = NodalExtremeValue
    block = 'CH5:pipe'
    variable = temperature
  [../]
  [./max_Tco_Ref]
    type = NodalExtremeValue
    block = 'CH5:pipe'
    variable = Tw
  [../]
  [./max_Tci_Ref]
    type = NodalExtremeValue
    block = 'CH5:solid:clad'
    variable = T_solid
  [../]
  [./max_Tf_Ref]
    type = NodalExtremeValue
    block = 'CH5:solid:fuel'
    variable = T_solid
  [../]

  [./DHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'DHX:primary_pipe'
	heated_perimeter = 2.5944
  [../]
  [./IHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'IHX:primary_pipe'
	heated_perimeter = 558.414
  [../]
  [./NaHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'NaHX:secondary_pipe'
	heated_perimeter = 558.414
  [../]

# f_CFD coupling postprocessors
  [./fric_pp1]
    type = ReadFromCSV
    csv_file = CFD_fric1.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]
  [./fric_pp2]
    type = ReadFromCSV
    csv_file = CFD_fric2.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]
###############################
# Left interface, core
###############################
  [./left_p_bc1]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = Coupled_pipe1(in)
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./left_v_bc1]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe1(out)
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./left_T_bc1]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe1(out)
    execute_on = 'LINEAR NONLINEAR'
  [../]
###############################
# Left interface, reflector
###############################
  [./left_p_bc2]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = Coupled_pipe2(in)
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./left_v_bc2]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe2(out)
    execute_on = 'LINEAR NONLINEAR'
  [../]
  [./left_T_bc2]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe2(out)
    execute_on = 'LINEAR NONLINEAR'
  [../]
###############################
# Right interface, to IHX
###############################
  [./right_T_bc]
    type = ReadFromCSV
    csv_file = CFD_Tout.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]
  [./right_p_bc]
    type = ReadFromCSV
    csv_file = CFD_Pout.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]
[]

[Preconditioning]
   active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type                = SMP
    full                = true
    solve_type          = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  [../]
[] # End preconditioning block

[Executioner]
  type = CoupledCFDExecutioner

  input_data_file = CFDTOSYS.csv # empty file, but needed by executioner
  n_in_parameter = 1
  name_of_in_components = 'NaLoop_out' # not used? reference pressure
  name_of_in_parameters = 'T_bc'

  output_data_file = SYSTOCFD.csv
  n_out_parameter = 5
  name_of_out_components = 'left_TDV1 left_TDV2 left_TDV1 left_TDV2 right_TDVihx'
  name_of_out_parameters = 'massflow massflow temperature temperature massflow'
  names_of_CFD_boundary = 'CoreInlet RefInlet CoreInlet RefInlet IHXWindowOutlet'

  SYSCFDBoundaryConsistency = '1 1 1 1'
  CFD_scaling_factor = 0.25 # 1/4

  line_search = 'none'

#  scheme = bdf2
  scheme = implicit-euler # must use to have a stable solution

  # setting time step range
  [TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 1e-3
  []

#  start_time =  -600
#  end_time   =  -10
  start_time =  -100
  end_time   =  1000

#  nl_rel_tol = 1e-6
#  nl_abs_tol = 1e-5
#  l_tol      = 1e-4

  nl_rel_tol = 5e-6
  nl_abs_tol = 5e-5
  l_tol      = 5e-4

  nl_max_its =  10
  l_max_its  = 100

  [./Quadrature]
      type = TRAP
      order = FIRST
  [../]
[] # close Executioner section

[Outputs]
  print_linear_residuals = false
  print_nonlinear_residuals = false
  perf_graph             = false
  print_nonlinear_converged_reason = false
  [./console]
    type = Console
    execute_postprocessors_on = NONE
    execute_reporters_on      = NONE
    execute_scalars_on        = NONE
  [../]
  [./csv]
    type = CSV
  [../]
#  [./exo]
#    type = Exodus
#    use_displaced = true
#    interval = 10
#    sequence = false
##    output_material_properties = true
#  [../]
#  [./checkpoint_couple_ic]
#    type      = Checkpoint
#    num_files = 3
#    interval = 10
#  [../]
[]
