T3 := FullTransformationSemigroup(3);
K31:= SemigroupIdealByGenerators(T3, [Transformation([1,1,1])]); 
K32 := SingularTransformationSemigroup(3);
S3 := SymmetricGroup(3);

mt := MulTab(T3);
T3allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

mt := MulTab(T3,S3);
T3conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

#getting conjugacy classes from all subs
T3conjclasses2 := AsSortedList(Unique(List(T3allsubs,x->ConjugacyClassRep(x,mt))));

mtK32 := MulTab(K32);
K32allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

mtK32 := MulTab(K32,S3);
K32conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

#getting conjugacy classes from all subs
K32conjclasses2 := AsSortedList(Unique(List(K32allsubs,x->ConjugacyClassRep(x,mt))));


#doing the ideal thingy
