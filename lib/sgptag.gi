################################################################################
##
## SubSemi
##
## For a semigroup, constructing a tag (string) containing numerical values
## describing its structure.
##
## Copyright (C) 2015  Attila Egri-Nagy
##

################################################################################
### TAGGING ####################################################################
################################################################################
# numbers of fixed length padded with zeros in the front
PaddedNumString := function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end;

# TODO remove the next two functions once it is in digraphs properly
# doing transitive&reflexive reduction here until digraphs stabilizes
ReflexiveReduction := function(rel)
  return List([1..Length(rel)], x -> Filtered(rel[x], y -> not x = y));
end;

# TODO is this correct?
TransitiveReduction := function(rel)
  return List([1..Length(rel)], x -> Difference(rel[x], Union(rel{rel[x]})));
end;

NrEdgesInHasseDiagramOfDClasses := function(sgp)
  return Sum(List(TransitiveReduction(
                 ReflexiveReduction(PartialOrderOfDClasses(sgp))),
                 Length));
end;

# semigroup -> string containing green info
# L - number of L-classes
# R - number of R-classes
# D - number of D-classes
# RD - number of regular D-classes
# M - number of maximal D-classes
# E - number of edges in the Hasse-diagram of the partial order of D-classes
# G - size of group of units
GreenTag := function (sgp,ndigits)
  local s;
  if GroupOfUnits(sgp) <> fail then
    s := Concatenation("_G", PaddedNumString(Size(GroupOfUnits(sgp)),ndigits));
  else
    s := "";
  fi;
  return Concatenation("L",PaddedNumString(NrLClasses(sgp),ndigits),
                 "_R",PaddedNumString(NrRClasses(sgp),ndigits),
                 "_D",PaddedNumString(NrDClasses(sgp),ndigits),
                 "_RD",PaddedNumString(NrRegularDClasses(sgp),ndigits),
                 "_M",PaddedNumString(Size(MaximalDClasses(sgp)),ndigits),
                 "_E",PaddedNumString(NrEdgesInHasseDiagramOfDClasses(sgp),
                         ndigits),s);
end;

# tagging semigroup by size and Greens
# sgp - semigroup
# ndigits - the number of digits to be shown for integer values
# important for ordering the entries
# S - size of the semigroup
# I - number of idempotents
# b - band
# c - commutative semigroup
# r - regular semigroup
# i - inverse semigroup
# m - monoid
# n - 3-nilpotent semigroup
InstallGlobalFunction(SgpTag,
function(sgp,ndigits)
  local tag;
  tag := Concatenation("S",PaddedNumString(Size(sgp),ndigits),
                 "_",GreenTag(sgp,ndigits),
                 "_I",PaddedNumString(NrIdempotents(sgp),ndigits),
                 "_");
  if IsBand(sgp) then Append(tag,"b");fi;
  if IsCommutativeSemigroup(sgp) then Append(tag,"c");fi;
  if IsRegularSemigroup(sgp) then Append(tag,"r");fi;
  if IsInverseSemigroup(sgp) then Append(tag,"i");fi;
  if IsMonoid(sgp) or IsMonoidAsSemigroup(sgp) then Append(tag,"m");fi;
  if Is3Nilpotent(sgp) then Append(tag,"n");fi;
  if tag[Size(tag)] = '_' then Remove(tag); fi;
  return tag;
end);
