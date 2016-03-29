#!/bin/sh

################################################################################
# Enumerating all subsemigroups of T4 ##########################################
################################################################################
# SubSemi package for GAP ######################################################
################################################################################
# INPUT: none
# OUTPUT: T4.subs - a file containing all T4 sub conj reps in 6-packed encoding

MAXMEM="15g"  #for single process
CORES="4" #number of cores
SMALLMEM="3800m" #for parallel processing
CHUNKSIZE=2000 #num of subs for one process

LOADER="Read(\"T4defs.g\");"      #variables and functions needed
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness

################################################################################
# 1. subs with nontrivial subgroup + trivial group #############################

if [ ! -f P_T4.subs ]; then
    echo $LOADER"P_T4();" | gap -q -m $MAXMEM
fi
echo "P_T4 done"

################################################################################
# 2. subs of K42 ###############################################################

if [ ! -f K42.subs ]; then
    echo $LOADER"K42Subs();" | gap -q -m $MAXMEM
fi
echo "K42 done"

################################################################################
# 3. subs of K43 mod K42 (upper torsos) ########################################

if [ ! -f K43modK42.subs ]; then
    echo $LOADER"K43modK42subs();" | gap -q -m $MAXMEM
fi
echo "K43modK42 done"

################################################################################
# 4. subs of K43 (lower torso extensions) ######################################

if [ ! -f K43.subs ]; then
    find . -name 'UT*' -delete
    split -l $CHUNKSIZE K43modK42.subs UT
    for i in UT*; do
        echo "echo \"$XLOADER K43SubsFromUpperTorsos(\\\"$i\\\");\" \
              | gap  -q -m $SMALLMEM" >> UTtasks;
    done;
    parallel --jobs $CORES --joblog K43modK42.log < UTtasks
    cat K42.subs > K43.subs
    for i in  UT*.subs; do
        cat $i >> K43.subs;
    done;
fi;

################################################################################
# 5. K43 sharp (adding identity to Sub(K43)) ###################################

if [ ! -f K43sharp.subs ]; then
    echo $LOADER"K43sharp();" | gap -q -m $MAXMEM
fi;

################################################################################
# 6. merging total #############################################################

if [ ! -f T4.subs ]; then
    cat K43.subs K43sharp.subs P_T4.subs > T4.subs
fi;
