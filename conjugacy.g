# returns the conjugate of a semigroup by a permutation
# S - transformation semigroup
# perm - a permutation
ConjugateTransformationSemigroup := function(S,perm)
  return Semigroup(List(GeneratorsOfSemigroup(S), s -> s^perm));
end;

# returns the conjugate of a transformation collection by a permutation
# T - a collection of transformationse
# perm - a permutation
ConjugateTransformationCollection := function(T, perm)
  return List(T, t -> t^perm);
end;
