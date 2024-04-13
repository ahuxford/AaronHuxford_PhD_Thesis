[Mesh]                                                                                                                                                                                                       type = NekRSMesh
  boundary = '1'
[]

[Problem]
  type = NekRSSeparateDomainProblem
  casename = pipe

  coupling_type = 'inlet outlet'

  inlet_boundary  = '1'  # boundary ID for NekRS  inlet
  outlet_boundary = '2'  # boundary ID for NekRS outlet

[]

[Executioner]
  type = Transient
  timestep_tolerance = 1e-10

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]

[MultiApps]
  [ExternalApp]
    type = TransientMultiApp
    app_type = SamApp
    input_files = 'samLoop.i'
    execute_on = timestep_begin
    max_procs_per_app = 1
    sub_cycling = false
  []
[]

[Postprocessors]

  [SAM_dudt]
    type = Receiver
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
    scaling_factor = 1.0 # 1 divided by length of section = 1/1.0
    execute_on = "INITIAL TIMESTEP_END"
  []

  [coupled_nekdP]
    type = DifferencePostprocessor
    value1 = nekRS_posGradPres
    value2 = nekRS_accelGradPres
    execute_on = "INITIAL TIMESTEP_END"
  []
[]

[Transfers]
  [NekRS_couplednekdP_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = ExternalApp
    direction = to_multiapp
    from_postprocessor = coupled_nekdP
    to_postprocessor   = coupled_nekdP
  []
  [toNekRS_velocity_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = ExternalApp
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = toNekRS_velocity
    to_postprocessor   = inlet_V
  []
  [SAMdudt_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = ExternalApp
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = SAM_dudt
    to_postprocessor   = SAM_dudt
  []
[]

[Outputs]
  [./console]
    type = Console
    execute_postprocessors_on = INITIAL
    execute_scalars_on = INITIAL
    execute_reporters_on = INITIAL
  [../]
  [out]
    type = CSV
  []
[]
