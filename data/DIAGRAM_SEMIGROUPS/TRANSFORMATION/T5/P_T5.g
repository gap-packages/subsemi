# calculating P

mtT5 := MulTab(T5,S5);
Display("multiplication table calculated");

I := SemigroupIdealByGenerators(T5, [Transformation([1,2,3,4,4])]); #K54
Display("singular part as an ideal constructed");

uts := UpperTorsos(I,S5);
Display("upper torsos calculated");

#remove emptyset
Remove(uts, Position(uts, EmptySet(mtT5)));

#remove trivial group
id := BlistList(Indices(mtT5), [Position(Elts(mtT5),IdentityTransformation)]);
Remove(uts, Position(uts, id));
Display("and filtered");

SaveIndicatorSets(SubSgpsByUpperTorsos(I,S5,uts),"P_T5.reps");
