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
    v_bc = 0.356353146
    T_bc = 1.0
  [../]

  [./pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 0'
    orientation = '1 0 0'
    Dh = 0.1                           
    length = 0.3333                       
    n_elems = 10                     
    A = 7.85398e-3
  [../]

  [./Branch1]
    type = CoupledPPSTDV
    input = 'pipe1(out)'
    eos = eos
    postprocessor_pbc = pres_inlet_interface
    postprocessor_Tbc = temp_interface
  [../]


  [./Branch2]
    type  = CoupledPPSTDJ
    input = 'pipe2(in)'
    eos   = eos
    v_bc  = 2.6726486E-01
    T_bc  = 1.0
    postprocessor_vbc = vel_interface
    postprocessor_Tbc = temp_interface
  [../]


  [./pipe2] # overlap coupled section
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.3333 0 0'
    orientation = '1 0 0'
    Dh      = 0.1
    length  = 0.3333
    n_elems = 10
    A       = 7.85398e-3
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
  [vel_interface]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = pipe1(out)
    execute_on = 'INITIAL NONLINEAR'
  [../]

  [SAM_mFlow]
    type = ComponentBoundaryFlow
    input = pipe1(out)
    execute_on = 'INITIAL NONLINEAR TIMESTEP_BEGIN TIMESTEP_END'
  [../]

  [temp_interface]
    type = Receiver
    default = 1.0
    execute_on = 'NONE'
  [../]

  [nekRS_pres_drop]
    type = Receiver
    execute_on = 'NONLINEAR TIMESTEP_BEGIN TIMESTEP_END'
  [../]

  [neg_nekRS_pres_drop]
    type = ScalePostprocessor
    value = nekRS_pres_drop
    scaling_factor = -1
    execute_on = 'NONLINEAR'
  [../]

  [./p_outlet_interface]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe2(in)
    execute_on = 'NONLINEAR'
  [../]

  [pres_inlet_interface]
    type = DifferencePostprocessor
    value1 = p_outlet_interface
    value2 = neg_nekRS_pres_drop
    execute_on = 'NONLINEAR'
  [../]

  [./p_interface]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(out)
  [../]

  [./p_inlet]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = pipe1(in)
  [../]
[]

[Functions]
  [./v_inlet_func]
    type = PiecewiseLinear
    x = '0 0.5 5.5 6'
    y = '2.6726486E-01 2.6726486E-01 3.5635315E-01 3.5635315E-01'
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
  scheme = explicit-euler

  dt    = 1e-3                        # Targeted time step size
  dtmin = 1e-3                        # The allowed minimum time step size
#  num_steps = 6000

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '200'                 # Additional PETSc settings, value list

  nl_rel_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-5                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 200                     # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
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
