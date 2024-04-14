[Mesh]
  type = NekRSMesh
  boundary = '1'
[]

[Problem]
  type = NekRSSeparateDomainProblem
  casename = 'pipe'

  coupling_type = 'inlet'
  inlet_boundary  = '1' # nek inlet bid
  outlet_boundary = '2' # nek outlet bid

[]

[Executioner]
  type = Transient

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]

[MultiApps]
  [sub]
    type = TransientMultiApp
    app_type = SamApp
    input_files = 'sam.i'
    max_procs_per_app = 1
    execute_on = TIMESTEP_BEGIN
  []

[Transfers]
  [toNekRS_velocity_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = toNekRS_velocity
    to_postprocessor   = inlet_V
  []
  [toNekRS_temperature_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = sub
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = toNekRS_temperature
    to_postprocessor   = inlet_T
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

[Postprocessors]
  [SAM_dudt]
    type = Receiver
    default = 0.0
  []
  [nekRS_accelGradPres] # rho*dudt
    type = ScalePostprocessor
    value = SAM_dudt
    scaling_factor = 1.0 # rho
    execute_on = "INITIAL TIMESTEP_END"
  []
  [nekRS_posGradPres]
    type = ScalePostprocessor
    value = dP
    scaling_factor = 1.0 # 1 divided by length of section = 1/1
    execute_on = "INITIAL TIMESTEP_END"
  []
  [coupled_nekdP]
    type = DifferencePostprocessor
    value1 = nekRS_posGradPres
    value2 = nekRS_accelGradPres
    execute_on = "INITIAL TIMESTEP_END"
  []
[]
