S5 := SymmetricGroup(IsPermGroup, 5);
mt := MulTab(S5,S5);
r5 := IS(mt,ISCanCons);

SaveIndicatorFunctions(r5, "S5.iss");
iss := List(r5, x->SetByIndicatorFunction(x,SortedElements(mt)));

igs := Filtered(iss, x-> (not IsEmpty(x)) and Size(Group(x))=Factorial(5));

SaveIndicatorFunctions(Set(igs, x->IndicatorFunction(x,SortedElements(mt))), "S5.igss");

