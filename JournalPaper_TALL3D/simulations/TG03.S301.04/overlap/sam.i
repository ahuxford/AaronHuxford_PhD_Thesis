[Problem]
   restart_file_base = sam_checkpoint_cp/LATEST
[]

# form losses, K
K_MH         = 12 #10 #5
KR_MH        = 12 #10 #5
K_TS         = 25
KR_TS        = 25
K_HX         = 90
KR_HX        = 90

h_hx         = 720        # htc on secondary side of HX
init_Vsecond = -0.305818  # 0.25 kg/s in secondary loop
Q_PM         = 1.447e6    # 330 W total at 3.3 kg/s

# heating powers
Q_MH         = 3.2e3    # main heater

#P_HEAD       = 1.325e+05 # K_HX 75
#P_HEAD       = 1.4e+05 # K_HX 85
P_HEAD       = 1.5e+05 # K_HX 90
#P_HEAD       = 1.675e+05 # K_HX 100


# inputs previously set
init_Tsolid  = 512.0

# htc, h
h_air  = 10.0
h_pump = 26.0
w_pump = 0.003

# solid properties
rSS316    = 7840.0
rTapeLock = 80.0
cTapeLock = 920.0
rNano     = 280.0
cNano     = 1000.0

[GlobalParams]
  global_init_P = 1.3e5          # Global initial fluid pressure
  global_init_V = 0.5           # Global initial fluid velocity
  global_init_T = 512            #  Global initial temperature for fluid and solid
  Tsolid_sf     = 1e-1

  supg_max = true # NEEDED FOR OVERLAPPING COUPLING DURING REVERSED FLOW!!!

  [PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
  [../]
[]
[Functions]
  [time_stepper]
    type = PiecewiseLinear
    x = '0     9    10    50    51  1500   1510  10000'
#    y = '0.1  0.1  0.05  0.05  0.1  0.1  0.05  0.05  0.05' # ~ converged timestep, maybe?
#    y = '0.1  0.1  0.05  0.05  0.05  0.05  0.1   0.1'
    y = '0.1  0.1  0.1  0.1  0.1  0.1  0.2   0.2'
#    x = '0     9    10    750  760  1500   1510  10000'
#    y = '0.1  0.1  0.05  0.05  0.1  0.1  0.2   0.2'
  []
  [./pump_head_fn]
    type         = PiecewiseLinear
    x            = '-10000  10    12   10000'
    y            = '1.0    1.0  0.0   0.0'
    scale_factor = ${P_HEAD}
  [../]
  [./pump_heating_source]
    type         = PiecewiseLinear
    x            = '-10000  10   12  10000'
    y            = '1.0    1.0  1.0   1.0' # keep on since short transient
    scale_factor = ${Q_PM}
  [../]
  [./SS316-k]
    type = PiecewiseLinear
    x    = '300	400	500	600	700	800	900	1000	1100	1200	1300	1400	1500	1600'
    y    = '13.961	15.532	17.103	18.674	20.245	21.816	23.387	24.958	26.529	28.100	29.671	31.242	32.813	34.384'
  [../]
  [./SS316-cp]
    type = PiecewiseLinear
    x    = '300	400	500	600	700	800	900	1000	1100	1200	1300	1400	1500	1600'
    y    = '498.82	512.10	525.38	538.66	551.94	565.22	578.50	591.78	605.06	618.34	631.63	644.91	658.19	671.47'
  [../]
  [./TLock-k]
    type = PiecewiseLinear
    x    = '283.15	323.15	373.15	473.15	573.15	673.15	773.15'
    y    = '0.033	  0.036	  0.043	  0.062	  0.092	  0.13	  0.179'
  [../]
  [./ultra-k]
    type = PiecewiseLinear
    x    = '273.15 323.15 373.15 473.15 573.15 673.15 773.15 873.15 973.15 1073.15'
    y    = '0.017  0.018  0.019  0.02   0.022  0.024  0.027  0.031  0.035  0.04'
  [../]
# coupling functions
  [./left_p_fn]
    type = ParsedFunction
    expression = left_p_bc
    symbol_names = 'left_p_bc'
    symbol_values = left_p_bc
  [../]
  [./right_p_fn]
    type = ParsedFunction
    expression = right_p_bc
    symbol_names = 'right_p_bc'
    symbol_values = right_p_bc
  [../]
  [./left_T_fn]
    type = ParsedFunction
    expression = left_T_bc
    symbol_names = 'left_T_bc'
    symbol_values = left_T_bc
  [../]
  [./right_T_fn]
    type = ParsedFunction
    expression = right_T_bc
    symbol_names = 'right_T_bc'
    symbol_values = right_T_bc
  [../]
[]
[EOS]
  [./LBE]
    type = LeadBismuthEquationOfState
    metal_type = LBE
  [../]
  [./Oil]
    type      = SaltEquationOfState
    salt_type = DowthermRP
  [../]
[]
[MaterialProperties]
  [./SSL-316]
    type = HeatConductionMaterialProps
    k    = SS316-k
    Cp   = SS316-cp
    rho  = ${rSS316}
  [../]
  [./TLock-7730]
    type = HeatConductionMaterialProps
    k    = TLock-k
    Cp   = ${cTapeLock}
    rho  = ${rTapeLock}
  [../]
  [./NanoT]
    type = HeatConductionMaterialProps
    k    = ultra-k
    Cp   = ${cNano}
    rho  = ${rNano}
    # Cp   = 1000
    # rho  = 250.0
  [../]
[]
[ComponentInputParameters]
  [./ref-main-pipe] # nominal pipe
    type              = PBPipeParameters
    eos               = LBE
    A                 = 6.09610E-04
    Dh                = 2.7860E-02
    radius_i          = 1.3930E-2
    hs_type           = cylinder
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = '0.00277 0.0608'
    n_wall_elems      = '2 4'
    material_wall     = 'SSL-316 TLock-7730'
    HS_BC_type        = Convective
    T_amb             = 298.15
    h_amb             = ${h_air}
    heat_source       = 0
    heat_source_solid = 0
  [../]
  [./ref-pump-channel] # assume no heat loss to ambient, in reality no thermal insulation to the EPM pump
    type              = PBPipeParameters
    eos               = LBE
    A                 = 4.3200E-04
    Dh                = 1.3935E-02
    heat_source       = pump_heating_source
    hs_type           = plate
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = ${w_pump}
    n_wall_elems      = '2'
    material_wall     = 'SSL-316'
    HS_BC_type        = Convective
    T_amb             = 298.15
    h_amb             = ${h_pump}
  [../]
  [./ref-pump-channel-horizontal] # assume no heat loss to ambient, in reality no thermal insulation to the EPM pump
    type              = PBPipeParameters
    eos               = LBE
    A                 = 4.3200E-04
    Dh                = 1.3935E-02
    heat_source       = 0
    hs_type           = plate
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = '0.003'
    n_wall_elems      = '2'
    material_wall     = 'SSL-316'
    HS_BC_type        = Adiabatic
  [../]
  [./ref-3d-inlet-pipe] # inlet pipe to the 3D test section: pipe diameter is different with the nominal pipe
    type              = PBPipeParameters
    eos               = LBE
    A                 = 2.26980E-04
    Dh                = 0.017
    radius_i          = 0.0085
    hs_type           = cylinder
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = '0.003 0.0625'
    n_wall_elems      = '2 4'
    material_wall     = 'SSL-316 TLock-7730'
    HS_BC_type        = Convective
    T_amb             = 298.15
    h_amb             = ${h_air}
    heat_source       = 0
    heat_source_solid = 0
  [../]
  [./ref-main-heater] # main heater channel, flow area is smaller due to the heater rod
    type              = PBPipeParameters
    eos               = LBE
    A                 = 5.56154E-04
    Dh                = 0.01961
    radius_i          = 1.3930E-2
    hs_type           = cylinder
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = '0.00277 0.0608'
    n_wall_elems      = '2 4'
    material_wall     = 'SSL-316 TLock-7730'
    HS_BC_type        = Convective
    T_amb             = 298.15
    h_amb             = ${h_air}
    heat_source       = 0
    heat_source_solid = 0
  [../]
  [./ref-secondary] # pipe in secondary loop
    type              = PBPipeParameters
    eos               = Oil
    A                 = 8.36924e-4
    Dh                = 3.264360171e-2
    hs_type           = cylinder
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = '0.00277 0.0608'
    n_wall_elems      = '2 4'
    material_wall     = 'SSL-316 TLock-7730'
    HS_BC_type        = Convective
    T_amb             = 298.15
    h_amb             = ${h_air}
    heat_source       = 0
    heat_source_solid = 0
  [../]
[]
[Components]
  #=============================================================================
  # Main heater (MH) leg
  #=============================================================================
  [./MH-11b] # section 11 horizontal pipe
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '0 0 0'
    orientation      = '-1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-11b1a] # bottom-left elbow junction
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-11b(out)'
    outputs   = 'MH-1a(in)'
  [../]
  [./MH-1a] # section 1 horizontal pipe
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '-0.37 0 0'
    orientation      = '-1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-1a1b]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-1a(out)'
    outputs   = 'MH-1b(in)'
  [../]
  [./MH-1b] # main heater channel: unheated section
    type             = PBPipe
    input_parameters = ref-main-heater
    length           = 0.73
    position         = '-0.74 0 0'
    orientation      = '0 0 1'
    n_elems          = 6
  [../]
  [./MH-1b-inner-rod] # inner rod in the main heater channel: unheated section
    type                          = PBCoupledHeatStructure
    length                        = 0.73
    position                      = '-0.74 0 0'
    orientation                   = '0 0 1'
    hs_type                       = cylinder
    width_of_hs                   = 4.125e-3
    elem_number_radial            = 3
    elem_number_axial             = 6
    dim_hs                        = 2
    material_hs                   = 'SSL-316'
    Ts_init                       = ${init_Tsolid}
    HS_BC_type                    = 'Adiabatic Coupled'
    name_comp_right               = MH-1b
    HT_surface_area_density_right = 46.60246
    radius_i                      = 0.0
    HTC_geometry_type_right       = 'Pipe'
  [../]
  [./SNJ-1b1c]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-1b(out)'
    outputs   = 'MH-1c(in)'
  [../]
  [./MH-1c] # main heater channel: heated section
    type             = PBPipe
    input_parameters = ref-main-heater
    length           = 0.87
    position         = '-0.74 0 0.73'
    orientation      = '0 0 1'
    n_elems          = 10
  [../]
  [./MH-1c-inner-rod] # main heater rod: heated section
    type                          = PBCoupledHeatStructure
    length                        = 0.87
    position                      = '-0.74 0 0.73'
    orientation                   = '0 0 1'
    dim_hs                        = 2
    radius_i                      = 0.0
    hs_type                       = cylinder
    elem_number_radial            = 3
    elem_number_axial             = 10
    width_of_hs                   = 4.125e-3
    material_hs                   = SSL-316
    hs_power                      = ${Q_MH}
    Ts_init                       = ${init_Tsolid}
    HS_BC_type                    = 'Adiabatic Coupled'
    name_comp_right               = MH-1c
    HT_surface_area_density_right = 46.60246
    HTC_geometry_type_right       = 'Pipe'
  [../]
  [./SNJ-1c1d]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-1c(out)'
    outputs   = 'MH-1d(in)'
  [../]
  [./MH-1d] # vertical pipe above main heater
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 1.041
    position         = '-0.74 0 1.6'
    orientation      = '0 0 1'
    n_elems          = 6
  [../]
  [./SNJ-1d2]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-1d(out)'
    outputs   = 'MH-2(in)'
  [../]
  [./MH-2] # section 2 vertical pipe
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 2.349
    position         = '-0.74 0 2.641'
    orientation      = '0 0 1'
    n_elems          = 8
  [../]
  [./SNJ-23a]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-2(out)'
    outputs   = 'MH-3a(in)'
  [../]
  [./MH-3a] # section 3 vertical pipe below valve
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.363
    position         = '-0.74 0 4.99'
    orientation      = '0 0 1'
    n_elems          = 2
  [../]
  [./MH-valve]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-3a(out)'
    outputs   = 'MH-3b(in)'
    K         = ${K_MH}
    K_reverse = ${KR_MH}
  [../]
  [./MH-3b] # section 3 vertical pipe above valve
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.479
    position         = '-0.74 0 5.353'
    orientation      = '0 0 1'
    n_elems          = 4
  [../]
  [./MH-3d] # vertical pipe connecting to the tank
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.2
    position         = '-0.74 0 5.832'
    orientation      = '0 0 1'
    n_elems          = 2
  [../]
  [./tank] # LBE tank: provide pressure boundary condition to the primary loop
    type  = PBTDV
    input = 'MH-3d(out)'
    eos   = LBE
    T_bc  = 512.0
    p_bc  = 1.3e5
  [../]
  [./BRJ-3bcd]
    type    = PBBranch
    inputs  = 'MH-3b(out)'
    outputs = 'MH-3c(in) MH-3d(in)'
    K       = '0.0 0.0 0.0'
    Area    = 6.0961E-04
    eos     = LBE
  [../]
  [./MH-3c] # horizontal connection between main heater leg and 3D leg
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '-0.74 0 5.832'
    orientation      = '1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-3c4c]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'MH-3c(out)'
    outputs   = 'MH-4c(in)'
  [../]
  [./MH-4c] # horizontal connection between main heater leg and 3D leg
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '-0.37 0 5.832'
    orientation      = '1 0 0'
    n_elems          = 2
  [../]
  #=============================================================================
  # Heat exchanger leg
  #=============================================================================
  [./HX-5c] # horizontal connection between TS leg and HX leg
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '0 0 5.832'
    orientation      = '1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-5c6a]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-5c(out)'
    outputs   = 'HX-6a(in)'
  [../]
  [./HX-6a] # horizontal connection between TS leg and HX leg
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '0.37 0 5.832'
    orientation      = '1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-6a6b]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-6a(out)'
    outputs   = 'HX-6b(in)'
  [../]
  [./HX-6b] # Vertical HX inlet pipe
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.289
    position         = '0.74 0 5.832'
    orientation      = '0 0 -1'
    n_elems          = 3
  [../]
  [./SNJ-6b6c]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-6b(out)'
    outputs   = 'HX-6c(in)'
  [../]
  [./HX-6c] # heat exchanger inner tube: primary side flow channel
    type              = PBOneDFluidComponent
    eos               = LBE
    A                 = 2.55601E-04
    Dh                = 0.01804
    length            = 0.996
    position          = '0.74 0 5.543'
    orientation       = '0 0 -1'
    n_elems           = 10
  [../]
  [./HX-inner-wall] # heat exchanger heat structure between primary and secondary side flow
    type                          = PBCoupledHeatStructure
    length                        = 0.996
    position                      = '0.74 0 5.543'
    orientation                   = '0 0 -1'
    dim_hs                        = 2
    radius_i                      = 0.00902
    hs_type                       = cylinder
    elem_number_radial            = 3
    elem_number_axial             = 10
    width_of_hs                   = 0.00165
    material_hs                   = SSL-316
    Ts_init                       = ${init_Tsolid}
    HS_BC_type                    = 'Coupled Coupled'
    name_comp_left                = HX-6c
    HT_surface_area_density_left  = 2.21729E+02
    HTC_geometry_type_left        = 'Pipe'
    name_comp_right               = S2
    HT_surface_area_density_right = 8.01048E+01
    HTC_geometry_type_right       = 'Pipe'
    Hw_right                      = ${h_hx} # overwrite htc on secondary side
  [../]
  [./SNJ-6c6d]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-6c(out)'
    outputs   = 'HX-6d(in)'
  [../]
  [./HX-6d] # vertical pipe below heat exchanger
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.511
    position         = '0.74 0 4.547'
    orientation      = '0 0 -1'
    n_elems          = 3
  [../]
  [./SNJ-6d7a]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-6d(out)'
    outputs   = 'HX-7a(in)'
  [../]
  [./HX-7a] # vertical pipe above HX valve
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.778
    position         = '0.74 0 4.036'
    orientation      = '0 0 -1'
    n_elems          = 3
  [../]
  [./HX-valve]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-7a(out)'
    outputs   = 'HX-7b(in)'
    K         = ${K_HX}
    K_reverse = ${KR_HX}
  [../]
  [./HX-7b] # vertical pipe below HX valve
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.593
    position         = '0.74 0 3.258'
    orientation      = '0 0 -1'
    n_elems          = 3
  [../]
  [./SNJ-7b8a]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-7b(out)'
    outputs   = 'HX-8a(in)'
  [../]
  [./HX-8a] # vertical pipe above EPM pump
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.622
    position         = '0.74 0 2.665'
    orientation      = '0 0 -1'
    n_elems          = 3
  [../]
  [./SNJ-8a8b]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-8a(out)'
    outputs   = 'HX-8b(in)'
  [../]
  [./HX-8b] # pump flow channel: horizontal (no pump heating)
    type             = PBPipe
    input_parameters = ref-pump-channel-horizontal
    length           = 0.162
    position         = '0.74 0 2.043'
    orientation      = '1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-8b8c]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-8b(out)'
    outputs   = 'HX-8c(in)'
  [../]
  [./HX-8c] # pump flow channel: vertical with pump heating
    type             = PBPipe
    input_parameters = ref-pump-channel
    length           = 0.528
    position         = '0.902 0 2.043'
    orientation      = '0 0 -1'
    n_elems          = 4
  [../]
  [./SNJ-8c8d]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-8c(out)'
    outputs   = 'HX-8d(in)'
  [../]
  [./HX-8d] # pump flow channel: horizontal (no pump heating)
    type             = PBPipe
    input_parameters = ref-pump-channel-horizontal
    length           = 0.162
    position         = '0.902 0 1.515'
    orientation      = '-1 0 0'
    n_elems          = 2
  [../]
  [./pump]
    type    = PBPump
    eos     = LBE
    inputs  = 'HX-8d(out)'
    outputs = 'HX-8e(in)'
    Area    = 6.0961E-04
    K       = '0. 0.'
    Head_fn = pump_head_fn
  [../]
  [./HX-8e] # vertical pipe below EPM pump
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.768
    position         = '0.74 0 1.515'
    orientation      = '0 0 -1'
    n_elems          = 4
  [../]
  [./SNJ-8e9a]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-8e(out)'
    outputs   = 'HX-9a(in)'
  [../]
  [./HX-9a] # vertical pipe below EPM pipe
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.747
    position         = '0.74 0 0.747'
    orientation      = '0 0 -1'
    n_elems          = 4
  [../]
  [./SNJ-9a9b]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-9a(out)'
    outputs   = 'HX-9b(in)'
  [../]
  [./HX-9b] # horizontal connection between TS leg and HX leg
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '0.74 0 0'
    orientation      = '-1 0 0'
    n_elems          = 2
  [../]
  [./SNJ-9b10b]
    type            = PBSingleJunction
    eos       = LBE
    inputs    = 'HX-9b(out)'
    outputs   = 'HX-10b(in)'
  [../]
  [./HX-10b] # horizontal connection between 3D leg and HX leg
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.37
    position         = '0.37 0 0'
    orientation      = '-1 0 0'
    n_elems          = 2
  [../]
  [./BRJ-10b11b10a]
    type    = PBBranch
    inputs  = 'HX-10b(out)'
    outputs = 'MH-11b(in) 3D-10a(in)'
    K       = '0.0 0.0 0.0'
    Area    = 6.0961E-04
    eos     = LBE
  [../]
  #=============================================================================
  # secondary loop
  #=============================================================================
  [./secondary-inlet]
    type  = PBTDJ
    input = 'S1(out)'
    eos   = Oil
    m_bc  = -0.25 # secondary flow rate
    T_bc  = 359.15
  [../]
  [./S1] # horizontal channel to HX secondary side inlet
    type             = PBPipe
    input_parameters = ref-secondary
    length           = 0.5
    position         = '0.84 0 4.547'
    orientation      = '1 0 0'
    n_elems          = 4
    initial_V        = ${init_Vsecond}
  [../]
  [./SNJ-S1S2]
    type            = PBSingleJunction
    eos       = Oil
    inputs    = 'S2(out)'
    outputs   = 'S1(in)'
  [../]
  [./S2] # heat exchanger secondary side flow channel and outer wall
    type              = PBPipe
    eos               = Oil
    A                 = 8.36924E-04
    Dh                = 1.76600E-02
    hs_type           = cylinder
    Twall_init        = ${init_Tsolid}
    dim_wall          = 2
    wall_thickness    = '0.00165 0.0608'
    n_wall_elems      = '2 4'
    material_wall     = 'SSL-316 TLock-7730'
    HS_BC_type        = Convective
    T_amb             = 298.15
    h_amb             = 10.0
    radius_i          = 0.0195
    length            = 0.996
    position          = '0.84 0 5.543'
    orientation       = '0 0 -1'
    n_elems           = 10
    initial_V         = ${init_Vsecond}
  [../]
  [./SNJ-S2S3]
    type            = PBSingleJunction
    eos       = Oil
    inputs    = 'S3(out)'
    outputs   = 'S2(in)'
  [../]
  [./S3] # horizontal channel to HX secondary side outlet
    type             = PBPipe
    input_parameters = ref-secondary
    length           = 0.5
    position         = '1.34 0 5.543'
    orientation      = '-1 0 0'
    n_elems          = 4
    initial_V        = ${init_Vsecond}
  [../]
  [./secondary-outlet]
    type  = PBTDV
    input = 'S3(in)'
    eos   = Oil
    T_bc  = 359.15
    p_bc  = 1.3e5
  [../]
  #=============================================================================
  # 3D test section (TS) leg
  #=============================================================================
  [./3D-10a] # vertical pipe below 3D test section
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 1.211
    position         = '0 0 0'
    orientation      = '0 0 1'
    n_elems          = 6
  [../]

###############################
# Left interface
###############################
  [./left_TDV]
    type = CoupledTDV
    input = '3D-10a(out)'
    eos = LBE
    p_fn = left_p_fn
    T_fn = left_T_fn
  [../]

  [./left_TDJ]
    type = CoupledPPSTDJ
    input = 'Coupled_pipe(in)'
    eos = LBE
    v_bc = 0.5
    T_bc = 512.0
    postprocessor_vbc = left_v_bc
    postprocessor_Tbc = left_T_bc
  [../]

  [./Coupled_pipe]
    type = PBOneDFluidComponent
    eos  = LBE
    position    = '0 0 1.211'
    orientation = '0 0 1'
    # based on inlet
    A   = 2.26980E-04
    Dh  = 0.017
    ## based on outlet
    #A  = 6.09610E-04
    #Dh = 2.7860E-02

    length  = 0.9
    n_elems = 1

    overlap_coupled = true
    overlap_pp = fric_pp
  [../]

###############################
# Right interface
###############################
  [./right_TDV]
    type = CoupledTDV
    input = 'Coupled_pipe(out)'
    eos  = LBE
    p_fn = right_p_fn
    T_fn = right_T_fn
  [../]

  [./right_TDJ]
    type = CoupledPPSTDJ
    input = '3D-4a(in)'
    eos   = LBE
    v_bc = 0.5
    T_bc = 512.0
    postprocessor_vbc = right_v_bc
    postprocessor_Tbc = right_T_bc
  [../]

  [./3D-4a] # vertical pipe above the 3D test section and below the TS leg valve
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 3.446
    position         = '0 0 2.111'
    orientation      = '0 0 1'
    n_elems          = 8
  [../]

  [./3D-valve] # 3D test section (TS) leg valve
    type            = PBSingleJunction
    eos       = LBE
    inputs    = '3D-4a(out)'
    outputs   = '3D-4b(in)'
    K         = ${K_TS}
    K_reverse = ${KR_TS}
  [../]

  [./3D-4b] # vertical pipe above the TS leg valve
    type             = PBPipe
    input_parameters = ref-main-pipe
    length           = 0.275
    position         = '0 0 5.557'
    orientation      = '0 0 1'
    n_elems          = 3
  [../]
  [./BRJ-4c4b5c]
    type    = PBBranch
    inputs  = 'MH-4c(out) 3D-4b(out)'
    outputs = 'HX-5c(in)'
    K       = '0.0 0.0 0.0'
    Area    = 6.0961E-04
    eos     = LBE
  [../]
[]
[Postprocessors]
  [./FM1.FR] # MH leg mass flow rate
    type  = ComponentBoundaryFlow
    input = MH-2(in)
  [../]
  [./FM2.FR] # TS leg mass flow rate
    type  = ComponentBoundaryFlow
    input = 3D-10a(in)
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  [../]
  [./FM3.FR] # HX leg mass flow rate
    type  = ComponentBoundaryFlow
    input = HX-6c(in)
  [../]
  [./FM4.FR] # secondary loop mass flow rate
    type  = ComponentBoundaryFlow
    input = S2(in)
  [../]
   [./TC1.0000] # section 1 inlet LBE temperature
     type     = ComponentBoundaryVariableValue
     variable = temperature
     input    = MH-11b(out)
   [../]
   [./TC1.2641] # MH outlet LBE temperature
     type     = ComponentBoundaryVariableValue
     variable = temperature
     input    = MH-1d(out)
   [../]
   [./TC2.1211] # TS inlet LBE temperature
     type     = ComponentBoundaryVariableValue
     variable = temperature
     input    = 3D-10a(out)
   [../]
   [./TC2.2111] # TS outlet LBE temperature
     type     = ComponentBoundaryVariableValue
     variable = temperature
     input    = 3D-4a(in) # check
   [../]
   [./P2.1211] # TS inlet LBE pressure
     type     = ComponentBoundaryVariableValue
     variable = pressure
     input    = 3D-10a(out)
   [../]
   [./P2.2111] # TS outlet LBE pressure
     type     = ComponentBoundaryVariableValue
     variable = pressure
     input    = 3D-4a(in) # check
   [../]
   [./dP_TS] # TS pressure drop
     type     = DifferencePostprocessor
     value1   = P2.1211
     value2   = P2.2111
   [../]
   [./TC3.4036]
     type     = ComponentBoundaryVariableValue
     variable = temperature
     input    = HX-6d(out)
   [../]
   [./TC3.5830] # temp to compare
     type     = ComponentBoundaryVariableValue
     variable = temperature
     input    = HX-6a(in)
   [../]
  # # secondary loop temperature
  [./TC4.HX.In]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = S2(out)
  [../]
  [./TC4.HX.Out]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = S2(in)
  [../]
  [./Q.MH] # main heater heating power to LBE
    type  = ComponentBoundaryEnergyBalance
    input = 'MH-1c(in) MH-1c(out)'
    eos   = LBE
  [../]
  [./Q.HX] # heat exchanger primary power
    type  = ComponentBoundaryEnergyBalance
    input = 'HX-6c(in) HX-6c(out)'
    eos   = LBE
  [../]
  [./Q.Pump] # EPM pump heating power to LBE
    type  = ComponentBoundaryEnergyBalance
    input = 'HX-8c(in) HX-8c(out)'
    eos   = LBE
  [../]
  [./Q.S] # heat removal rate from seondary loop
    type  = ComponentBoundaryEnergyBalance
    input = 'S2(out) S2(in)'
    eos   = Oil
  [../]
# Coupling postprocessors
  [./fric_pp]
    type = ReadFromCSV
    csv_file = CFD_fric.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]

###############################
# Left interface
###############################
  [./left_p_bc]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = Coupled_pipe(in)
    execute_on = 'LINEAR'
  [../]
  [./left_v_bc]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = 3D-10a(out)
    execute_on = 'LINEAR'
  [../]
  [./left_T_bc]
    type = ReadFromCSV
    csv_file = CFD_Tin.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]
###############################
# Right interface
###############################
  [./right_p_bc]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = 3D-4a(in)
    execute_on = 'LINEAR'
  [../]
  [./right_v_bc]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = Coupled_pipe(out)
    execute_on = 'LINEAR'
  [../]
  [./right_T_bc]
    type = ReadFromCSV
    csv_file = CFD_Tout.csv
    execute_on = 'TIMESTEP_BEGIN'
  [../]

[]

[Preconditioning]
  [./SMP_PJFNK]
    type                = SMP
    full                = true
    solve_type          = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  [../]
[]

[Executioner]
  type = CoupledCFDExecutioner

  input_data_file = CFDTOSYS.csv
  n_in_parameter = 1
  name_of_in_components = 'tank' # not used? reference pressure
  name_of_in_parameters = 'T_bc'

  names_of_CFD_boundary = 'inlet inlet outlet'

  output_data_file = SYSTOCFD.csv
  n_out_parameter = 3
  name_of_out_components = 'left_TDV left_TDV right_TDJ'
  name_of_out_parameters = 'massflow temperature temperature'

  SYSCFDBoundaryConsistency = '1'
  CFD_scaling_factor = 0.159155 # 1/(2pi)

  scheme = explicit-euler # allows for reverse flow
  line_search = 'none'

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-6
  l_tol      = 1e-5

  nl_max_its = 100
  l_max_its  = 100

  [./Quadrature]
    type  = TRAP
    order = FIRST
  [../]

  start_time = 0
  end_time   = 3100

#  dt    = 2.0
#  dtmin = 2.0
  [TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 0.05
  []

[]

[Outputs]
  print_linear_residuals = false
  print_nonlinear_residuals = false
  perf_graph             = false
  print_nonlinear_converged_reason = false

  [./console]
    type = Console
#    execute_postprocessors_on = NONE
#    execute_reporters_on      = NONE
#    execute_scalars_on        = NONE
  [../]

  [./csv]
    type = CSV
  [../]

  [./exo]
    type = Exodus
    sequence = false
    use_displaced = true
    interval = 25
    show = 'temperature'
  [../]
#
#  [./checkpoint]
#    type      = Checkpoint
#    num_files = 3
#    interval = 10
#  [../]
[]
