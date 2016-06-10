mtT5 := MulTab(T5);
Display(FormattedMemoryString(MemoryUsage(mtT5)));
mtT6 := MulTab(T6);
Display(FormattedMemoryString(MemoryUsage(mtT6)));

SetInfoLevel(SubSemiInfoClass,9);

result := MulTabEmbeddings(mtT5,mtT6);

mtT6 := 0;
mtT5 := 0;
SaveWorkSpace("T5intoT6result.ws");
