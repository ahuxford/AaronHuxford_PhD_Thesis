[GlobalParams]
  global_init_P = 101325
  global_init_V = 0.424
  global_init_T = 293.15

[./PBModelParams]
  passive_scalar = 'tracer'
  passive_scalar_decay_constant = '0.0'
  passive_scalar_diffusivity = '7.5942'
  p_order = 1
[../]
[]

[EOS]
  [./eos] # using rho and mu from nekRS
      type = PTConstantEOS # from NIST Chemistry Webbook isobaric data for water
      p_0   = 101325     # [Pa] , reference pressure
      T_0   = 293.15     # [K]  , reference temperature (average in loop)
      rho_0 = 997        # [kg/m^3]  at (p_0,T_0)
      beta  = 0.00021    # [1/K]     at (p_0,T_0)
      cp    = 4.1841e3   # [J/kg-K]  at (p_0,T_0)
      h_0   = 84.007e3   # [J/kg]    at (p_0,T_0)
      mu    = 8.899e-4   # [Pa-s]    at (p_0,T_0)
      k     = 0.59801    # is not used in this input file so value does not matter
  [../]
[]

[ComponentInputParameters]
  [./pipe_params]
    type = PBOneDFluidComponentParameters
    eos = eos
    A   = 0.0019635
    Dh  = 0.05
  [../]
[]

[Components]
  [./overlap]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0 0 0'
    orientation = '1 0 0'
    length  = 0.738
    n_elems = 5
    overlap_coupled = True
  [../]

  [./side_WM1toOverlap]
    type = PBSingleJunction
    eos = eos
    inputs  = side_toWM1(out)
    outputs = overlap(in)
  [../]

  [./outlet_SamToNek]
    type = CoupledPPSTDV
    eos = eos
    input = 'overlap(out)'
    postprocessor_pbc = fromSAM_pressure
    postprocessor_Tbc = temperature
    postprocessor_Sbc = fromNekRS_tracer # value doesnt matter because outlet bc
  [../]

  [./inlet_SamToNek]
    type = CoupledPPSTDJ
    eos = eos
    input = 'side_WM2extendToHor(in)'
    v_bc = 0.424
    T_bc = 293.15
    postprocessor_vbc = fromSAM_velocity
    postprocessor_Tbc = temperature
    postprocessor_Sbc = fromNekRS_tracer
  [../]

  [./side_WM2extendToHor]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.128 -0.32 0'
    orientation = '0 -1 0'
    length  = 2.306
    n_elems = 462
  [../]

  [./side_pump]
    type = PBPump
    eos = eos
    inputs  = 'side_WM2extendToHor(out)'
    outputs = 'side_horizontal(in)'
    K = '0 0'
    Area = 0.0019635
    Head = 723.8
#    Desired_mass_flow_rate =  0.83
#    Mass_flow_rate_tolerance = 1e-6
#    Response_interval = 1.5
  [../]

  [./side_horizontal]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.128 -2.626 0'
    orientation = '-1 0 0'
    length  = 0.128
    n_elems = 26
  [../]

  [./branch1]
    type  = PBBranch
    eos   = eos
    inputs  = 'side_horizontal(out)'
    outputs = 'side_toWM1(in) deadend(in)'
    K       = '0.0 0.0 0.0'
    Area    = 7.85398e-3
  [../]

  [./side_toWM1]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0 -2.626 0'
    orientation = '0 1 0'
    length  = 2.626
    n_elems = 526
  [../]

  [./deadend]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0 -2.626 0'
    orientation = '-1 0 0'
    length  = 0.1
    n_elems = 10
    initial_V = 0 # set initial velcocity in dead end to zero
  [../]

  [./deadend_outlet]
    type = PBTDV
    eos = eos
    input = 'deadend(out)'
    p_bc = 101325 # set a reference pressure somewhere in the loop
    T_bc = 293.15
    S_bc = 0.0
  [../]

[]

[Postprocessors]
  [temperature] # set reference temperature because eos assumes this temperature
    type = Receiver
    default = 293.15
  [../]

  [sideFlow_out]
    type = ComponentBoundaryFlow
    input = side_toWM1(out)
  [../]

  [sideFlow_in]
    type = ComponentBoundaryFlow
    input = side_WM2extendToHor(in)
  [../]

  [fromNekRS_tracer]
    type = Receiver
    default = 0.0
  [../]

#  [fromNekRS_dP] # pressure drop over
#    type = Receiver
#    default = 493
#  [../]

  [coupled_nekdP]
    type = Receiver
    default = 668.015
  [../]

  [fromSAM_velocity]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = overlap(out)
    execute_on = 'INITIAL NONLINEAR LINEAR'
  []

  [fromSAM_pressure]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = side_WM2extendToHor(in)
    execute_on = 'INITIAL NONLINEAR LINEAR'
  []

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

  start_time = 0

  dt    = 0.1                      # Targeted time step size
  dtmin = 0.1                      # The allowed minimum time step size

  num_steps = 1000

#  dt    = 2.5e-4                      # Targeted time step size
#  dtmin = 2.5e-4                      # The allowed minimum time step size

  nl_rel_tol = 1e-6                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-5                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 200                    # Number of nonlinear iterations for each Newton solve

  l_tol = 1e-6                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

  [Quadrature]
  type = GAUSS
  []
[]


[Outputs]
  print_linear_residuals = false
  print_nonlinear_converged_reason = false

  [console]
  type = Console
  execute_postprocessors_on = NONE
  execute_reporters_on = NONE
  execute_scalars_on = NONE
  []

#  [csv]
#  type = CSV
#  interval = 1
#  []

  [./ckpt]
    type = Checkpoint
    num_files = 3
    interval = 10
  [../]

[]
