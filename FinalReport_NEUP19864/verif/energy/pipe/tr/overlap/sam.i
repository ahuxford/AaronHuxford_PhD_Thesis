[GlobalParams]
  global_init_P = 0.0
  global_init_V = 1.0  # Reynolds = 100
  global_init_T = 0.0
[]

[EOS]
  [./eos]                                       
    type   = PTConstantEOS                      
    beta   = 0.0                                
    cp     = 1                                
    h_0    = 0.0                           
    T_0    = 0.0                                
    rho_0  = 1                               
    mu     = 1e-3
    k      = 0.0 # not used unless axial conduction specified in SAM                           
    p_0    = 0.0
  [../]
[]

[Components]
  [./inlet]
    type = PBTDJ
    input = 'pipe1(in)'
    eos = eos
    v_bc = 1.0
    T_bc = 0.0
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '1 0 0'
    Dh = 0.1                           
    length = 0.5                       
    n_elems = 1                  
    A = 7.85398e-3
    overlap_coupled = True                        
  [../]

  [./Branch1]
    type = CoupledPPSTDV
    input = 'pipe1(out)'
    eos = eos
    p_bc = 0.0
    T_bc = 0.0
    postprocessor_pbc = SAM_pressure
    postprocessor_Tbc = nekRS_temperature # this value doesnt matter
  [../]

  [./Branch2]
    type = CoupledPPSTDJ
    input = 'pipe2(in)'
    eos = eos
    v_bc = 1.0
    T_bc = 0.0
    postprocessor_vbc = SAM_velocity
    postprocessor_Tbc = nekRS_temperature
  [../]

  [./pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '1 0 0'
    orientation = '1 0 0'
    Dh = 0.1                           
    length = 0.5                       
    n_elems = 1000                     
    A = 7.85398e-3                        
  [../]

  [./outlet]
    type = PBTDV
    input = 'pipe2(out)'
    eos = eos
    p_bc = 0.0
    T_bc = 0.0 # since flow is going into this BC, value is not used
  [../]
[]


[Postprocessors]
  [./SAM_dudt] # may only do dudt over entire SAM domain? not sure need to check this
    type = ElementAverageTimeDerivative
    variable = velocity
    input = pipe1(in)
  [../]

  [coupled_nekdP]
    type = Receiver
  [../]

  [nekRS_temperature]
    type = Receiver
  []

  [vel_inSam]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe1(in)
  [../]

  [SAM_pressure]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(in)
    execute_on = 'INITIAL LINEAR'
  [../]

  [SAM_velocity]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe1(out)
    execute_on = 'INITIAL LINEAR'
  [../]

  [./p_inSam]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(in)
  [../]

  [./t_inSam]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe1(in)
  [../]

  [./t_outlet]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = pipe2(out)
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

  dt    = 1e-3                      # Targeted time step size
  dtmin = 1e-3                       # The allowed minimum time step size

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-10                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-10                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 50                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-10                        # Relative linear tolerance for each Krylov solve
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
#  [./exodus]
#    type = Exodus
#  [../]
[]
