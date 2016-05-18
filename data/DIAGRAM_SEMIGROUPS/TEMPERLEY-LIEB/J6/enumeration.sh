#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J6 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J6.subs - a file containing all subs in 6-packed encoding

MAXMEM="30g"  #for single process
CORES="5" #number of cores
SMALLMEM="6g" #for parallel processing
# for a 32GB RAM machine

export LOADER="Read(\"J6defs.g\");"      #variables and functions needed
export XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness

# $1 upper torso files, $2 processor function, $3 previous ideal, $4 result
# $5 chunksize
lower_torso() {
    find . -name 'UT*' -delete
    split -l $5 $1 UT
    for i in UT*; do
	echo "echo \"$XLOADER I2CSubsFromUpperTorsos(\\\"$i\\\");\" \
	      | gap  -q -m $SMALLMEM" >> UTtasks;
    done;
    parallel --jobs $CORES --joblog $4.log < UTtasks
    cat $3.subs > $4.subs
    for i in  UT*.subs; do
	cat $i >> $4.subs;
    done;
}

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
    lower_torso "I2CmodI3C.subs" "I2CSubsFromUpperTorsos" "I3C" "I2C" "100000";
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
CHUNKSIZE="100"
if [ ! -f I1C.subs ]; then
    lower_torso "I1CmodI2C.subs" "I1CSubsFromUpperTorsos" "I2C" "I1C" "4";
fi;
echo "I1C done";
