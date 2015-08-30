# acting on a set of permutation by conjugating elementwise
OnSetOfPermsByConj := function(P, g)
  return Set(P, x->x^g);
end;

# the normalizer of a set of permutations in G
SymmGroupOfSetOfPerms := function(S,G)
  return Stabilizer(G, Set(S), OnSetOfPermsByConj);
end;
                      
