#GAP 4.7 www.gap-system.org
#brute-force  enumeration of independent sets in the symmetric group
#inefficient (~4GB RAM needed, n=4 can take hours),
#but short, readable, self-contained
#higher terms can be calculated by the SubSemi package
#https://github.com/egri-nagy/subsemi
IsIndependentSet := function(A)
  return IsDuplicateFreeList(A) and
         (Size(A)<2 or
          ForAll(A,x-> not (x in Group(Difference(A,[x])))));
end;

Rep := function(A, Sn)
  return Minimum(Set(Sn, g->Set(A, x->x^g)));
end;

for n in [1..4] do
  Sn := SymmetricGroup(IsPermGroup,n);
  allsubsets := Combinations(AsList(Sn));
  iss := Filtered(allsubsets, IsIndependentSet);
  Display(Size(Set(iss, x->Rep(x,Sn))));
od;
