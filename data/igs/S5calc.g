S5 := SymmetricGroup(IsPermGroup, 5);
mt := MulTab(S5,S5);
r5 := IGS(mt);

#igss
SaveIndicatorFunctions(Set(r5.igss, x->IndicatorFunction(x,SortedElements(mt))), "S5.igss");
