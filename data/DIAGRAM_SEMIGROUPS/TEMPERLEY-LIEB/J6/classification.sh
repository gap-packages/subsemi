#!/bin/sh

################################################################################
# Classifying all subsemigroups of J6 ##########################################
################################################################################
# INPUT: J6.subs
# OUTPUT: J6.db

CORES="5" #number of cores
MEM="5500m"
CHUNKSIZE=10000

LOADER="Read(\"J6defs.g\");"      #variables and functions needed
XLOADER="Read(\\\"J6defs.g\\\");" #escape character madness

if [ ! -f J6.db ]; then
    #removing any leftover chunks
    find . -name 'SUBS*' -delete
    #splitting the big file into chunks
    split -l $CHUNKSIZE I1C.subs SUBS
    #creating a script for each chunk
    for i in `ls -1 SUBS*`; do
	echo "echo \"$XLOADER SgpsDatabase(\\\""$i"\\\", MulTab(J6,G));\" \
	      | gap -m $MEM" >> SUBStasks;
    done;
    #processing the chunks with parallel
    parallel --jobs $CORES --joblog J6classifying.log < SUBStasks
    #merging the the chunk databases into a single file
    cat SUBS*.db > J6.db
fi;
