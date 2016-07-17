Display("Number of embeddings of full transformation semigroups:");

for i in [1,2,3,4,5] do
  for j in [1..i] do
    mtT := MulTab(FullTransformationSemigroup(i), SymmetricGroup(IsPermGroup,i));
    res := MulTabEmbeddingsUpToConjugation(MulTab(FullTransformationSemigroup(j)), mtT);
    Print("T",j,"->T",i," ", Size(res),"\n");
  od;
od;
