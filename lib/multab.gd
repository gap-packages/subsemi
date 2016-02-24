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
DeclareGlobalFunction("CopyMulTab");
DeclareGlobalFunction("ProductTableOfElements");

DeclareProperty("IsAnti", IsMulTab);

DeclareAttribute("Rows", IsMulTab);
DeclareAttribute("Columns", IsMulTab);
DeclareAttribute("Indices", IsMulTab);
DeclareAttribute("Elts", IsMulTab);
DeclareAttribute("Symmetries", IsMulTab);
DeclareAttribute("SymmetryGroup", IsMulTab);
DeclareAttribute("OriginalName", IsMulTab);
DeclareAttribute("LocalTables", IsMulTab);
DeclareAttribute("GlobalTables", IsMulTab);
DeclareAttribute("FullSet", IsMulTab);
DeclareAttribute("EmptySet", IsMulTab);
DeclareAttribute("MonogenicSgps", IsMulTab);

DeclareOperation("ConvergingSets", [IsMulTab,IsList]);
DeclareGlobalFunction("NilpotencyDegreeByMulTabs");

DeclareGlobalFunction("DistinctGenerators");
