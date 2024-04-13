# pull iterations line from logfile and put into text file for plotting


####################
vers=ic_ss

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v1

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v2

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v3

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v4

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v8

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v10

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v11

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v12

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
# only runs on Overlap, not separate
vers=ic_v6

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt

####################
vers=ic_v13

dnam=Overlapping
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
dnam=Decomposition
grep 'C= ' $dnam/$vers/logfile > $dnam/$vers/iterations.txt
