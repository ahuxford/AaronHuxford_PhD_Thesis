[GlobalParams]
  global_init_P = 0.0
  global_init_T = 0.0
  global_init_V = 0.0 
[]

[EOS]
  [./eos]
      type = PTConstantEOS 
      p_0   = 0.0     # [Pa] , reference pressure
      T_0   = 0.0     # [K]  , reference temperature
      beta  = 0.0     # [1/K]     at (p_0,T_0)
      cp    = 1.0     # [J/kg-K]  at (p_0,T_0)
      h_0   = 1.0     # [J/kg]    at (p_0,T_0)
      rho_0 = 9.9756100e02
      mu    = 8.8871000e-04
      k     = 1.0         # is not used in this input file so value does not matter 
  [../]
[]

[Components]
  [./pbtdj]
    type  = PBTDJ
    input = 'pipe1(in)'
    eos  = eos
    v_bc = 0.445441
    T_bc = 0.0
  [../]

  [./pipe1] # inlet straight
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0 0 0'
    orientation = '1 0 0'
    Dh      = 0.06
    length  = 0.61 # added length due to curve of bend
    n_elems = 50
    A       = 2.82743e-3
  [../]

  [./pipe2] # horizontal
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.61 0 0'
    orientation = '1 0 0'
    Dh      = 0.06
    length  = 0.2 # added length due to curve of bend
    n_elems = 25
    A       = 2.82743e-3
  [../]

  [./pipe3] # bottom of loop
    type = PBOneDFluidComponent
    eos  = eos
    position    = '0.81 0 0'
    orientation = '1 0 0'
    Dh      = 0.06
    length  = 0.61
    n_elems = 50
    A       = 2.82743e-3
  [../]

  [./branch1to2] # top right corner of loop
    type  = PBBranch
    eos   = eos
    inputs  = 'pipe1(out)'
    outputs = 'pipe2(in)'
    K       = '0.08 0.08' # half Tim TRACE input
    Area    = 2.82743e-3
  [../]

  [./branch2to3] # top left corner of loop
    type  = PBBranch
    eos   = eos
    inputs  = 'pipe2(out)'
    outputs = 'pipe3(in)'
    K       = '0.08 0.08' # half Tim TRACE input
    Area    = 2.82743e-3
  [../]

  [./pbtdv]
    type  = PBTDV
    input = 'pipe3(out)'
    eos  = eos
    p_bc = 0.0
    T_bc = 0.0
  [../]
[]

[Postprocessors]
  [mFlow_out1] # mass flow rate to check
    type = ComponentBoundaryFlow
    input = pipe1(out)
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

  dt         = 2
  start_time = 0
  num_steps  = 10 # just run for long time until steady state is reached

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-5
  nl_max_its = 100
  l_tol      = 1e-6
  l_max_its  = 200

[]

[Outputs]
  print_linear_residuals = false
  perf_graph = true
  [./console]
    type = Console
  [../]
[]
