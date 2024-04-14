[Mesh]
  type = NekRSMesh
  boundary = '1 2'
[]

[Problem]
  type = NekRSProblem
  SAMtoNek_interface = true # specify that there is coupling interface from SAM to nekRS
#  overlap_coupling = true # specify there is overlap coupling 
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
  [SAM_mflow_transfer]
    type = MultiAppPostprocessorTransfer
    direction = from_multiapp
    reduction_type = average
    multi_app = sam
    from_postprocessor = SAM_mFlow
    to_postprocessor = SAM_mflow_inlet_interface
  []

  [coupled_nekdP]
    type = MultiAppPostprocessorTransfer
    direction = to_multiapp
    multi_app = sam
    from_postprocessor = coupled_nekdP
    to_postprocessor = coupled_nekdP
  [../]

#  [SAM_vel_transfer]
#    type = MultiAppPostprocessorTransfer
#    direction = from_multiapp
#    reduction_type = average
#    multi_app = sam
#    from_postprocessor = SAM_vel
#    to_postprocessor = SAM_vel_inlet
#  []
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

#  [nekRS_posGradPres]
  [coupled_nekdP]
    type = ScalePostprocessor
    value = nekRS_pres_drop
    scaling_factor = 0.704269 # 1 divided by length of section
    execute_on = "TIMESTEP_END"
  []

## avgUvol are calculated within Cardinal
#  [nekRS_UNewMinusUOld]
#    type = DifferencePostprocessor
#    value1 = nekRS_avgUvolNew
#    value2 = nekRS_avgUvolOld
#    execute_on = "TIMESTEP_END"
#  []
#  [nekRS_accelGradPres]
#    type = ScalePostprocessor
#    value = nekRS_UNewMinusUOld
#    scaling_factor = 997561 # rho/dt
#    execute_on = "TIMESTEP_END"
#  []
#  [coupled_nekdP]
#    type = DifferencePostprocessor
#    value1 = nekRS_posGradPres
#    value2 = nekRS_accelGradPres
#    execute_on = "TIMESTEP_END"
#  []


[]
