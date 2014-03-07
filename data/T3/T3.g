T3 := FullTransformationSemigroup(3);
Sing3 := SingularTransformationSemigroup(3);
S3 := SymmetricGroup(3);

mt := MulTab(T3);
T3allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

mt := MulTab(T3,S3);
T3conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

#getting conjugacy classes from all subs
T3conjclasses2 := AsSortedList(Unique(List(T3allsubs,x->ConjugacyClassRep(x,mt))));

if T3conjclasses2 <> T3conjclasses then Error("T3 onjugacy class calculation error!");fi;

mtSing3 := MulTab(Sing3);
Sing3allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mtSing3)));

mtSing3 := MulTab(Sing3,S3);
Sing3conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mtSing3)));

#getting conjugacy classes from all subs
Sing3conjclasses2 := AsSortedList(Unique(List(Sing3allsubs,x->ConjugacyClassRep(x,mtSing3))));

if Sing3conjclasses2 <> Sing3conjclasses then Error("Sing3 conjugacy class calculation error!");fi;

#doing the same by ideal
K33 := SemigroupIdealByGenerators(T3, [Transformation([1,2,3])]); 
K32 := SemigroupIdealByGenerators(T3, [Transformation([1,1,2])]); 
K31 := SemigroupIdealByGenerators(T3, [Transformation([1,1,1])]); 

if T3conjclasses <> AsSortedList(AsList(SubSgpsByIdeals(K31,S3))) then
  Error("K31 calculation error!");
fi;

if T3conjclasses <> AsSortedList(AsList(SubSgpsByIdeals(K32,S3))) then
  Error("K32 calculation error!");
fi;

if T3conjclasses <> AsSortedList(AsList(SubSgpsByIdeals(K33,S3))) then
  Error("K33 calculation error!");
fi;
