# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3}
# K42inK43subs is the final result
Sing4 := SingularTransformationSemigroup(4));
mtSing4 := MulTab(Sing4);
K42 := SemigroupIdealByGenerators(Sing4,
               [Transformation([1,2,2,2])]);
SetName(K42,"K42ideal");
mt := MulTab(K42,SymmetricGroup(IsPermGroup,4));

L := List(SubSgpsBy1Extensions(mt),
          x->ReCodeIndicatorSet(x,mt,mtSing4));

output := OutputTextFile("K42inK43subs", false);
for r in L do
  AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
od;
CloseStream(output);
