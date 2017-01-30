################################################################################
##
## SubSemi
##
## For a semigroup, constructing a tag (string) containing labeled numerical
## values describing its structure.
##
## Copyright (C) 2015-2017  Attila Egri-Nagy
##

# to get a fixed number of digits, padding with leading zeroes
InstallGlobalFunction(PaddedNumString,
function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end);

# TODO remove the next two functions once it is in digraphs properly
# doing transitive&reflexive reduction here until digraphs stabilizes
ReflexiveReduction := function(rel)
  return List([1..Length(rel)],
              x -> Filtered(rel[x], y -> not x = y));
end;

# BROKEN!!
TransitiveReduction := function(rel)
  local transclosure;
  transclosure := function(x, rel)
    return Union(Set(rel[x]), Set(rel[x], y->transclosure(y,rel)));
  end;
  return List([1..Length(rel)],
              x -> Difference(transclosure(x,rel),
                              Union(Concatenation((Set(rel[x], y-> transclosure(y,rel)))))));
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
    s := PaddedNumString(Size(GroupOfUnits(sgp)),ndigits);
  else
    s := PaddedNumString(0,ndigits);
  fi;
  return Concatenation("L",PaddedNumString(NrLClasses(sgp),ndigits),
                 "_R",PaddedNumString(NrRClasses(sgp),ndigits),
                 "_D",PaddedNumString(NrDClasses(sgp),ndigits),
                 "_RD",PaddedNumString(NrRegularDClasses(sgp),ndigits),
                 "_M",PaddedNumString(Size(MaximalDClasses(sgp)),ndigits),
                 "_E",PaddedNumString(NrEdgesInHasseDiagramOfDClasses(sgp),
                         ndigits),
                 "_G",s);
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
  tag := JoinStringsWithSeparator(
                 [Concatenation("S",PaddedNumString(Size(sgp),ndigits)),
                  Concatenation("I",PaddedNumString(NrIdempotents(sgp),ndigits)),
                  GreenTag(sgp,ndigits),],
                 "_");
  Append(tag,"_");
  if IsBand(sgp) then Append(tag,"b");fi;
  if IsCommutativeSemigroup(sgp) then Append(tag,"c");fi;
  if IsRegularSemigroup(sgp) then Append(tag,"r");fi;
  if IsInverseSemigroup(sgp) then Append(tag,"i");fi;
  if IsMonoid(sgp) or IsMonoidAsSemigroup(sgp) then Append(tag,"m");fi;
  if Is3Nilpotent(sgp) then Append(tag,"n");fi;
  if tag[Size(tag)] = '_' then Remove(tag); fi;
  return tag;
end);
