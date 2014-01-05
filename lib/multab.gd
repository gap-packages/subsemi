################################################################################
##
## SubSemi
##
## Multiplication table for magmas
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#just having the type to have attributes
DeclareCategory("IsMulTab", IsObject and IsAttributeStoringRep);
BindGlobal("MulTabFamily",NewFamily("MulTabFamily",IsMulTab));
BindGlobal("MulTabType", NewType(MulTabFamily,IsMulTab));

DeclareOperation("MulTab",[IsSemigroup]);
DeclareGlobalFunction("CreateMulTab");
DeclareGlobalFunction("ProductTableOfElements");
DeclareGlobalFunction("SubArray");

DeclareAttribute("Rows", IsMulTab);
DeclareAttribute("Columns", IsMulTab);
DeclareAttribute("Indices", IsMulTab);
DeclareAttribute("SortedElements", IsMulTab);
DeclareAttribute("EquivalentGenerators", IsMulTab);
DeclareAttribute("Symmetries", IsMulTab);
DeclareAttribute("OriginalName", IsMulTab);
DeclareAttribute("LocalTables", IsMulTab);
DeclareAttribute("GlobalTables", IsMulTab);
DeclareAttribute("FullSet", IsMulTab);
DeclareAttribute("EmptySet", IsMulTab);

DeclareGlobalFunction("ConjugacyClassRep");
DeclareGlobalFunction("ConjugacyClassOfSet");
