#!/bin/sh

LOADER="Read(\"T4defs.g\");"
XLOADER="Read(\\\"T4defs.g\\\");" #escape character madness
#echo $LOADER"P_T4();" | gap

#echo $LOADER"K43modK42subs();" | gap
#sort -u K43modK42.uppertorsos > K43modK42.suts
#split -n 128 K43modK42.su

rm UTtasks;
for i in UT*; do echo "echo \"$XLOADER K43SubsFromUpperTorsos(\\\"$i\\\");\" | gap  -m 8g" >> UTtasks; done; 

