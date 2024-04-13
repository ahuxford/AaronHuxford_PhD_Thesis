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

### main loop

  [./inlet]
    type = PBTDJ
    input = 'main_inlet(in)'
    eos = eos
    v_bc = 0.424
    T_bc = 293.15
    S_bc = '0.0' # scalar BC
  [../]

  [./main_inlet]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0 0 0'
    orientation = '1 0 0'
    length  = 0.12
    n_elems = 4
  [../]

  [./main_betweenTjunctions]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.12 0 0'
    orientation = '1 0 0'
    length  = 0.12
    n_elems = 24
    initial_V = 0.848
  [../]

  [./Tjunction1] # Left T junction
    type  = PBBranch
    eos   = eos
    inputs  = 'main_inlet(out) side_WM1toT1(out)'
    outputs = 'main_betweenTjunctions(in)'
    K       = '0 0 0'
    Area    = 0.0019635
  [../]

  [./Tjunction2] # Right T junction
    type  = PBBranch
    eos   = eos
    inputs = 'main_betweenTjunctions(out)'
    outputs = 'main_T2toWM3(in) side_T2toWM2(in)'
    K       = '0 0 0'
    Area    = 0.0019635
  [../]

  [./main_T2toWM3]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.24 0 0'
    orientation = '1 0 0'
    length  = 0.16
    n_elems = 32
  [../]

  [./outlet]
    type = PBTDV
    input = 'main_T2toWM3(out)'
    eos = eos
    p_bc = 101325
    T_bc = 293.15 # since flow is going into this BC, value is not used
    S_bc = '0.0' # probably not used due to reason above
  [../]

### side loop

  [./side_T2toWM2]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.24 0 0'
    orientation = '0 -1 0'
    length  = 0.2
    n_elems = 40
  [../]

  [./WM2]
    type  = PBSingleJunction
    eos   = eos
    inputs  = 'side_T2toWM2(out)'
    outputs = 'side_WM2toPump(in)'
  [../]

  [./side_WM2toPump]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.24 -0.2 0'
    orientation = '0 -1 0'
    length  = 2.51
    n_elems = 502
  [../]

  [./side_pump]
    type = PBPump
    eos = eos
    inputs  = 'side_WM2toPump(out)'
    outputs = 'side_PumptoWM1(in)'
    K = '0 0'
    Area = 0.0019635
    Head = 274
    Desired_mass_flow_rate =  0.83
    Mass_flow_rate_tolerance = 1e-6
    Response_interval = 1.0
  [../]

  [./side_PumptoWM1]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.12 -2.89 0'
    orientation = '0 1 0'
    length  = 2.79
    n_elems = 558
  [../]

  [./side_WM1_in]
    type = CoupledPPSTDV
    eos = eos
    input = 'side_PumptoWM1(out)'
    postprocessor_pbc = pressure
    postprocessor_Tbc = temperature
    postprocessor_Sbc = scalar
  [../]

  [./side_WM1_out]
    type = CoupledPPSTDJ
    eos = eos
    input = 'side_WM1toT1(in)'
    v_bc = 0.424
    T_bc = 293.15
    postprocessor_vbc = velocity
    postprocessor_Tbc = temperature
    postprocessor_Sbc = scalar
  [../]

  [./side_WM1toT1]
    type = PBOneDFluidComponent
    input_parameters = pipe_params
    position    = '0.12 -0.1 0'
    orientation = '0 1 0'
    length  = 0.1
    n_elems = 20
  [../]

[]

[Functions]
  [./tracer_injection]
    type = PiecewiseLinear
    data_file = ../ExperimentData/WM1_data.csv
    format = columns
  [../]
  [./tracer_coeff]
    type = ParsedFunction
    value = 'if(t<=5.0, 1.0, 0.0)' # dont inject tracer for making checkpoint
  [../]
[]

[Postprocessors]
  [velocity]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = side_PumptoWM1(out)
    execute_on = 'INITIAL LINEAR'
  [../]

  [temperature]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = side_PumptoWM1(out)
    execute_on = 'INITIAL LINEAR'
  [../]

  [pressure]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = side_WM1toT1(in)
    execute_on = 'INITIAL LINEAR'
  [../]

  [tracer_inject] # only do injection right now
    type = FunctionValuePostprocessor
    function = tracer_injection
    execute_on = 'TIMESTEP_BEGIN'
  []

  [tracer_coeffpp] # only do injection right now
    type = FunctionValuePostprocessor
    function = tracer_coeff
    execute_on = 'TIMESTEP_BEGIN'
  []

  [scalar]
    type = ParsedPostprocessor
    function = 'tracer_inject*tracer_coeffpp + (1-tracer_coeffpp)*tracer_transport'
    pp_names = 'tracer_inject tracer_coeffpp tracer_transport'
    execute_on = 'INITIAL LINEAR'
  []

 [tracer_transport]
   type = ComponentBoundaryVariableValue
   variable = tracer
   input = side_PumptoWM1(out)
   execute_on = 'INITIAL LINEAR'
 [../]

  [mainFlow_inlet]
    type = ComponentBoundaryFlow
    input = main_inlet(out)
  [../]

  [mainFlow_betweenJunctions]
    type = ComponentBoundaryFlow
    input = main_betweenTjunctions(out)
  [../]

  [mainFlow_outlet]
    type = ComponentBoundaryFlow
    input = main_T2toWM3(out)
  [../]

  [sideFlow_inlet]
    type = ComponentBoundaryFlow
    input = side_T2toWM2(out)
  [../]

  [sideFlow_outlet]
    type = ComponentBoundaryFlow
    input = side_WM1toT1(out)
  [../]

  [tracer_WM1]
    type = ComponentBoundaryVariableValue
    variable = tracer
    input = side_WM1toT1(in)
  [../]

  [tracer_WM2]
    type = ComponentBoundaryVariableValue
    variable = tracer
    input = side_T2toWM2(out)
  [../]

  [tracer_WM3]
    type = ComponentBoundaryVariableValue
    variable = tracer
    input = main_T2toWM3(out)
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

  start_time = 0

  dt    = 2.5e-4                      # Targeted time step size
  dtmin = 2.5e-4                      # The allowed minimum time step size
  num_steps = 160000

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
  outlier_variable_norms = false
  interval = 1000
  []

  [csv]
  type = CSV
  interval = 10
  []

[]

