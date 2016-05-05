#!/bin/sh

################################################################################
# Enumerating all subsemigroups of J6 ##########################################
################################################################################
# INPUT: none
# OUTPUT: J6.subs - a file containing all subs in 6-packed encoding

MAXMEM="7g"  #for single process
CORES="4" #number of cores
SMALLMEM="1800m" #for parallel processing


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
echo "I2C mod I3C done" # subs



