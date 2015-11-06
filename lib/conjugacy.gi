################################################################################
##
## SubSemi
##
## Symmetries of transformations
##
## Copyright (C) 2013  Attila Egri-Nagy
##

################################################################################
# CONJUGATE CALCULATING FUNCTIONS ##############################################
################################################################################

# returns the conjugate of a transformation collection by a permutation
# T - a collection of transformations
# perm - a permutation
InstallGlobalFunction(ConjugateTransformationCollection,
function(T, perm)
    return Set(T, t -> t^perm);
end);

# for semigroups conjugate the generators only
InstallGlobalFunction(ConjugateTransformationSemigroup,
function(T, perm)
  return Semigroup(Set(GeneratorsOfSemigroup(T), s -> s^perm));
end);

################################################################################
# CONJUGACY CLASS FUNCTIONS ####################################################
################################################################################

InstallGlobalFunction(ConjugacyClassOfTransformation,
function(t,G)
  return Set(G, g -> t^g);
end);

# returns the distinct conjugates by the elements of G of the collection
# this always return a list of transformation collections, since isomorphism
# testing for semigroups is not yet available TODO
# T - a collection of transformations
# G - permutations, most likely a group
InstallGlobalFunction(ConjugacyClassOfTransformationCollection,
function(T,G)
local conjclass;
  conjclass := [];
  Perform(G, function(g)
    AddSet(conjclass,AsSortedList(ConjugateTransformationCollection(T,g)));end);
  return conjclass;
end);

#example usage: you have all subsemigroups of T_n, but no idea about conjugacy
#classes, this function finds those classes
InstallGlobalFunction(CalculateConjugacyClassesOfTransformations,
function(T,G)
local log, #every conjugates we found so far
      classes, #the result will be a list of conjugacy classes
      cl,
      t;
  log := [];classes := [];
  for t in T do
    if not (t in log) then
      cl := ConjugacyClassOfTransformation(t,G);
      Add(classes,cl);
      Perform(cl, function(x) AddSet(log,x);end);
    fi;
  od;
  return classes;
end);

## generating conjugacy classes of the given seed elements
## uniqueness enforced
# seeds - elements of which we calculate the conjugacy classes
# G - the group of symmetries (of the seeds and its enveloping set)
# conjclassfunc - conjugacy function to compute the conjugacy class of a seed
GenerateConjugacyClasses := function(seeds, G, conjclassfunc)
  return Set(seeds,x->AsSortedList(conjclassfunc(x,G)));  
end;
