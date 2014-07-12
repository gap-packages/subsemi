# calculating P
Read("sgps.g");

mtT4 := MulTab(T4,S4);

I := SemigroupIdealByGenerators(T4, [Transformation([1,2,3,3])]); #K43

uts := UpperTorsos(I,S4);

#remove emptyset
Remove(uts, Position(uts, EmptySet(mtT4)));

#remove trivial group
id := BlistList(Indices(mtT4), [Position(SortedElements(mtT4),IdentityTransformation)]);
Remove(uts, Position(uts, id));

SaveIndicatorSets(SubSgpsByUpperTorsos(I,S4,uts),"P_T4.reps");
