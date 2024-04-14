#mamba activate moose

# update ICs
cp CSVfiles_IC/* .

# remove output starccm files
rm *.log *.out
#rm starccm0000*
#rm starccm.case

# run starccm and sam
/home/ahuxford_local/17.06.008-R8/STAR-CCM+17.06.008-R8/star/bin/starccm+ -np 26 -batch driver.java starccm.sim > logfile_starccm & 

mpirun -np 6 /home/ahuxford_local/SAM/sam-opt -i sam.i 2>&1 > logfile_sam &

