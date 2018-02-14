#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J5 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J5.subs - a file containing all subs in 6-packed encoding

MAXMEM="8g"  #for single process
CORES="5" #number of cores
SMALLMEM="1500m" #for parallel processing

export LOADER="Read(\"J5defs.g\");"      #variables and functions needed
export XLOADER="Read(\\\"J5defs.g\\\");" #escape character madness

################################################################################
# 1. subs of the smallest ideal ################################################
if [ ! -f I2C.subs ]; then
    echo $LOADER"I2CSubs();" | gap -q -m $MAXMEM
fi
echo "I2C done" 

################################################################################
# 2. I1C mod I2C upper torsos ##################################################
if [ ! -f I1CmodI2C.subs ]; then
    echo $LOADER"I1CmodI2Csubs();" | gap -q -m $MAXMEM
fi
echo "I1C mod I2C done" # 

################################################################################
# 3. subs of I2C (lower torso extensions) ######################################
CHUNKSIZE="10"
if [ ! -f I1C.subs ]; then
    find . -name 'UT*' -delete
    split -l $CHUNKSIZE I1CmodI2C.subs UT
    for i in UT*; do
	echo "echo \"$XLOADER I2CSubsFromUpperTorsos(\\\"$i\\\");\" \
	      | gap  -q -m $SMALLMEM" >> UTtasks;
    done;
    parallel --jobs $CORES --joblog I2C.log < UTtasks
    cat I2C.subs > I1C.subs
    for i in  UT*.subs; do
	cat $i >> I1C.subs;
    done;
fi;
echo "I1C done"; #
