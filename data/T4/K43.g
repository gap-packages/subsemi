# calculating all subsemigroups of the K_{4,3} within T4
Read("sgps.g");

mtT4 := MulTab(T4,S4);
mtK43 := MulTab(K43,S4);

reps := AsList(SubSgpsByMinExtensions(mtK43));

output := OutputTextFile("K43_T4.reps", false);
for r in List(reps,
        x->ReCodeIndicatorSet(x,mtK43,mtT4)) do
  AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
od;
CloseStream(output);
