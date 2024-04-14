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

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]

[MultiApps]
  [sam]
    type = TransientMultiApp
    app_type = SamApp
    library_path = '/home/cluster2/rhu/projects/NEAMS/aaron/SAM/lib'
    input_files = 'sam.i'
    sub_cycling = true
    execute_on = timestep_begin
    max_procs_per_app = 1
  []
[]

[Transfers]
  [SAM_mflow_transfer]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    reduction_type = average
    multi_app = sam
    from_postprocessor = SAM_mFlow
    to_postprocessor = SAM_mflow_inlet_interface
  []

  [nekRS_pres_drop]
    type = MultiAppPostprocessorTransfer
    direction = to_multiapp
    multi_app = sam
    from_postprocessor = nekRS_pres_drop
    to_postprocessor = nekRS_pres_drop
  [../]
[]


[Outputs]
  [out]
    type = CSV
    execute_on = 'final'
  []
[]

[Postprocessors]
  [SAM_mflow_inlet_interface] # required for SAM-nekRS coupling interface
    type = Receiver
  []

  [nekRS_pres_drop] 
    type = NekSideAverage
    field = pressure
    boundary = '1'
  []

[]
