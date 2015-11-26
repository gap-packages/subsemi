############################################################################
##
#W  binrel.gi
#Y  Copyright (C) 2015                                   Attila Egri-Nagy
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
## Extra functions for binary relations. (probably should go to GAP lib)
##

if not IsBound(IsBinaryRelationSemigroup) then
  DeclareProperty("IsBinaryRelationSemigroup", IsSemigroup);
fi;

DeclareGlobalFunction("ConjugateBinaryRelation");
DeclareGlobalFunction("UnionOfBinaryRelations");
