Read("count.g");

for i in [1,2,3,4,6] do
  for j in [1..i] do
    mtT := MulTab(FullTransformationSemigroup(i), SymmetricGroup(IsPermGroup,i));
    res := MulTabEmbeddingsUpToConjugation(MulTab(FullTransformationSemigroup(j)), mtT);
    Print("T",j,"->T",i," ", Size(res),"\n");
  od;
od;
