################################################################################
##
## SubSemi
##
## Extra functions for boolean lists. Indexing, encoding.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

DeclareGlobalFunction("FirstEntryPosOr1");
DeclareGlobalFunction("LastEntryPosOr1");
DeclareGlobalFunction("HeavyBlistContainer");
DeclareGlobalFunction("LightBlistContainer");

DeclareGlobalFunction("EncodeBitString");
DeclareGlobalFunction("DecodeBitString");
DeclareGlobalFunction("AsBlist");
DeclareGlobalFunction("AsBitString");

DeclareOperation("SetByIndicatorFunction",[IsList,IsList]); #todo IsBlist does not work
DeclareOperation("IndicatorFunction",[IsList,IsList]);
DeclareOperation("ReCodeIndicatorSet",[IsList,IsList,IsList]);

DeclareGlobalFunction("LoadIndicatorSets");
DeclareGlobalFunction("SaveIndicatorSets");
