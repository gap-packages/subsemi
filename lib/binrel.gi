################################################################################
##
## SubSemi
##
## Extra functions for binary relations.
##
## Copyright (C) 2013-2014  Attila Egri-Nagy
##

InstallGlobalFunction(ConjugateBinaryRelation,
function(rel, perm)
  local l,newrel, i;
  newrel := [];
  l := Successors(rel);
  #first moving the domains
  for i in [1..Size(l)] do
    newrel[i^perm] := l[i];
  od;
  #then moving the images
  newrel := List(newrel, x-> List(x, y->y^perm));
  return BinaryRelationOnPoints(newrel);
end);
#registering it as a method
InstallOtherMethod(\^, "for relabelling list based binary relations",
        [IsBinaryRelation, IsPerm], ConjugateBinaryRelations);
