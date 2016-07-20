T5 := FullTransformationSemigroup(5);
T6 := FullTransformationSemigroup(6);
S6 := SymmetricGroup(IsPermGroup,6);
mtT5 := MulTab(T5);
Display(FormattedMemoryString(MemoryUsage(mtT5)));
mtT6 := MulTab(T6);
Display(FormattedMemoryString(MemoryUsage(mtT6,S6)));

result := MulTabEmbeddingsUpToConjugation(mtT5,mtT6);

Display(Size(result));
mtT6 := 0;
mtT5 := 0;
SaveWorkSpace("T5intoT6result.ws");
