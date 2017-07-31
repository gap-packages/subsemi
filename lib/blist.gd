################################################################################
##
## SubSemi
##
## Extra functions for boolean lists. Indexing, encoding.
##
## Copyright (C) 2013-2017  Attila Egri-Nagy
##

if IsBound(OnBlist) then
  #newer Semigroups!
  else
    DeclareGlobalFunction("OnBlist");
fi;

DeclareGlobalFunction("BlistString");

DeclareGlobalFunction("BlistStorage");
DeclareGlobalFunction("StoreBlist");
DeclareGlobalFunction("IsInBlistStorage");

DeclareGlobalFunction("EncodeBitString");
DeclareGlobalFunction("DecodeBitString");
DeclareGlobalFunction("AsBlist");
DeclareGlobalFunction("AsBitString");

DeclareOperation("SetByIndicatorFunction",[IsList,IsList]); #todo IsBlist does not work
DeclareOperation("IndicatorFunction",[IsList,IsList]);
DeclareOperation("RecodeIndicatorFunction",[IsList,IsList,IsList]);

DeclareGlobalFunction("LoadIndicatorFunctions");
DeclareGlobalFunction("SaveIndicatorFunctions");
