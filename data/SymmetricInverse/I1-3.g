for i in [1..3] do
  S := SymmetricInverseMonoid(i);
  G := SymmetricGroup(IsPermGroup,i);
  SaveIndicatorSets(AsList(SubSgpsByMinExtensions(MulTab(S,G))),
          Concatenation("I",String(i),".reps"));
od;
