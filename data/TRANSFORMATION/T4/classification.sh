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
    #removing any leftover chunks
    find . -name 'SUBS*' -delete
    #splitting the big file into chunks
    split -l $CHUNKSIZE T4.subs SUBS
    #creating a script for each chunk
    for i in `ls -1 SUBS*`; do
        echo "echo \"$XLOADER SgpsDatabase(\\\""$i"\\\", MulTab(T4,S4));\" \
              | gap -m $MEM" >> SUBStasks;
    done;
    #processing the chunks with parallel
    parallel --jobs $CORES --joblog T4classifying.log < SUBStasks
    #merging the the chunk databases into a single file
    cat SUBS*.db > T4.db
fi;
