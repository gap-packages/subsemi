# returns the conjugate of a transformation collection by a permutation
# if it is a semigroup, then only the generators are conjugated
# T - a collection of transformationse
# perm - a permutation
ConjugateTransformationCollection := function(T, perm)
  if IsSemigroup(T) then
    return Semigroup(List(GeneratorsOfSemigroup(T), s -> s^perm));
  else
    return List(T, t -> t^perm);
  fi;
end;

# 
ConjugacyClassOfTransformationCollection := function(C,G)
local g, conjugate, conjclass;  
  conjclass := [];
  for g in G do
    conjugate := ConjugateTransformationCollection(C,g);
    #convert it to sorted list to make it comparable
    conjugate := AsSortedList(conjugate);
    AddSet(conjclass, conjugate);
  od;
  return conjclass;
end;
