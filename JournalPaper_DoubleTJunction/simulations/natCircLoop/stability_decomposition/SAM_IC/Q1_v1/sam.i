[GlobalParams]
  global_init_P = 1.5e7
  global_init_T = 550

  global_init_V = 0.235

[]

#[Problem]
#   restart_file_base = sam_ckpt_cp/LATEST 
#   force_restart = true
#[]



[EOS]
  [./eos]
      type = PTConstantEOS # from NIST Chemistry Webbook isobaric data for water
      p_0   = 1.5e7     # [Pa] , reference pressure
      T_0   = 550       # [K]  , reference temperature (average in loop)
      rho_0 = 769.02    # [kg/m^3]  at (p_0,T_0)
      beta  = 0.00222   # [1/K]     at (p_0,T_0)
      cp    = 5039.5    # [J/kg-K]  at (p_0,T_0)
      h_0   = 1217.1e3  # [J/kg]    at (p_0,T_0)
      mu    = 9.7512e-5 # [Pa-s]    at (p_0,T_0)
      k     = 1         # is not used in this input file so value does not matter
  [../]
[]

[Components]
  [./pipe2] # heated section
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.2 0 0.5'
    orientation = '0 0 1'
    Dh      = 0.06
    length  = 1.0
    n_elems = 10
    A       = 2.82743e-3
    heat_source = 2.64925e6 # = driving heat / volume of heated pipe
  [../]

  [./pipe3] # top right of loop
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.2 0 1.5'
    orientation = '0 0 1'
    Dh      = 0.06
    length  = 1.5
    n_elems = 10
    A       = 2.82743e-3
  [../]

  [./pipe5] # top left of loop
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 3.0'
    orientation = '0 0 -1'
    Dh      = 0.06
    length  = 0.5
    n_elems = 10
    A       = 2.82743e-3
  [../]

  [./pipe6] # cooled section
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 2.5'
    orientation = '0 0 -1'
    Dh      = 0.06
    length  = 1.0
    n_elems = 10
    A       = 2.82743e-3
    heat_source = -2.64925e6 # = -driving heat / volume of heated pipe
  [../]

  [./pipe7] # left side
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 1.5'
    orientation = '0 0 -1'
    Dh      = 0.06
    length  = 1.0
    n_elems = 10
    A       = 2.82743e-3
  [../]

  [./junction2to3] # heated pipe to top right pipe
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe2(out)'
    outputs = 'pipe3(in)'
  [../]

  [./junction5to6] # top left to cooled pipe
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe5(out)'
    outputs = 'pipe6(in)'
  [../]

  [./junction6to7] 
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe6(out)'
    outputs = 'pipe7(in)'
  [../]

  [./branch3to5anddeadend] # top right corner of loop, with dead end pipe
    type  = PBBranch
    eos   = eos
    inputs  = 'pipe3(out)'
    outputs = 'pipe5(in) pipe_deadend(in)'
    K       = '0.117 0.117 0' # from NRC handbook at Re~100,000
    Area    = 2.82743e-3
  [../]

  [./pipe_deadend]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.2 0 3.0'
    orientation = '1 0 0'
    Dh      = 0.06
    length  = 0.1
    n_elems = 5
    A       = 2.82743e-3
    initial_V = 0.0 # set velocity in dead end to zero
  [../]

  [./pbtdv]
    type  = PBTDV
    input = 'pipe_deadend(out)'
    eos  = eos
    p_bc = 1.5e7
    T_bc = 550
  [../]

  [./NekOutlet]
    type  = CoupledPPSTDJ
    input = 'pipe2(in)'
    eos   = eos
    v_bc  = 0.235
    T_bc  = 550
    postprocessor_vbc = toNekRS_velocity
    postprocessor_Tbc = toNekRS_temperature
  [../]

  [./NekInlet]
    type  = CoupledPPSTDV
    input = 'pipe7(out)'
    eos   = eos
    postprocessor_pbc = p_inlet_interface
    postprocessor_Tbc = toNekRS_temperature # this value does not matter because its an outlet temperature
  [../]

[]

[Postprocessors]
  [mFlow_deadend] # should be ~ 0
    type = ComponentBoundaryFlow
    input = pipe_deadend(out)
  [../]
  [mFlow_out2] # mass flow rate to check
    type = ComponentBoundaryFlow
    input = pipe2(out)
  [../]
  [mFlow_out6] # should match above mass flow rate
    type = ComponentBoundaryFlow
    input = pipe7(out)
  [../]

  [toNekRS_velocity] # required for coupling
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe7(out)
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  [../]

  [toNekRS_temperature] # required for coupling
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe7(out)
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  [../]

  [NekRS_pressureDrop] # required for coupling
    type = Receiver
    default = 12.07
  [../]

  [./p_outlet_interface]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(in)
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  [../]

  [./p_inlet_interface]
    type = ParsedPostprocessor
    function = 'p_outlet_interface + NekRS_pressureDrop'
    pp_names = 'p_outlet_interface NekRS_pressureDrop'
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END'
  [../]


[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = FDP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  [../]
[]

[Executioner]
  type = Transient

  scheme = implicit-euler

  dt        = 1 #1e-4
#  dtmin     = 1 #1e-4
  start_time = 0

  num_steps = 400

  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-4
  nl_max_its = 100
  l_tol      = 1e-5
  l_max_its  = 200

[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  [./csv]
    type = CSV
  [../]
  [./console]
    type = Console
    execute_postprocessors_on = INITIAL
    execute_scalars_on = INITIAL
    execute_reporters_on = INITIAL
  [../]
#  [./out]
#    type = Exodus
#    interval = 100
#    use_displaced = true
#    output_material_properties = true
#    execute_on = 'initial timestep_end '
#    sequence = false
#  [../]
  [./ckpt]
    type = Checkpoint
    num_files = 3
    interval = 10
  [../]
[]
