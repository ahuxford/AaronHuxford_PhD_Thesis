[GlobalParams]
  global_init_P = 0.0
  global_init_V = 2.6726486E-01
  global_init_T = 1.0
  scaling_factor_var = '1 1 1'
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
  [./inlet]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    p_bc = 8.340398
    T_bc = 1.0
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 0.5
    n_elems = 500
    A       = 7.85398e-3
  [../]

  [./junction1]
    type = PBSingleJunction
    eos  = eos
    inputs  = 'pipe1(out)'
    outputs = 'pipe2(in)'
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.5 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 0.5
    n_elems = 1
    A       = 7.85398e-3
    overlap_coupled = True # for overlap-domain coupling 
  [../]

  [./outlet]
    type  = PBTDV
    input = 'pipe2(out)'
    eos  = eos
    p_bc = 0.0
    T_bc = 1.0
  [../]
[]

[Postprocessors]
  [SAM_mFlow]
    type = ComponentBoundaryFlow
    input = pipe1(out)
    execute_on = 'INITIAL NONLINEAR TIMESTEP_BEGIN TIMESTEP_END'
  [../]

  [nekRS_pres_drop]
    type = Receiver
    execute_on = 'NONLINEAR TIMESTEP_BEGIN TIMESTEP_END'
  [../]

  [coupled_nekdP] # required for overlap coupling in SAM
    type = ScalePostprocessor
    value = nekRS_pres_drop
    scaling_factor = 2.0 # one divided by length of coupled section to get dp/dx (no inertial term)
    execute_on = 'NONLINEAR TIMESTEP_BEGIN TIMESTEP_END'
  [../]

  [./p_inlet]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(in)
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

[MultiApps]
  [nek]
    type = TransientMultiApp
    app_type = CardinalApp
    input_files = 'nek.i'
    sub_cycling = true
    execute_on = timestep_begin
  []
[]

[Transfers]
  [SAM_mflow_transfer]
    type = MultiAppPostprocessorTransfer
    direction = to_multiapp
    multi_app = nek
    from_postprocessor = SAM_mFlow
    to_postprocessor = SAM_mflow_inlet_interface
  []

  [nekRS_pres_drop]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    multi_app = nek
    reduction_type = average
    from_postprocessor = nekRS_pres_drop
    to_postprocessor   = nekRS_pres_drop
  [../]

[]

[Executioner]
  type = Transient

  dt    = 0.1                        # Targeted time step size
  dtmin = 0.1                        # The allowed minimum time step size
  num_steps = 150

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-7                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 20                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  [./csv]
    type = CSV
  [../]
  [./console]
    type = Console
  [../]
[]
