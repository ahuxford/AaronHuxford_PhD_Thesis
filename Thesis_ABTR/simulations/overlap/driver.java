package macro;

import java.util.*;
import java.util.concurrent.*;

import star.common.*;
import star.base.neo.*;

import java.io.*;

import star.base.report.*;
import star.energy.*;

public class driver extends StarMacro {

  public void execute() {
    execute0();
  }

  private void execute0() {

    // inputs, to possible automate
    double LP_length1 = 4.0017621118702; //3.8723248830644; // meters
    double LP_length2 = 3.7435411043556; //3.604843963336; // meters
    double dt        = 0.05; // seconds
    
    double rhou_dot_nfp_old1 = 0.0;
    double rhou_dot_nfp_old2 = 0.0;

    double time = 0.0;
    double time_offset = -200; // offset time in starccm
    double tEnd = 1000000;
    int    numInIter = 10;

    Simulation sim = getActiveSimulation();

    // dont initialize solution for VOF, can crash, instead just use last solution in starccm simulatioun

		// initialize other things
    ImplicitUnsteadySolver unsteadySolve =
      ((ImplicitUnsteadySolver) sim.getSolverManager().getSolver(ImplicitUnsteadySolver.class));

    Report time_current = sim.getReportManager().getReport("Physics Continuum Physical Time");

    double time_start = time_current.getReportMonitorValue(); // get start time of simulation

		sim.println("time_start of starccm simulation, for offsetting starccm solution files in video");
    sim.println(time_start);

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

		  time = time_current.getReportMonitorValue() - time_start + time_offset;
	          
	  	  try {
	  	    TimeUnit.MICROSECONDS.sleep(1000000); // 1.0 seconds wait between timesteps
	          } catch(InterruptedException ex){
                    sim.println("Error waiting for SYSTOCFD.csv");
	  	  }

//****************************************************************************************************
//****************************************************************************************************
	  	// wait for BC file from SAM
      File file = new File(resolvePath(System.getProperty("user.dir")+"/SYSTOCFD.csv"));
	  	while (file.exists() == false) {
        sim.println("Waiting for SYSTOCFD.csv file from SAM");
	  		try {
	  		  TimeUnit.MICROSECONDS.sleep(500000); // 0.5 seconds
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

               if (lineIndex >= 2) { // first two lines are time and dt
        	  		inputArr = line.split(delimiter);

	      			 // assumes field function name follows "boundaryname_boundarytype"
	      			 // for example: inlet massflow = inlet_massflow
	      				ff_name = inputArr[0]+"_"+inputArr[1];

                ff_obj = ((UserFieldFunction) sim.getFieldFunctionManager().getFunction(ff_name));
                ff_obj.setDefinition(inputArr[2]);
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
      Report pDropReport1 = sim.getReportManager().getReport("PressureDrop_CoreInlet");
      double pdrop1 = pDropReport1.getReportMonitorValue();
      sim.println("pdrop1");
      sim.println(pdrop1);

      double pgrad1 = pdrop1/LP_length1;
			sim.println("pgrad1");
      sim.println(pgrad1);

			Report pDropReport2 = sim.getReportManager().getReport("PressureDrop_RefInlet");
      double pdrop2 = pDropReport2.getReportMonitorValue();
      sim.println("pdrop2");
      sim.println(pdrop2);

      double pgrad2 = pdrop2/LP_length2;
			sim.println("pgrad2");
      sim.println(pgrad2);

			// inertial component
	  	Report rhouReport1 = sim.getReportManager().getReport("RhoU_CoreInlet");
      double rhou_dot_nfp_new1 = rhouReport1.getReportMonitorValue();

			Report rhouReport2 = sim.getReportManager().getReport("RhoU_RefInlet");
      double rhou_dot_nfp_new2 = rhouReport2.getReportMonitorValue();

      double rhodudt1 = (rhou_dot_nfp_new1 - rhou_dot_nfp_old1)/dt;
			sim.println("rhodudt1");
			sim.println(rhodudt1);

      double rhodudt2 = (rhou_dot_nfp_new2 - rhou_dot_nfp_old2)/dt;
			sim.println("rhodudt2");
			sim.println(rhodudt2);

			// update old value for use in next timestep
	    rhou_dot_nfp_old1 = rhouReport1.getReportMonitorValue();
	    rhou_dot_nfp_old2 = rhouReport2.getReportMonitorValue();

      double fric_info1 = pgrad1 - rhodudt1;
      double fric_info2 = pgrad2 - rhodudt2;

			sim.println("CFD_fric1");
			sim.println(fric_info1);
			sim.println("CFD_fric2");
			sim.println(fric_info2);

			// write f_CFD1 file
      File outfile1 = new File(resolvePath(System.getProperty("user.dir")+"/CFD_fric1.csv"));

			String fric_info_str1 = String.valueOf(fric_info1);

      String[][] outputArr1 = {{fric_info_str1},};

      try {
	      FileWriter fileWriter1 = new FileWriter(outfile1);

        for (String[] data : outputArr1) {
            StringBuilder line = new StringBuilder();
            for (int i = 0; i < data.length; i++) {
                line.append(data[i]);
                if (i != data.length - 1) {
                    line.append(',');
                }
            }
            line.append("\n");
            fileWriter1.write(line.toString());
        }
        fileWriter1.close();
	    } catch(IOException ex){
        sim.println("Error writing CFD_fric1.csv file");
      }
			// write f_CFD2 file
      File outfile2 = new File(resolvePath(System.getProperty("user.dir")+"/CFD_fric2.csv"));

			String fric_info_str2 = String.valueOf(fric_info2);

      String[][] outputArr2 = {{fric_info_str2},};

      try {
	      FileWriter fileWriter2 = new FileWriter(outfile2);

        for (String[] data : outputArr2) {
            StringBuilder line = new StringBuilder();
            for (int i = 0; i < data.length; i++) {
                line.append(data[i]);
                if (i != data.length - 1) {
                    line.append(',');
                }
            }
            line.append("\n");
            fileWriter2.write(line.toString());
        }
        fileWriter2.close();
	    } catch(IOException ex){
        sim.println("Error writing CFD_fric2.csv file");
      }
//****************************************************************************************************
//****************************************************************************************************
    // write boundary outlet temperature information to csv file
			Report outTempReport = sim.getReportManager().getReport("Temperature_IHXWindowOutlet");

      double temp_out = outTempReport.getReportMonitorValue();

			sim.println("CFD_Tout");
			sim.println(temp_out);

      File outfile_tempout = new File(resolvePath(System.getProperty("user.dir")+"/CFD_Tout.csv"));

			String temp_out_str = String.valueOf(temp_out);

      String[][] outputArr_out = {{temp_out_str},};

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

			// write boundary outlet absolute Pressure information to csv file
			Report outPReport = sim.getReportManager().getReport("PressureAbs_IHXWindowOutlet");

      double P_out = outPReport.getReportMonitorValue();

			sim.println("CFD_Pout");
			sim.println(P_out);

      File outfile_Pout = new File(resolvePath(System.getProperty("user.dir")+"/CFD_Pout.csv"));

			String P_out_str = String.valueOf(P_out);

      String[][] outputArr_Pout = {{P_out_str},};

      // write outlet temperature file
			try {
	      FileWriter fileWriter = new FileWriter(outfile_Pout);
        for (String[] data : outputArr_Pout) {
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
        sim.println("Error writing CFD_Pout.csv file");
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
