[Mesh]
  type = NekRSMesh
  boundary = '1'
[]

[Problem]
  type = NekRSSeparateDomainProblem
  casename = bentpipe

  coupling_type = 'inlet outlet'

  inlet_boundary  = '1'  # boundary ID for NekRS  inlet
  outlet_boundary = '2'  # boundary ID for NekRS outlet

[]

[Executioner]
  type = Transient
  timestep_tolerance = 1e-10

  start_time = 0

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]


[MultiApps]
  [ExternalApp]
    type = TransientMultiApp
    app_type = SamApp
    input_files = 'sam.i'
    execute_on = timestep_begin
    max_procs_per_app = 1
    sub_cycling = false
  []
[]

[Transfers]
  [NekRS_pressureDrop_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = ExternalApp
    direction = to_multiapp
    from_postprocessor = dP
    to_postprocessor   = NekRS_pressureDrop
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [fromNekRS_velocity_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = ExternalApp
    direction = to_multiapp
    from_postprocessor = outlet_V
    to_postprocessor   = fromNekRS_velocity
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [toNekRS_velocity_trans]
    type = MultiAppPostprocessorTransfer
    multi_app = ExternalApp
    direction = from_multiapp
    reduction_type = average
    from_postprocessor = toNekRS_velocity
    to_postprocessor   = inlet_V
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]


[Outputs]
  [csv]
    type = CSV
  []
  [./console]
    type = Console
    execute_postprocessors_on = INITIAL
    execute_scalars_on = INITIAL
    execute_reporters_on = INITIAL
  [../]

[]
