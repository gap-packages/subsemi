S6 := SymmetricGroup(IsPermGroup, 6);
mt := MulTab(S6,S6);
r6 := IS(mt,ISCanCons);

SaveIndicatorFunctions(r6, "S6.iss");
iss6 := List(r6, x->SetByIndicatorFunction(x,SortedElements(mt)));

igs6 := Filtered(iss6, x->(not IsEmpty(x)) and Size(Group(x))=Factorial(6));
SaveIndicatorFunctions(Set(igs6, x->IndicatorFunction(x,SortedElements(mt))), "S6.igss");

S7 := SymmetricGroup(IsPermGroup, 7);
mt7 := MulTab(S7,S7);
SaveIndicatorFunctions(Set(igs6, x->IndicatorFunction(x,SortedElements(mt7))), "S6inS7.igss");
