S6 := SymmetricGroup(IsPermGroup, 6);
mt := MulTab(S6,S6);
r6 := IGS(mt);

#igss
SaveIndicatorFunctions(Set(r6.igss, x->IndicatorFunction(x,SortedElements(mt))), "S6.igss");

S7 := SymmetricGroup(IsPermGroup, 7);
mt7 := MulTab(S7,S7);
SaveIndicatorFunctions(Set(r6.igss, x->IndicatorFunction(x,SortedElements(mt7))), "S6inS7.igss");
