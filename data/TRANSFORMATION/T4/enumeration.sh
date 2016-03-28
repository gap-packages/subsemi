#!/bin/sh

################################################################################
# Enumerating all subsemigroups of T4 ##########################################
################################################################################
# INPUT: none
# OUTPUT: T4.reps - a file containing all subs in 6-packed encoding

MAXMEM="15g"  #for single process
CORES="4" #number of cores
SMALLMEM="3800m" #for parallel processing

LOADER="Read(\"T4defs.g\");"      #variables and functions needed
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness

#subs with nontrivial subgroup + trivial group #################################
if [ ! -f P_T4.subs ]; then
    echo $LOADER"P_T4();" | gap -q -m $MAXMEM
fi
echo "P_T4 done"

#subs of K42 ###################################################################
if [ ! -f K42.subs ]; then
    echo $LOADER"K42Subs();" | gap -q -m $MAXMEM
fi
echo "K42 done"

#subs of K43 mod K42 ###########################################################
if [ ! -f K43modK42.subs ]; then
    echo $LOADER"K43modK42subs();" | gap -q -m $MAXMEM
fi
echo "K43modK42 done"


# sort -u K43modK42.uppertorsos > K43modK42.suts

# ###### extending the uppertorsos from K43/K42 ##################################
# rm UT*
# split -l 2000 K43modK42.suts UT
# rm UTtasks;
# for i in UT*; do echo "echo \"$XLOADER K43SubsFromUpperTorsos(\\\"$i\\\");\" | gap  -q -m $SMALLMEM" >> UTtasks; done;
# parallel --jobs $CORES --joblog K43modK42.log < UTtasks
# cat K42_K43.reps > K43.reps
# for i in  UT*M; do cat $i >> K43.reps; done;

# echo $LOADER"K43sharp();" | gap -q -m $MAXMEM

# cat K42.subs P_T4.subs > T4.subs
