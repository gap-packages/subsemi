T3 := FullTransformationSemigroup(3);
T4 := FullTransformationSemigroup(4);
S4 := SymmetricGroup(4);

mtT4 := MulTab(T4,S4);
mtT3 := MulTab(T3);

#do the first step
r := MultiplicationTableEmbeddingSearch(
             Rows(mtT3),
             Rows(mtT4),
             CandidateLookup(EmbeddingProfiles(Rows(mtT3)), EmbeddingProfiles(Rows(mtT4))),
             false,
             [],
             1);
