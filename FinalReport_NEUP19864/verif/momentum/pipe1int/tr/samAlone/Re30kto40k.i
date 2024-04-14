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

[Functions]
  [./v_inlet_func]
    type = PiecewiseLinear
    x = '0 1.0 6.0 1e5'
    y = '0.26726486 0.26726486 0.356353146 0.356353146'
  [../]
[]


[Components]
  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '1 0 0'
    Dh = 0.1                           
    length = 1.0                       
    n_elems = 200                     
    A = 7.85398e-3                        
  [../]

  [./inlet]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    v_fn = v_inlet_func
    T_bc = 1.0
  [../]

  [./outlet]
    type = PBTDV
    input = 'pipe1(out)'
    eos = eos
    p_bc = 0.0
    T_bc = 1.0
  [../]
[]


[Postprocessors]
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

  [./p_drop] # resultant pressure drop due to imposed velocity
    type = DifferencePostprocessor
    value1 = p_inlet
    value2 = p_outlet
  [../]
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [./SMP_PJFNK]
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

  dt    = 0.2                        # Targeted time step size
  dtmin = 0.2                        # The allowed minimum time step size
  num_steps = 35

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-5                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-4                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 50                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

[]


[Outputs]
  print_linear_residuals = true
  perf_graph = true
  [./console]
    type = Console
  [../]
[]
