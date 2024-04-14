[GlobalParams]
  global_init_P = 0.0
  global_init_V = 0.14848
  global_init_T = 1.0
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
    v_bc = 0.14848
    T_bc = 1.0
  [../]

  [./pipe1] # placeholder pipe for passing data to nek
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '1 0 0'
    Dh      = 0.06
    length  = 1.41991 # = 0.5 + 0.5 + 0.2 + 2*(2*pi*0.07/4)                      
#    n_elems = 1                     
    n_elems = 10                     
    A       = 2.82743e-3
    overlap_coupled = True
  [../]

  [./outlet]
    type  = PBTDV
    input = 'pipe1(out)'
    eos  = eos
    p_bc = 0.0
    T_bc = 1.0
  [../]
[]

[Postprocessors]
  [SAM_mFlow]
    type = ComponentBoundaryFlow
    input = pipe1(in)
    execute_on = 'INITIAL NONLINEAR TIMESTEP_BEGIN TIMESTEP_END'
  [../]

  [temp_interface]
    type = Receiver
    default = 1.0
    execute_on = 'NONE'
  [../]

  [coupled_nekdP]
    type = Receiver
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

[Executioner]
  type = Transient
  scheme = implicit-euler

  start_time = 0

  dt    = 5e-4                        # Targeted time step size
  dtmin = 5e-4                       # The allowed minimum time step size

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '200'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-8                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 200                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-6                        # Relative linear tolerance for each Krylov solve
  l_max_its = 200                     # Number of linear iterations for each Krylov solve
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
