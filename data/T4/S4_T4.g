# calculating all subgroups of S4 but in T4
Read("sgps.g");

mtS4 := MulTab(S4,S4);
mtT4 := MulTab(T4);

reps := AsList(SubSgpsByMinExtensions(mtS4));

subgps := List(reps, x->ElementsByInidicatorSet(x,mtS4));

#the empty set is not a group
Remove(subgps, Position(subgps, []));



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
