################################################################################
##
## SubSemi - GAP package for enumearting subsemigroups
##
## Several derived properties for multiplication tables and their elements.
## Used as invariants in embeddings and isomorphisms.
##
## Copyright (C) 2013-2016  Attila Egri-Nagy
##

#GENERIC FUNCTIONS
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
