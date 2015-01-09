#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J6 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J6.reps - a file containing all subs in 6-packed encoding

export LOADER="Read(\"J6defs.g\");"      #variables and functions needed 
export XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness


echo "Modding finished..."

sort -u I1CmodI2C.uppertorsos > I1CmodI2C.suts

#echo $LOADER"I1CSubsFromUpperTorsos(\"I1CmodI2C.suts\");" | gap -q -m 7g -K 14g

###### extending the uppertorsos from I1C/I2C ##################################
rm UT*
split -l 10000 K43modK42.suts UT
rm UTtasks;
for i in UT*; do echo "echo \"$XLOADER I1CSubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m 3g" >> UTtasks; done;
parallel < UTtasks
cat UT*M > I1C.reps

#echo $LOADER"K43sharp();" | gap -10g

#cat K43_T4.reps K43sharp_T4.reps P_T4.reps > T4.reps
