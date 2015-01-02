################################################################################
##
## SubSemi
##
## Extra functions for binary relations.
##
## Copyright (C) 2013-2014  Attila Egri-Nagy
##
InstallImmediateMethod(IsBinaryRelationSemigroup,IsSemigroup and HasGeneratorsOfSemigroup,0,
function(S) return IsBinaryRelationOnPointsRep(
                           Representative(GeneratorsOfSemigroup(S)));end);

InstallMethod(GroupOfUnits, "for a semigroup of binary relations",
[IsBinaryRelationSemigroup],
function(S)
  local units, U, id;

  if MultiplicativeNeutralElement(S)=fail then
    return fail;
  fi;
  id := MultiplicativeNeutralElement(S);
  units := Filtered(S, x->ForAny(S, y-> y*x=id and x*y=id));
  U := Semigroup(units);
  SetIsGroupAsSemigroup(U,true);
  return U;
end);


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
        [IsBinaryRelation, IsPerm], ConjugateBinaryRelation);
