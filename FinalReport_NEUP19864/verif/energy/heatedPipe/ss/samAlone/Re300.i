[GlobalParams]
  global_init_P = 0.0
  global_init_V = 3.0  # Reynolds = 300
  global_init_T = 0.0

  gravity = '-9.8 0 0 ' # Gravity vector
[]

[EOS]
  [./eos]                                       
    type   = PTConstantEOS                      
    beta   = 0.1                                
    cp     = 1                                
    h_0    = 0.0                           
    T_0    = 0.0                                
    rho_0  = 1                               
    mu     = 1e-3
    k      = 1e-3 # not used unless axial conduction specified in SAM                           
    p_0    = 0.0
  [../]
[]

[Components]
  [./inlet]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    v_bc = 3.0 # Reynolds = 300
    T_bc = 0.0
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '1 0 0'
    Dh = 0.1                           
    length = 1.0                       
    n_elems = 1000                     
    A = 7.85398e-3                        
    heat_source = 1 # W/m^3
  [../]

  [./outlet]
    type = PBTDV
    input = 'pipe1(out)'
    eos = eos
    p_bc = 0.0
    T_bc = 0.0 # since flow is going into this BC, value is not used
  [../]
[]


[Postprocessors]
  [vel_outlet]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe1(out)
  [../]

  [mFlow_outlet]
    type = ComponentBoundaryFlow
    input = pipe1(out)
  [../]

  [./p_inlet]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(in)
  [../]

  [./p_outlet]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(out)
  [../]

  [./t_inlet]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe1(in)
  [../]

  [./t_outlet]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe1(out)
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

  start_time = 0

  dt    = 0.01                      # Targeted time step size
  dtmin = 0.01                       # The allowed minimum time step size
  num_steps = 500

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-8                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-8                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 50                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-8                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

[]


[Outputs]
  print_linear_residuals = false
  perf_graph = true
[]
