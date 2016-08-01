T5 := FullTransformationSemigroup(5);
T6 := FullTransformationSemigroup(6);
S6 := SymmetricGroup(IsPermGroup,6);
mtT5 := MulTab(T5);
Display(FormattedMemoryString(MemoryUsage(mtT5)));
mtT6 := MulTab(T6,S6);
Display(FormattedMemoryString(MemoryUsage(mtT6)));
SaveWorkspace("T5intoT6multabs.ws");

ef := EmbeddingSearchFunc(mtT5,mtT6);

#result := MulTabEmbeddingsUpToConjugation(mtT5,mtT6);
SetInfoLevel(SubSemiInfoClass,2);
psols := PartialEmbeddingsUpToOrderedConjugacy(ef, SymmetryGroup(mtT6));

Display(Size(psols));
Print(psols);

mtT6 := 0;
mtT5 := 0;
SaveWorkspace("T5intoT6result.ws");
