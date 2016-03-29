#!/bin/sh

################################################################################
# Classifying all subsemigroups of T4 ##########################################
################################################################################
# INPUT: T4.subs
# OUTPUT: T4.db

CORES="4" #number of cores
MEM="3800m"
CHUNKSIZE=10000

LOADER="Read(\"T4defs.g\");"      #variables and functions needed
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness

if [ ! -f T4.db ]; then
    find . -name 'SUBS*' -delete
    split -l $CHUNKSIZE T4.subs SUBS
    for i in `ls -1 SUBS*`; do
        echo "echo \"$XLOADER SgpsDatabase(\\\""$i"\\\", MulTab(T4,S4));\" \
              | gap -m $MEM" >> SUBStasks;
    done;
    parallel --jobs $CORES --joblog T4classifying.log < SUBStasks
    cat SUBS*.db > T4.db
fi;
