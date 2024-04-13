[GlobalParams]
  global_init_P = 1.5e7
  global_init_T = 550

  global_init_V = 0.235

[]

[Problem]
#   restart_file_base = coupled_nek_master_out_ExternalApp0_coupled_ckpt_cp/106800
   restart_file_base = sam_ckpt_cp/LATEST # SAM IC
   force_restart = true
[]


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
  [./pipe_overlap] # overlapped section
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.2 0 0.5'
    orientation = '1 0 0'
    Dh      = 0.06
    length  = 1.42
    n_elems = 1
    A       = 2.82743e-3
    overlap_coupled = True
  [../]

  [./pipe2] # heated section
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.2 0 0.5'
    orientation = '0 0 1'
    Dh      = 0.06
    length  = 1.0
    n_elems = 10
    A       = 2.82743e-3
    heat_source = 3.33e6 # = driving heat / volume of heated pipe
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
    heat_source = -3.33e6 # = -driving heat / volume of heated pipe
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
    T_bc = 550 # outlet Temperature doesnt matter
  [../]

  [./junction7toOverlap] # heated pipe to top right pipe
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe7(out)'
    outputs = 'pipe_overlap(in)'
  [../]

  [./NekOutlet]
    type  = CoupledPPSTDJ
    input = 'pipe2(in)'
    eos   = eos
    v_bc  = 0.235
    T_bc  = 548
    postprocessor_vbc = SAM_velocity
    postprocessor_Tbc = fromNekRS_temperature
  [../]

  [./NekInlet]
    type  = CoupledPPSTDV
    input = 'pipe_overlap(out)'
    eos   = eos
    postprocessor_pbc = p_inlet_interface
    postprocessor_Tbc = fromNekRS_temperature # this value does not matter because its an outlet temperature
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

#  [./SAM_dudt] # may only do dudt over entire SAM domain? not sure need to check this
#    type = ElementAverageTimeDerivative
#    variable = velocity
#    execute_on = 'INITIAL TIMESTEP_END'
#  [../]

  [coupled_nekdP] # required for overlap coupling
    type = Receiver
    default = 2.125
  [../]

#  [./change_over_time]
#    type = ChangeOverTimePostprocessor
#    postprocessor = coupled_nekdP
#    compute_relative_change = true
#    change_with_respect_to_initial = false
#    execute_on = 'initial timestep_begin'
#  [../]
#
#  [coupled_copy]
#    type = ParsedPostprocessor
#    function = 'coupled_nekdP'
#    pp_names = 'coupled_nekdP'
#    execute_on = 'initial timestep_end'
#  []
#
#  [parsed]
#    type = ParsedPostprocessor
#    function = 'if(change_over_time > 0.1, coupled_nekdP, coupled_copy)'
#    pp_names = 'change_over_time coupled_nekdP coupled_copy'
#  []

  [fromNekRS_temperature] # required for coupling
    type = Receiver
    default = 548.2444941055
  [../]

  [toNekRS_velocity] # required for coupling
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe7(out)
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./u]
    type = ParsedPostprocessor
    function = 'toNekRS_velocity'
    pp_names = 'toNekRS_velocity'
    execute_on = 'initial timestep_end'
  [../]

  [./du]
    type = ChangeOverTimePostprocessor
    postprocessor = u
    change_with_respect_to_initial = false
    execute_on = 'timestep_end'
  [../]

  [./dt]
    type = TimestepSize
  [../]

  [./SAM_dudt]
    type = ParsedPostprocessor
    function = 'du/dt'
    pp_names = 'du dt'
    execute_on = 'initial timestep_end'
  [../]

  [toNekRS_temperature] # required for coupling
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe7(out)
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  # overlap coupling with temperature transport
  [SAM_velocity] # required for overlap coupling
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe_overlap(out)
    execute_on = 'INITIAL LINEAR'
  [../]
  [p_inlet_interface] # required for coupling
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(in)
    execute_on = 'INITIAL NONLINEAR'
  [../]

  [p_in] # check coupling
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe_overlap(in)
    execute_on = 'INITIAL NONLINEAR'
  [../]
  [p_out] # check coupling
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe_overlap(out)
    execute_on = 'INITIAL NONLINEAR'
  [../]
  [dP_overlap] # check coupling P drop
    type = ParsedPostprocessor
    function = 'p_in - p_out'
    pp_names = 'p_in p_out'
    execute_on = 'INITIAL TIMESTEP_END'
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

  dt        = 1e-4
  dtmin     = 1e-4
  start_time = 0

  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-4
  nl_max_its = 1000
  l_tol      = 1e-4
  l_max_its  = 200

[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  execute_postprocessors_on = INITIAL

  [./csv]
    type = CSV
#    interval = 100
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
#  [./coupled_ckpt]
#    type = Checkpoint
#    num_files = 3
#    interval = 500
#  [../]

[]
