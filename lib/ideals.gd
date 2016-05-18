################################################################################
##
## SubSemi
##
## Distributing subsemigroup enumeration along the ideal structure
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

DeclareOperation("SubSgpsByIdeal",[IsSemigroupIdeal]);
DeclareOperation("SubSgpsByIdealChain",[IsList]);

DeclareGlobalFunction("ReesFactorHomomorphism");
DeclareGlobalFunction("UpperTorsos");
DeclareGlobalFunction("SubSgpsByUpperTorsos");
