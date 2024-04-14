# runs SAM and STARCCM at same time
# - run with nohup to prevent simulation from stopping when logged off
# - nohup bash run_ners14.sh

# need moose environment to run SAM
mamba activate moose

# update ICs
cp CSVfiles_IC/* .

# run starccm
/home/ahuxford_local/17.06.008-R8/STAR-CCM+17.06.008-R8/star/bin/starccm+ -np 28 -batch driver.java starccm.sim > logfile_starccm &

# run sam
mpirun -np 8 /home/ahuxford_local/SAM/sam-opt -i sam.i > logfile_sam &

