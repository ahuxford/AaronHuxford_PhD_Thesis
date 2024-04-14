[Mesh]
  type = NekRSMesh
  boundary = '1 2'
[]

[Problem]
  type = NekRSProblem # coupling is just branch-specific version of NekRSProblem
  SAMtoNek_interface = true # specify that there is coupling interface from SAM to nekRS
[]

[Executioner]
  type = Transient

  timestep_tolerance = 1e-10

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]

[Outputs]
  [out]
    type = CSV
  []
[]

[Postprocessors]

  [SAM_mflow_inlet_interface] # required for SAMtoNek coupling interface
    type = Receiver
  []

  [nekRS_pres_drop] # the outlet pressure = 0 so p_drop = inlet pressure
    type = NekSideAverage
    field = pressure
    boundary = '1'
  []

  [temp_inlet_interface]
    type = NekSideAverage
    field = temperature
    boundary = '1'
  []

[]
