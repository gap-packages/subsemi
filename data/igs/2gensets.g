IsSn := function(gens, n) return Size(Group(gens))=Factorial(n);end;

AllPerms := function(n) return AsList(SymmetricGroup(IsPermGroup,n));end;

# A001691 calculated in an inefficient manner
SEQ_2gens := List([1..5],
                  x->Size(Filtered(Combinations(AllPerms(x),2),
                          y->IsSn(y,x))));

# returns the conjugacy class representative of P under G
# claculates the conjugacy class of P and returns the minimum element
# P - set of permutations
# G - permutation group
ConjClRep := function(P, G)
  return Minimum(Set(AsList(G), x-> Set(P, y->y^x)));
end;

all := List([1..6],
            x->Filtered(Combinations(AllPerms(x),2),
                    y->IsSn(y,x)));

SEQ_2gensr := List([1..6],
                   x->Set(all[x], y->ConjClRep(y,SymmetricGroup(IsPermGroup,x))));

