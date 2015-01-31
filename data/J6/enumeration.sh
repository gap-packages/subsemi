#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J6 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J6.reps - a file containing all subs in 6-packed encoding

MAXMEM="30g"  #for single process
CORES="4" #number of cores
SMALLMEM="7200m" #for parallel processing


export LOADER="Read(\"J6defs.g\");"      #variables and functions needed 
export XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness

echo $LOADER"I3CSubs();" | gap -q # immediate

echo $LOADER"I1CmodI2Csubs();" | gap -q -m $SMALLMEM # fast
sort -u I1CmodI2C.uppertorsos > I1CmodI2C.suts
###### extending the uppertorsos from I1C/I2C ##################################
rm U1*
split -l 1 I1CmodI2C.suts U1 #just do it one by one
for i in U1*; do echo "echo \"$XLOADER I1CSubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m $SMALLMEM" >> U1tasks; done;
parallel --jobs $CORES --joblog I1C.log < U1tasks
cat U1*M > I1CminusI2C.reps #since it surely contains sg from I1C/I2C;

echo $LOADER"I2CmodI3Csubs();" | gap -q -m $MAXMEM # 8hours
sort -u I2CmodI3C.uppertorsos > I2CmodI3C.suts
###### extending the uppertorsos from I2C/I3C ##################################
rm U2*
split -l 10000 I2CmodI3C.suts U2
for i in U2*; do echo "echo \"$XLOADER I2CSubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m $SMALLMEM" >> U2tasks; done;
parallel --jobs $CORES --joblog I2C.log < U2tasks
cat U2*M > I2CminusI3C.reps #since it surely contains sg from I2C/I3C;

echo $LOADER"RecodeToJ6();" | gap -q -m $SMALLMEM

cat I3C_J6.reps I2CminusI3C_J6.reps I1CminusI2C_J6.reps > I1C_J6.reps


