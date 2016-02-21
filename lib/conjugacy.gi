################################################################################
##
## SubSemi
##
## Conjugation for multab elements.
##
## Copyright (C) 2013-2016 Attila Egri-Nagy
##

### MINIMAL CONJUGATORS ########################################################
# using the ordering of the elements in the multiplication tables, the conjugacy
# class representative of a set of elements is defined by the minimal element of
# the class by the induced lexicographic order
#
# when looking for the representative, we do not need to conjugate by all
# symmetries, only the ones that produce minimal elements
#
# here we compute attributes of multabs to help to construct the representative

# for element x what is the smallest element conjugate to it?
# multab index -> multab index
InstallMethod(MinimumConjugates,"for a multab", [IsMulTab],
function(mt)
  return List(Indices(mt), x -> Minimum(Set(Symmetries(mt), y -> x^y)));
end);

# what are the symmetries taking an element x to its minimal conjugate?
# multab index -> set of symmetries
InstallMethod(MinimumConjugators,"for multab", [IsMulTab],
function(mt)
  return List(Indices(mt),
              x -> Filtered(Symmetries(mt), y -> x^y=MinimumConjugates(mt)[x]));
end);

# permutations that may give the minimal representative
PossibleRepConjugators:= function(set, mt)
  local min;
  min := Minimum(Set(set, x->MinimumConjugates(mt)[x]));
  return Union(Set(Filtered(set, x-> MinimumConjugates(mt)[x]=min),
                   y->MinimumConjugators(mt)[y]));
end;
MakeReadOnlyGlobal("PossibleRepConjugators");

###
MinimumOfOrbit := function(point, operators, actionfunc)
  local  min, new, op;
  min := point;
  for op in operators do
    new := actionfunc(point,op);
    if new < min then
      min := new;
    fi;
  od;
  return min;
end;
MakeReadOnlyGlobal("MinimumOfOrbit");

MinimumOfOrbitOperator := function(point, operators, actionfunc)
  local  min,new,i,conjugator;
  conjugator := operators[1];
  min := point;
  for i in [1..Length(operators)] do
    new := actionfunc(point,operators[i]);
    if new < min then
      min := new;
      conjugator := operators[i];
    fi;
  od;
  return conjugator;
end;
MakeReadOnlyGlobal("MinimumOfOrbitOperator");

### FOR SETS OF INTEGERS #######################################################
# conjugacy class rep defined for list of integers
# TODO the next two functions can be merged
SetConjugacyClassRep := function(set,mt)
  return MinimumOfOrbit(AsSet(set), PossibleRepConjugators(set,mt), OnSets);
end;

# conjugacy class rep defined for set of integers
SetConjugacyClassConjugator := function(set,mt)
  return MinimumOfOrbitOperator(AsSet(set),
                                PossibleRepConjugators(set,mt),
                                OnSets);
end;

### FOR BLISTS #################################################################
# we convert it to set, and back to blist
InstallGlobalFunction(ConjugacyClassRep,
function(indset,mt)
  local set, rep;
  if SizeBlist(indset) = 0 then return indset; fi;
  set := ListBlist(Indices(mt), indset);
  rep := MinimumOfOrbit(set, PossibleRepConjugators(set,mt), OnSets);
  return BlistList(Indices(mt), rep);
end);
