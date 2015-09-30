# acting on a set of permutation by conjugating elementwise
OnSetOfPermsByConj := function(P, g)
  return Set(P, x->x^g);
end;

# the normalizer of a set of permutations in G
SymmGroupOfSetOfPerms := function(S,G)
  return Stabilizer(G, Set(S), OnSetOfPermsByConj);
end;

#just for checking sanity
SymmGroupOfSetOfPermsBF := function(S,G)
  return Group(Filtered(G, g-> Set(S) =  OnSetOfPermsByConj(Set(S),g)));
end;

#creating a set with the given symmetry group
SymmSet := function(perms, G)
  return Union(List(perms, x->ConjugacyClassOfTransformation(x,G)));
end;
