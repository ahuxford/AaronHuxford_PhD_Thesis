[GlobalParams]
  global_init_P      = 0.0
  global_init_T      = 1.0
  gravity            = '0 0 0' # Gravity vector

  global_init_V = 0.2234 # ~ steady solution
[]

[Problem]
   restart_file_base = pumpLoop_ckpt_cp/LATEST # SAM IC
   force_restart = true
[]

[EOS]
  [./eos]
    type   = PTConstantEOS
    beta   = 0.0
    cp     = 1.0
    h_0    = 1.0
    T_0    = 1.0
    rho_0  = 9.9756100e02
    mu     = 8.8871000e-04
    k      = 1.0
    p_0    = 0.0
  [../]
[]

[Components]
  [./pipe1]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 1.0
    n_elems = 10
    A       = 7.85398e-3
  [../]

  [./pump]
    type = PBPump                               # This is a PBPump component
    eos  = eos
    inputs  = 'pipe1(out)'
    outputs = 'pipe2(in)'
    K       = '0.0 0.0'                        # Form loss coefficient at pump inlet and outlet
    Area      = 7.85398e-3                     # Reference pump flow area
    Head      = 25                             # Specified constant pump head
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '1 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 1.0
    n_elems = 10
    A       = 7.85398e-3
  [../]

  [./junction1]
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe2(out)'
    outputs = 'pipe_over(in)'
  [../]

  [./pipe_over]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '2 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 1.0
    n_elems = 1
    A       = 7.85398e-3
    overlap_coupled = True
  [../]

  [./junction2]
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe_over(out)'
    outputs = 'pipe4(in)'
  [../]

  [./pipe4]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '3 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 1.0
    n_elems = 10
    A       = 7.85398e-3
  [../]

  [./branch1]
    type  = PBBranch
    eos   = eos
    inputs  = 'pipe4(out)'
    outputs = 'pipe1(in) pipe5(in)'
    K       = '0.0 0.0 0.0'
    Area    = 7.85398e-3
  [../]

  [./pipe5]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '4 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 0.1
    n_elems = 5
    A       = 7.85398e-3
    initial_V = 0
  [../]

  [./pbtdv]
    type  = PBTDV
    input = 'pipe5(out)'
    eos  = eos
    p_bc = 0.0
    T_bc = 1.0
  [../]
[]

[Postprocessors]
  [mFlow_pipe1out]
    type = ComponentBoundaryFlow
    input = pipe1(out)
    execute_on = 'INITIAL NONLINEAR'
  [../]
  [mFlow_pipe2out]
    type = ComponentBoundaryFlow
    input = pipe2(out)
    execute_on = 'INITIAL NONLINEAR'
  [../]
  [mFlow_pipe4out]
    type = ComponentBoundaryFlow
    input = pipe4(out)
    execute_on = 'INITIAL NONLINEAR'
  [../]
  [mFlow_pipe5out]
    type = ComponentBoundaryFlow
    input = pipe5(out)
    execute_on = 'INITIAL NONLINEAR'
  [../]

  [vel_pipe5out]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe5(out)
  [../]

  [./p_pipe1in]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(in)
  [../]
  [./p_pipe1out]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(out)
  [../]
  [./p_pipe2in]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(in)
  [../]
  [./p_pipe2out]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(out)
  [../]
  [./p_pipe4in]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe4(in)
  [../]
  [./p_pipe4out]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe4(out)
  [../]
  [./p_pipe5in]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe5(in)
  [../]

#########################################
  [toNekRS_velocity]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe2(out)
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

  [coupled_nekdP] # required for coupling
    type = Receiver
#    default = 3.85
  [../]

  [./p_out]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe4(in)
  [../]

  [./p_in]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(out)
  [../]

  [./dP_over]
    type = ParsedPostprocessor
    function = 'p_in - p_out'
    pp_names = 'p_in p_out'
  [../]

[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
#    type = FDP
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  [../]
[]

[Executioner]
  type = Transient
  scheme = implicit-euler

  start_time = 0.0

  dt    = 1e-2                        # Targeted time step size
  dtmin = 1e-2                        # The allowed minimum time step size

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
#  [./ckpt]
#    type = Checkpoint
#    num_files = 3
#    interval = 10
#  [../]
[]
