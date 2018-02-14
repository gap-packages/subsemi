#!/bin/sh

################################################################################
# Classifying all subsemigroups of T4 ##########################################
################################################################################
# INPUT: T4.reps
# OUTPUT: 

CORES="4" #number of cores

LOADER="Read(\"J6defs.g\");"      #variables and functions needed 
XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness

#3echo "FilingIndicatorFunctionsBySize(\"T4.reps\",3);" | gap -q

for i in S*; do echo "echo \"$XLOADER FilingIndicatorFunctionsBySgpTag(\\\"$i\\\", MulTab(J6,G), \\\"J6_\\\", 3);\" | gap  -q " >> tasksS; done;
parallel --jobs $CORES --joblog J6classifying.log < tasksS

