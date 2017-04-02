#!/bin/sh

################################################################################
# Enumerating all subsemigroups of I4 ##########################################
################################################################################
# INPUT: none
# OUTPUT: I4.subs - a file containing all subs in 6-packed encoding

MAXMEM="15g"  #for single process
CORES="4" #number of cores
SMALLMEM="3800m" #for parallel processing
CHUNKSIZE=2000 #num of subs for one process


LOADER="Read(\"I4defs.g\");"      #variables and functions needed
XLOADER="Read(\\\"I4defs.g\\\");" #escape character madness

################################################################################
# 1. subs with nontrivial subgroup + trivial group #############################
if [ ! -f P_I4.subs ]; then
    echo $LOADER"P_I4();" | gap -q -m $MAXMEM
fi
echo "P_I4 done"

################################################################################
# 2. subs of K41 ###############################################################
if [ ! -f I41.subs ]; then
    echo $LOADER"I41SubsOneShot();" | gap -q -m $MAXMEM
fi
echo "I41 done"

################################################################################
# 3. subs of I42 mod I41 (upper torsos) ########################################
if [ ! -f I42modI41.subs ]; then
    echo $LOADER"I42modI41subs();" | gap -q -m $MAXMEM
fi
echo "I42modI41 done"
