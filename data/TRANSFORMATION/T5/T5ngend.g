mtT5 := MulTab(FullTransformationSemigroup(5),
               SymmetricGroup(IsPermGroup, 5));

SetOriginalName(mtT5, "T5_S5");

n := 3;

l := SubSgpsByMinimalGenSets(mtT5,n);

for i in [1..n] do
  SaveIndicatorFunctions(l[i], Concatenation(OriginalName(mtT5),
          "_", String(i), ".reps"));
od;
