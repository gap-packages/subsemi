# GAP 4.7 code for calculating the number of distinct 2-generating sets of
# symmetric groups.
# This code is written for readability, and to minimize package dependencies.
# (C) 2015 Attila Egri-Nagy

# decides whether the given generating sets generate the symmetric group of
# degree n or not
IsSn := function(gens,n)
  return Size(Group(gens))=Factorial(n);
end;

# returns all degree n permutations (i.e. elements of the symmetric group)
AllPermsDegn := function(n)
  return AsList(SymmetricGroup(IsPermGroup,n));
end;

# first 5 entries of A001691 calculated in an inefficient manner
# taking all sets of cardinality 2 and check
gensets := List([1..7],
                x->Filtered(Combinations(AllPermsDegn(x),2),
                        y->IsSn(y,x)));
Display(List(gensets,Size));

# returns the conjugacy class representative of P under G
# calculates the conjugacy class of P and returns the minimum element
# P - set of permutations
# G - permutation group
ConjClRep := function(P, G)
  return Minimum(Set(AsList(G), x-> Set(P, y->y^x)));
end;

Display(List([1..7],
        x->Size(Set(gensets[x],
                y->ConjClRep(y,SymmetricGroup(IsPermGroup,x))))));
