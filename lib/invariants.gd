################################################################################
##
## SubSemi
##
## Several derived properties for multiplication tables and their elements.
## Used for quickly deciding non-isomorphism.
##
## Copyright (C) 2013-2014  Attila Egri-Nagy
##

DeclareGlobalFunction("Frequencies");

#ELEMENT-LEVEL INVARIANTS
DeclareGlobalFunction("Frequency");
DeclareGlobalFunction("DiagonalFrequency");
DeclareGlobalFunction("RowFrequencies");
DeclareGlobalFunction("ColumnFrequencies");
DeclareGlobalFunction("AbstractIndexPeriod");
DeclareGlobalFunction("ElementProfile");

#TABLE-LEVEL INVARIANTS
DeclareGlobalFunction("MulTabFrequencies");
DeclareGlobalFunction("DiagonalFrequencies");
DeclareGlobalFunction("IdempotentFrequencies");
DeclareGlobalFunction("IdempotentDiagonalFrequencies");
DeclareGlobalFunction("IndexPeriodTypeFrequencies");
DeclareGlobalFunction("ElementProfileTypes");
DeclareGlobalFunction("MulTabProfile");

#APPLYING INVARIANTS
DeclareGlobalFunction("PotentiallyIsomorphicMulTabs");
