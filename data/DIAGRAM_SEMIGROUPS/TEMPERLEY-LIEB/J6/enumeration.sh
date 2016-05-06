#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J6 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J6.subs - a file containing all subs in 6-packed encoding

MAXMEM="30g"  #for single process
CORES="5" #number of cores
SMALLMEM="6g" #for parallel processing
CHUNKSIZE="100000"

export LOADER="Read(\"J6defs.g\");"      #variables and functions needed
export XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness

################################################################################
# 1. subs of the smallest ideal ################################################
if [ ! -f I3C.subs ]; then
    echo $LOADER"I3CSubs();" | gap -q -m $MAXMEM
fi
echo "I3C done" #immediate, 593 subs

################################################################################
# 2. I2C mod I3C upper torsos ##################################################
if [ ! -f I2CmodI3C.subs ]; then
    echo $LOADER"I2CmodI3Csubs();" | gap -q -m $MAXMEM
fi
echo "I2C mod I3C done" # 6281514 subs, couple of hours

################################################################################
# 3. subs of I2C (lower torso extensions) ######################################
if [ ! -f I2C.subs ]; then
    find . -name 'UT*' -delete
    split -l $CHUNKSIZE I2CmodI3C.subs UT
    for i in UT*; do
	echo "echo \"$XLOADER I2CSubsFromUpperTorsos(\\\"$i\\\");\" \
	      | gap  -q -m $SMALLMEM" >> UTtasks;
    done;
    parallel --jobs $CORES --joblog I2C.log < UTtasks
    cat I3C.subs > I2C.subs
    for i in  UT*.subs; do
	cat $i >> I2C.subs;
    done;
fi;
echo "I2C done"; # 51419197, 4hours

################################################################################
# 4. I1C mod I2C upper torsos ##################################################
if [ ! -f I1CmodI2C.subs ]; then
    echo $LOADER"I1CmodI2Csubs();" | gap -q -m $MAXMEM
fi
echo "I1C mod I2C done" #

################################################################################
# 5. subs of I1C (lower torso extensions) ######################################
if [ ! -f I1C.subs ]; then
    find . -name 'UT*' -delete
    split -l $CHUNKSIZE I1CmodI2C.subs UT
    for i in UT*; do
	echo "echo \"$XLOADER I1CSubsFromUpperTorsos(\\\"$i\\\");\" \
	      | gap  -q -m $SMALLMEM" >> UTtasks;
    done;
    parallel --jobs $CORES --joblog I1C.log < UTtasks
    cat I2C.subs > I1C.subs
    for i in  UT*.subs; do
	cat $i >> I1C.subs;
    done;
fi;
echo "I1C done";
