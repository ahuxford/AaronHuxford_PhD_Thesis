[Mesh]
  type = NekRSMesh
  boundary = '1 2'
[]

[Problem]
  type = NekRSProblem
  SAMtoNek_interface = true # specify that there is coupling interface from SAM to nekRS
[]

[Executioner]
  type = Transient
  timestep_tolerance = 1e-10

  start_time = 0

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]


[Outputs]
  [out]
    type = CSV
  []
[]

[MultiApps]
  [sam]
    type = TransientMultiApp
    app_type = SamApp
    library_path = '/home/cluster2/rhu/projects/NEAMS/aaron/SAM/lib'
    input_files = 'sam.i'
    execute_on = timestep_begin
    max_procs_per_app = 1
  []
[]

[Transfers]
  [SAM_vel_transfer]
    type = MultiAppPostprocessorTransfer
    direction = to_multiapp
    reduction_type = average
    multi_app = sam
    from_postprocessor = nekRS_velocity
    to_postprocessor = nekRS_velocity
  []

  [SAM_temp_transfer]
    type = MultiAppPostprocessorTransfer
    direction = to_multiapp
    reduction_type = average
    multi_app = sam
    from_postprocessor = nekRS_temperature
    to_postprocessor = nekRS_temperature
  []
[]


[Postprocessors]
  [SAM_mflow_inlet_interface] # required for SAM-nekRS coupling interface
    type = Receiver
    default = 0.0
    execute_on = 'NONE'
  []

  [nekRS_pres_drop] 
    type = NekSideAverage
    field = pressure
    boundary = '1'
  []

  [nekRS_velocity] 
    type = NekSideAverage
    field = velocity_x
    boundary = '2'
#    execute_on = 'INITIAL TIMESTEP_END'
  []

  [nekRS_temperature] 
    type = NekSideAverage
    field = temperature
    boundary = '2'
    execute_on = 'INITIAL TIMESTEP_END'
  []

[]
