################################################################################
##
## SubSemi
##
## Conjugation for multab elements.
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

### FOR SETS OF INTEGERS #######################################################
# conjugacy class rep defined for list of integers TODO cleanup
SetConjugacyClassRep := function(set,symmetries)
  local  min, new, g;
  min := AsSet(set);
  for g in symmetries do
    new := OnSets(set,g);
    if new < min then
      min := new;
    fi;
  od;
  return min;
end;

# conjugacy class rep defined for set of integers
SetConjugacyClassConjugator := function(set,symmetries)
  local  min, new,i, conjugator;
  conjugator := symmetries[1];
  min := AsSet(set);
  for i in [1..Length(symmetries)] do
    new := OnSets(set,symmetries[i]);
    if new < min then
      min := new;
      conjugator := symmetries[i];
    fi;
  od;
  return conjugator;
end;

### FOR BLISTS #################################################################
#for each element what is the smallest element in order that is conjugate to it?
InstallMethod(MinimumConjugates,"for a multab", [IsMulTab],
function(mt)
  return List(Indices(mt), x -> Minimum(List(Symmetries(mt), y -> x^y)));
end);

#for minimal conjugates, what are the symmetries taking an element to its min?
InstallMethod(MinimumConjugators,"for multab", [IsMulTab],
function(mt)
  local minimums;
  minimums := MinimumConjugates(mt);
  return List(Indices(mt), x -> Filtered(Symmetries(mt), y -> x^y=minimums[x]));
end);

# permutations that may give the minimal representative
PossibleMinConjugators:= function(set, mt)
  local min, mins, conjgrs;
  mins := MinimumConjugates(mt);
  conjgrs := MinimumConjugators(mt);
  min := Minimum(Set(set, x->mins[x]));
  return Union(Set(Filtered(set, x-> mins[x]=min), y->conjgrs[y]));
end;
MakeReadOnlyGlobal("PossibleMinConjugators");

#the minimal one is the representative
InstallGlobalFunction(ConjugacyClassRep,
function(indset,mt)
  local set, rep;
  set := ListBlist(Indices(mt), indset);
  rep := SetConjugacyClassRep(set, PossibleMinConjugators(set,mt));
  return BlistList(Indices(mt), rep);
end);
