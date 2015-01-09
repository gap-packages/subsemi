#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J6 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J6.reps - a file containing all subs in 6-packed encoding

export LOADER="Read(\"J6defs.g\");"      #variables and functions needed 
export XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness

echo $LOADER"I1CmodI2Csubs();" | gap -q -m 2g # fast
sort -u I1CmodI2C.uppertorsos > I1CmodI2C.suts
###### extending the uppertorsos from I1C/I2C ##################################
rm UT*
split -l 100 I1CmodI2C.suts UT
rm UTtasks;
for i in UT*; do echo "echo \"$XLOADER I1CSubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m 7g" >> UTtasks; done;
parallel < UTtasks
cat UT*M > I1CminusI2C.reps #since it surely contains sg from I1C/I2C;

echo $LOADER"I2CmodI3Csubs();" | gap -q -m 7g -K 14g # 8hours
sort -u I2CmodI3C.uppertorsos > I2CmodI3C.suts
###### extending the uppertorsos from I2C/I3C ##################################
rm UT*
split -l 10000 I2CmodI3C.suts UT
rm UTtasks;
for i in UT*; do echo "echo \"$XLOADER I2CSubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m 7g" >> UTtasks; done;
parallel < UTtasks
cat UT*M > I2CminusI3C.reps #since it surely contains sg from I2C/I3C;



