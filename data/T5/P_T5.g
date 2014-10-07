# calculating P

mtT5 := MulTab(T5,S5);

I := SemigroupIdealByGenerators(T5, [Transformation([1,2,3,4,4])]); #K54

uts := UpperTorsos(I,S5);

#remove emptyset
Remove(uts, Position(uts, EmptySet(mtT5)));

#remove trivial group
id := BlistList(Indices(mtT5), [Position(SortedElements(mtT5),IdentityTransformation)]);
Remove(uts, Position(uts, id));

SaveIndicatorSets(SubSgpsByUpperTorsos(I,S5,uts),"P_T5.reps");
