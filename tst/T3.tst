gap> START_TEST("SubSemi package: T3.tst");
gap> LoadPackage("SubSemi", false);;
gap> T3 := FullTransformationSemigroup(3);;
gap> S3 := SymmetricGroup(3);;
gap> mt := MulTab(T3);;
gap> T3allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));;
gap> mt := MulTab(T3,S3);;
gap> T3conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));;
gap> T3conjclasses2 := AsSortedList(Unique(List(T3allsubs,x->ConjugacyClassRep(x,mt))));;
gap> T3conjclasses2 =  T3conjclasses;
true
gap> K33 := SemigroupIdealByGenerators(T3, [Transformation([1,2,3])]);;
gap> K32 := SemigroupIdealByGenerators(T3, [Transformation([1,1,2])]);; 
gap> K31 := SemigroupIdealByGenerators(T3, [Transformation([1,1,1])]);; 
gap> T3conjclasses =  AsSortedList(AsList(SubSgpsByIdeals(K31,S3)));
true
gap> T3conjclasses = AsSortedList(AsList(SubSgpsByIdeals(K32,S3)));
true
gap> T3conjclasses = AsSortedList(AsList(SubSgpsByIdeals(K33,S3)));
true

#
gap> STOP_TEST( "SubSemi package: T3.tst", 100000);