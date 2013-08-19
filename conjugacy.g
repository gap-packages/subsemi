# returns the conjugate of a transformation collection by a permutation
# if it is a semigroup, then only the generators are conjugated
# T - a collection of transformations
# perm - a permutation
ConjugateTransformationCollection := function(T, perm)
  if IsSemigroup(T) then
    return Semigroup(List(GeneratorsOfSemigroup(T), s -> s^perm));
  else
    return List(T, t -> t^perm);
  fi;
end;

# returns the distinct conjugates by the elements of G of the collection
# this always return a list of transformation collections, since isomorphism
# testing for semigroups is not yet available TODO
# T - a collection of transformations
# G - permutations, most likely a group
ConjugacyClassOfTransformationCollection := function(T,G)
local g, conjugate, conjclass;
  conjclass := [];
  for g in G do
    conjugate := ConjugateTransformationCollection(T,g);
    #convert it to sorted list to make it comparable
    AddSet(conjclass, AsSortedList(conjugate));
  od;
  return conjclass;
end;
