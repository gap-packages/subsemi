# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3} and T4
Read("sgps.g");

mtT4 := MulTab(T4);
mtK43 := MulTab(K43);
mtK42 := MulTab(K42,S4);

reps := AsList(SubSgpsByMinExtensions(mtK42));

output := OutputTextFile("K42_K43.reps", false);
for r in List(reps,
        x->ReCodeIndicatorSet(x,mtK42,mtK43)) do
  AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
od;
CloseStream(output);

output := OutputTextFile("K42_T4.reps", false);
for r in List(reps,
        x->ReCodeIndicatorSet(x,mtK42,mtT4)) do
  AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
od;
CloseStream(output);
