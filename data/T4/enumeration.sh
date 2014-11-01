#!/bin/sh

LOADER="Read(\"T4defs.g\");"
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness
echo $LOADER"P_T4();" | gap

#echo $LOADER"K43modK42subs();" | gap
#sort -u K43modK42.uppertorsos > K43modK42.suts

###### extending the uppertorsos from K43/K42 ##################################
#rm UT*
#split -l 64000 K43modK42.suts UT
#rm UTtasks;
#for i in UT*; do echo "echo \"$XLOADER K43SubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m 7g" >> UTtasks; done;
#parallel < UTtasks
#cat UT*M > K43.reps

#echo $LOADER"K43sharp();" | gap -10g

cat K43_T4.reps K43sharp_T4.reps P_T4.reps > T4.reps
