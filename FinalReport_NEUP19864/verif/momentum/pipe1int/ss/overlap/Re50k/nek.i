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
