#!/bin/sh

################################################################################
# Enumerating all subsemigroups of T4 ##########################################
################################################################################
# INPUT: none
# OUTPUT: T4.reps - a file containing all subs in 6-packed encoding

MAXMEM="15g"  #for single process
CORES="4" #number of cores
SMALLMEM="3800m" #for parallel processing

LOADER="Read(\"T4defs.g\");"      #variables and functions needed 
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness

#subs with nontrivial subgroup + trivial group
echo $LOADER"P_T4();" | gap -q -m $MAXMEM

#subs of K42
echo $LOADER"K42SubReps;" | gap -q -m $MAXMEM

#subs of K43 mod K42
echo $LOADER"K43modK42subs();" | gap -q -m $MAXMEM
sort -u K43modK42.uppertorsos > K43modK42.suts

###### extending the uppertorsos from K43/K42 ##################################
rm UT*
split -l 2000 K43modK42.suts UT
rm UTtasks;
for i in UT*; do echo "echo \"$XLOADER K43SubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m $SMALLMEM" >> UTtasks; done;
parallel --jobs $CORES --job-log K43modK42.log < UTtasks
cat K42_K43.reps > K43.reps
for i in  UT*M; do cat $i >> K43.reps; done; 

echo $LOADER"K43sharp();" | gap -q -m $MAXMEM

cat K43_T4.reps K43sharp_T4.reps P_T4.reps > T4.reps
