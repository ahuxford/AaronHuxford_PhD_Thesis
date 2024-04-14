[Mesh]
  type = NekRSMesh
  boundary = '1'
[]

[Problem]
  type = NekRSStandaloneProblem
  casename = 'bentpipe'
[]

[Executioner]
  type = Transient

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]

[Outputs]
[]

[Postprocessors]
  [Reynolds]
    type = ReynoldsNumber
    L_ref = 0.1
    boundary = '1'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_P_inlet]
    type = NekSideAverage
    field = pressure
    boundary = '1'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_P_outlet]
    type = NekSideAverage
    field = pressure
    boundary = '2'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [P_drop]
    type = DifferencePostprocessor
    value1 = avg_P_inlet
    value2 = avg_P_outlet
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]
