#!/bin/sh

################################################################################
# Enumerating all subsemigroups of I4 ##########################################
################################################################################
# INPUT: none
# OUTPUT: I4.reps - a file containing all subs in 6-packed encoding

LOADER="Read(\"I4defs.g\");"      #variables and functions needed 
XLOADER="Read(\\\"I4defs.g\\\");" #escape character madness

#subs with nontrivial subgroup + trivial group
echo $LOADER"P_I4();" | gap -q -m 30g

#subs of I43 mod I42
echo $LOADER"I43modI42subs();" | gap -q -m 30g
sort -u I43modI42.uppertorsos > I43modI42.suts

###### extending the uppertorsos from I43/I42 ##################################
rm UT*
split -l 10000 I43modI42.suts UT
rm UTtasks;
for i in UT*; do echo "echo \"$XLOADER I43SubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m 7g" >> UTtasks; done;
parallel < UTtasks
cat UT*M > I43.reps

echo $LOADER"I43sharp();" | gap -m 30g

cat I43_I4.reps I43sharp_I4.reps P_I4.reps > I4.reps
