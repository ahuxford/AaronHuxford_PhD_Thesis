//
// STARCCM+ java macro for coupling with SAM
//
package macro;

import java.util.*;
import java.util.concurrent.*;
import java.lang.Math;

import star.common.*;
import star.base.neo.*;

import java.io.*;

import star.base.report.*;
import star.energy.*;
import star.turbulence.*;

public class driver extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    // inputs, to possible automate
    double LP_length = 0.9; // meters
    double dt        = 0.1; // seconds
    
//    double rhou_dot_nfp_old = 0.0;
    double mdot_old = 1.32566; // initial condition
    double Vscaling = 1.0;  //69.28; // Vol_real/Vol_coupledPipeinSAM

    double time = 0.0;
    double tEnd = 999999;
    int    numInIter = 10;

		Simulation sim = getActiveSimulation();

		// change boundary turbulent intensity
    Region region_0 = 
      sim.getRegionManager().getRegion("LBE_2D");

    Boundary boundary_0 = 
      region_0.getBoundaryManager().getBoundary("LBE.inlet");

    TurbulenceIntensityProfile turbulenceIntensityProfile_0 = 
      boundary_0.getValues().get(TurbulenceIntensityProfile.class);

    Units units_0 = 
      ((Units) sim.getUnitsManager().getObject(""));

    turbulenceIntensityProfile_0.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValueAndUnits(0.1, units_0);

    Boundary boundary_1 = 
      region_0.getBoundaryManager().getBoundary("LBE.outlet");

    TurbulenceIntensityProfile turbulenceIntensityProfile_1 = 
      boundary_1.getValues().get(TurbulenceIntensityProfile.class);

    turbulenceIntensityProfile_1.getMethod(ConstantScalarProfileMethod.class).getQuantity().setValueAndUnits(0.1, units_0);


		// initialize solution
		Solution solution_0 = sim.getSolution();
    solution_0.clearSolution(Solution.Clear.History, Solution.Clear.Fields, Solution.Clear.LagrangianDem);
    solution_0.initializeSolution();

		// initialize other things
    ImplicitUnsteadySolver unsteadySolve =
      ((ImplicitUnsteadySolver) sim.getSolverManager().getSolver(ImplicitUnsteadySolver.class));

    Report time_current = sim.getReportManager().getReport("Physics Continuum Physical Time");

    InnerIterationStoppingCriterion inIterStopCrit =
      ((InnerIterationStoppingCriterion) sim.getSolverStoppingCriterionManager().getSolverStoppingCriterion("Maximum Inner Iterations"));

    PhysicalTimeStoppingCriterion physTimeStopCrit =
      ((PhysicalTimeStoppingCriterion) sim.getSolverStoppingCriterionManager().getSolverStoppingCriterion("Maximum Physical Time"));

		unsteadySolve.setFreezeTime(false); // To keep CCM+ happy, from tim files

		// set transient solver parameters
    physTimeStopCrit.getMaximumTime().setValue(tEnd);
    inIterStopCrit.setMaximumNumberInnerIterations(numInIter);
    unsteadySolve.getTimeStep().setValue(dt);

//****************************************************************************************************
//****************************************************************************************************
		// execute over time
    while (time < tEnd){

		  time = time_current.getReportMonitorValue();

//****************************************************************************************************
//****************************************************************************************************
	  	// wait for BC file from SAM
      File file = new File(resolvePath(System.getProperty("user.dir")+"/SYSTOCFD.csv"));
	  	while (file.exists() == false) {
        sim.println("Waiting for SYSTOCFD.csv file from SAM");
	  		try {
	  		  TimeUnit.SECONDS.sleep(1);
//	  		  TimeUnit.MICROSECONDS.sleep(100000); // 0.1 seconds
	      } catch(InterruptedException ex){
          sim.println("Error waiting for SYSTOCFD.csv");
	  		}
	  	}
//****************************************************************************************************
//****************************************************************************************************
	  	// read input CSV file and delete
	  	if (file.exists()) {
        try {
	        FileReader fr = new FileReader(file);
	      	BufferedReader br = new BufferedReader(fr);
          String line = "";
	      	String delimiter = ", ";
          String[] inputArr;

	      	Integer lineIndex = 0;
	      	String ff_name = "";
          UserFieldFunction ff_obj;

          while((line = br.readLine()) != null) {

            if (lineIndex == 1) { // line with dt

              inputArr = line.split(delimiter);
              sim.println("dt = "+inputArr[1]);

              unsteadySolve.getTimeStep().setValue(Double.valueOf(inputArr[1]));

            }
            if (lineIndex >= 2) { // first two lines are time and dt
        	  		inputArr = line.split(delimiter);

	      			 // assumes field function name follows "boundaryname_boundarytype"
	      			 // for example: inlet massflow = inlet_massflow
	      				ff_name = inputArr[0]+"_"+inputArr[1];

                ff_obj = ((UserFieldFunction) sim.getFieldFunctionManager().getFunction(ff_name));
                ff_obj.setDefinition(inputArr[2]);
                sim.println("input value to SAM = "+inputArr[2]);
            }
	      		lineIndex += 1;
	      	}
          br.close();
	      } catch(IOException ex){
          sim.println("Error reading SYSTOCFD.csv file from SAM");
        }
        file.delete(); // delete file
	  	} else {
        sim.println("Input file from SAM missed in reader...");
	  	}
//****************************************************************************************************
//****************************************************************************************************
      // STARCCM time marching
      sim.getSimulationIterator().step(1);

//****************************************************************************************************
//****************************************************************************************************
    // write friction factor information to csv file
      Report pDropReport = sim.getReportManager().getReport("Pressure Drop");
      double pdrop = pDropReport.getReportMonitorValue();
      sim.println("pdrop");
      sim.println(pdrop);

//			Report pDropReport_man = sim.getReportManager().getReport("Pressure Drop Manual");
//      double pdrop_man = pDropReport_man.getReportMonitorValue();
//      sim.println("pdrop_manual");
//      sim.println(pdrop_man);

      double pgrad = pdrop/LP_length;
			sim.println("pgrad");
      sim.println(pgrad);

			Report mdotReport = sim.getReportManager().getReport("MassFlow_inlet");
      double mdot_new = mdotReport.getReportMonitorValue();
			sim.println("mdot_new");
			sim.println(mdot_new);
      double rhodudt_mdot = Vscaling*(mdot_new - mdot_old)/dt;
			sim.println("rhodudt_mdot");
			sim.println(rhodudt_mdot);


      // update old value for use in next timestep
      mdot_old         = mdotReport.getReportMonitorValue();

      double fric_info = pgrad - rhodudt_mdot;
      sim.println("CFD_fric used mdot");
      sim.println(fric_info);

      File outfile = new File(resolvePath(System.getProperty("user.dir")+"/CFD_fric.csv"));

			String fric_info_str = String.valueOf(fric_info);

      String[][] outputArr = {{fric_info_str},};

      try {
	      FileWriter fileWriter = new FileWriter(outfile);

        for (String[] data : outputArr) {
            StringBuilder line = new StringBuilder();
            for (int i = 0; i < data.length; i++) {
                line.append(data[i]);
                if (i != data.length - 1) {
                    line.append(',');
                }
            }
            line.append("\n");
            fileWriter.write(line.toString());
        }
        fileWriter.close();
	    } catch(IOException ex){
        sim.println("Error writing CFD_fric.csv file");
      }
//****************************************************************************************************
//****************************************************************************************************
    // write boundary inlet and outlet temperature information to csv file
      Report inTempReport  = sim.getReportManager().getReport("Surface Average Inlet Temperature");
			Report outTempReport = sim.getReportManager().getReport("Surface Average Outlet Temperature");

			double temp_in  = inTempReport.getReportMonitorValue();
      double temp_out = outTempReport.getReportMonitorValue();

      File outfile_tempin  = new File(resolvePath(System.getProperty("user.dir")+"/CFD_Tin.csv"));
      File outfile_tempout = new File(resolvePath(System.getProperty("user.dir")+"/CFD_Tout.csv"));

			String temp_in_str  = String.valueOf(temp_in);
			String temp_out_str = String.valueOf(temp_out);

      String[][] outputArr_in  = {{temp_in_str},};
      String[][] outputArr_out = {{temp_out_str},};

      // write inlet temperature file
			try {
	      FileWriter fileWriter = new FileWriter(outfile_tempin);
        for (String[] data : outputArr_in) {
            StringBuilder line = new StringBuilder();
            for (int i = 0; i < data.length; i++) {
                line.append(data[i]);
                if (i != data.length - 1) {
                    line.append(',');
                }
            }
            line.append("\n");
            fileWriter.write(line.toString());
        }
        fileWriter.close();
	    } catch(IOException ex){
        sim.println("Error writing CFD_Tin.csv file");
      }
      // write outlet temperature file
			try {
	      FileWriter fileWriter = new FileWriter(outfile_tempout);
        for (String[] data : outputArr_out) {
            StringBuilder line = new StringBuilder();
            for (int i = 0; i < data.length; i++) {
                line.append(data[i]);
                if (i != data.length - 1) {
                    line.append(',');
                }
            }
            line.append("\n");
            fileWriter.write(line.toString());
        }
        fileWriter.close();
	    } catch(IOException ex){
        sim.println("Error writing CFD_Tout.csv file");
      }

      // write CFDTOSYS.csv file, needed by SAM executioner
      File outfile_sam  = new File(resolvePath(System.getProperty("user.dir")+"/CFDTOSYS.csv"));
			try {
	      FileWriter fileWriter = new FileWriter(outfile_sam);
        fileWriter.write("");
        fileWriter.close();
	    } catch(IOException ex){
        sim.println("Error writing CFDTOSYS.csv file");
      }

		} // time marching while loop
  }
}
