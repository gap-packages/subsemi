#!/bin/sh

################################################################################
# Classifying all subsemigroups of T4 ##########################################
################################################################################
# INPUT: T4.reps
# OUTPUT: 

CORES="16" #number of cores

LOADER="Read(\"T4defs.g\");"      #variables and functions needed 
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness

echo "FilingIndicatorFunctionsBySize(\"T4.reps\",3);" | gap -q

for i in S*; do echo "echo \"$XLOADER FilingIndicatorFunctionsBySgpTag(\\\"$i\\\", mtT4, \\\"T4_\\\", 3);\" | gap  -q " >> tasksS; done;
parallel --jobs $CORES --job-log T4classifying.log < tasksS

