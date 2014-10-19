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
DeclareOperation("AntiMulTab",[IsSemigroup]);
DeclareGlobalFunction("CreateMulTab");
DeclareGlobalFunction("ProductTableOfElements");
DeclareGlobalFunction("SubArray");

DeclareProperty("IsAnti", IsMulTab);

DeclareAttribute("Rows", IsMulTab);
DeclareAttribute("Columns", IsMulTab);
DeclareAttribute("Indices", IsMulTab);
DeclareAttribute("SortedElements", IsMulTab);
DeclareAttribute("EquivalentGenerators", IsMulTab);
DeclareAttribute("Symmetries", IsMulTab);
DeclareAttribute("SymmetryGroup", IsMulTab);
DeclareAttribute("OriginalName", IsMulTab);
DeclareAttribute("LocalTables", IsMulTab);
DeclareAttribute("GlobalTables", IsMulTab);
DeclareAttribute("FullSet", IsMulTab);
DeclareAttribute("EmptySet", IsMulTab);
DeclareAttribute("MinimumConjugates", IsMulTab);
DeclareAttribute("MinimumConjugators", IsMulTab);
DeclareOperation("ConvergingSets", [IsMulTab,IsList]);
DeclareGlobalFunction("NilpotencyDegreeByMulTabs");

DeclareGlobalFunction("ConjugacyClassRep");
DeclareGlobalFunction("ConjugacyClassRepClever");
DeclareGlobalFunction("ConjugacyClassOfSet");

DeclareGlobalFunction("RemoveEquivalentGenerators");
