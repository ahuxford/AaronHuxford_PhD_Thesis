[Mesh]
  type = NekRSMesh
  boundary = '1 2'
[]

[Problem]
  type = NekRSProblem
  SAMtoNek_interface = true # specify that there is coupling interface from SAM to nekRS
  overlap_coupling = true # specify there is overlap coupling 
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

#  [nekRS_pres_drop]
#    type = MultiAppPostprocessorTransfer
#    direction = to_multiapp
#    multi_app = sam
#    from_postprocessor = nekRS_pres_drop
#    to_postprocessor = nekRS_pres_drop
#  [../]

  [coupled_nekdP]
    type = MultiAppPostprocessorTransfer
    direction = to_multiapp
    multi_app = sam
    from_postprocessor = coupled_nekdP
    to_postprocessor = coupled_nekdP
  [../]
[]


[Outputs]
  [out]
    type = CSV
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
  [nekRS_posGradPres] 
    type = ScalePostprocessor
    value = nekRS_pres_drop
    scaling_factor = 3.0 # 1 divided by length of section
    execute_on = "TIMESTEP_END"
  []
  [nekRS_avgUvolOld] 
    type = NekVolumeAverage
    field = velocity_x
    execute_on = "TIMESTEP_BEGIN"
  []
  [nekRS_avgUvolNew] 
    type = NekVolumeAverage
    field = velocity_x
    execute_on = "TIMESTEP_END"
  []
  [nekRS_UNewMinusUOld] 
    type = DifferencePostprocessor
    value1 = nekRS_avgUvolNew
    value2 = nekRS_avgUvolOld
    execute_on = "TIMESTEP_END"
  []
  [nekRS_accelGradPres] 
    type = ScalePostprocessor
    value = nekRS_UNewMinusUOld
    scaling_factor = 997561 # rho/dt
    execute_on = "TIMESTEP_END"
  []
  [coupled_nekdP] 
    type = DifferencePostprocessor
    value1 = nekRS_posGradPres
    value2 = nekRS_accelGradPres
    execute_on = "TIMESTEP_END"
  []

[]
