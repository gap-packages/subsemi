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

DeclareAttribute("Rows", IsMulTab);
DeclareAttribute("Indices", IsMulTab);
DeclareAttribute("SortedElements", IsMulTab);
DeclareAttribute("Symmetries", IsMulTab);
DeclareAttribute("OriginalName", IsMulTab);

DeclareGlobalFunction("ConjugacyClassRep");
DeclareGlobalFunction("ConjugacyClassOfSet");
