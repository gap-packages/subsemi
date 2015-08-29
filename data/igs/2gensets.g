IsSn := function(gens, n) return Size(Group(gens))=Factorial(n);end;

AllPerms := function(n) return AsList(SymmetricGroup(IsPermGroup,n));end;
  
SEQ_2gens := List([1..6],
                  x->Size(Filtered(Combinations(AllPerms(x),2),
                          y->IsSn(y,x))));
