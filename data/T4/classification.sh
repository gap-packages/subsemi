#!/bin/sh

################################################################################
# Classifying all subsemigroups of T4 ##########################################
################################################################################
# INPUT: T4.reps
# OUTPUT: T4.reps - a file containing all subs in 6-packed encoding

LOADER="Read(\"T4defs.g\");"      #variables and functions needed 
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness

# in gaprc put SemigroupsOptionsRec.hashlen:=NextPrimeInt(2*256); to save memory

<<<<<<< local
rm X*
split -l 100000 T4.reps X
rm Xtasks;
=======
#subs of K43 mod K42
echo $LOADER"K43modK42subs();" | gap -q -m 7g
sort -u K43modK42.uppertorsos > K43modK42.suts
>>>>>>> other

for i in X*; do echo "echo \"$XLOADER IndicatorSetsTOClassifiedSmallGenSet(LoadIndicatorSets(\\\"$i\\\"),MulTab(T4),\\\"T4_\\\",3);\" | gap  -q -m 6g" >> Xtasks; done;
parallel --joblog X.log < Xtasks



