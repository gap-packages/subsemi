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

ConjugacyClassOfTransformation := function(t,G)
  return DuplicateFreeList(List(G, g -> t^g));
end;
#example usage: you have all subsemigroups of T_n, but no idea about conjugacy
#classes, this function finds those classes
CalculateConjugacyClassesOfTransformations := function(T,G)
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
end;

#getting conjugacy symmetries that act on the magma's elements' indices in the
#sorted list
NonTrivialSymmetriesOfElementIndices := function(M,G)
  local syms;
  syms := List(G, g -> AsPermutation(TransformationOp(g,M,\^)));
  Remove(syms, Position(syms,()));    #remove the identity to save time later
  return syms;
end;

#getting conjugacy symmetries that act on the magma's elements' indices in the
#sorted list
#through a homomorphism
NonTrivialSymmetriesOfElementIndicesThroughHom := function(M,G,hom)
  local syms;
  syms := List(G, g ->
               AsPermutation(
                       TransformationOp(g,M,
                               function(p,t)
                                 return Image(hom,PreImagesRepresentative(hom,p)^t);
                               end)));
  Remove(syms, Position(syms,()));    #remove the identity to save time later
  return syms;
end;
