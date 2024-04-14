[Mesh]
  type = NekRSMesh
  boundary = 2 # send to NekRS boundary 2
[]

[Problem]
  type = NekRSSeparateDomainProblem

  casename = 'tjunction'

  coupling_type = 'inlet outlet'
  coupled_scalars = 'scalar03'

  inlet_boundary  = '2'  # boundary ID for NekRS  inlet
  outlet_boundary = '3'  # boundary ID for NekRS outlet
[]


[Executioner]
  type = Transient

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[MultiApps]
  [sub]
    type = TransientMultiApp
    app_type = SamApp
    input_files = 'sam.i'
    max_procs_per_app = 1
    execute_on = TIMESTEP_BEGIN
  []
[]

[Transfers]
  [toNekRS_scalar3_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = toNekRS_tracer
    to_postprocessor   = inlet_S03
  []
  [toNekRS_velocity_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = toNekRS_velocity
    to_postprocessor   = inlet_V
  []
  [fromNekRS_scalar3_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = to_multiapp
    from_postprocessor = outlet_S03
    to_postprocessor   = fromNekRS_tracer
  []
  [fromNekRS_couplednekdP_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = to_multiapp
    from_postprocessor = coupled_nekdP
    to_postprocessor   = coupled_nekdP
  []
  [toNekRS_dudt_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = fromSAM_dudt
    to_postprocessor   = SAM_dudt
  []
[]

# BC IDS
# 1 = main line inlet
# 2 = side line inlet
# 3 = side line outlet
# 4 = main line outlet
# 5 = wall

[Postprocessors]

  [m_in_main]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '1'
  []
  [m_in_side]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '2'
  []
  [m_out_main]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '4'
  []
  [m_out_side]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '3'
  []

  [SAM_dudt]
    type = Receiver
    default = 0.0
  []

  [nekRS_accelGradPres] # rho*dudt
    type = ScalePostprocessor
    value = SAM_dudt
    scaling_factor = 997.561 # rho
    execute_on = "INITIAL TIMESTEP_END"
  []

  [nekRS_posGradPres]
    type = ScalePostprocessor
    value = dP
    scaling_factor = 1.355 # 1 divided by length of section = 1/0.738
    execute_on = "INITIAL TIMESTEP_END"
  []

  [coupled_nekdP]
    type = DifferencePostprocessor
    value1 = nekRS_posGradPres
    value2 = nekRS_accelGradPres
    execute_on = "INITIAL TIMESTEP_END"
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

  [csv]
  type = CSV
  interval = 20
  []
[]
