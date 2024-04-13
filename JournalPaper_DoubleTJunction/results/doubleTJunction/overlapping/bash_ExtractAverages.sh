# pull planar averages from logfile

echo "Pulling from logfile, writing to txt files"

grep 'Avg time' logfile > Time_avg.txt

# WM2 closer to junction that previous mesh
grep 'S WM2 avg' logfile > S3_WM2_avg.txt
grep 'S WM2 wgt' logfile > S3_WM2_avg_Uwgt.txt

# WM3
grep 'S WM3 avg' logfile > S3_WM3_avg.txt
grep 'S WM3 wgt' logfile > S3_WM3_avg_Uwgt.txt


echo "done"



