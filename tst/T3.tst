gap> START_TEST("SubSemi package: T3.tst");
gap> LoadPackage("SubSemi", false);;
gap> T3 := FullTransformationSemigroup(3);;
gap> S3 := SymmetricGroup(3);;
gap> mt := MulTab(T3);;
gap> T3allsubs := AsSet(SubSgpsByMinExtensions(mt));;
gap> mt := MulTab(T3,S3);;
gap> T3conjclasses := AsSet(SubSgpsByMinExtensions(mt));;
gap> T3conjclasses2 := Set(T3allsubs,x->BlistConjClassRep(x,mt));;
gap> T3conjclasses2 =  T3conjclasses;
true
gap> K33 := SemigroupIdealByGenerators(T3, [Transformation([1,2,3])]);;
gap> K32 := SemigroupIdealByGenerators(T3, [Transformation([1,1,2])]);; 
gap> K31 := SemigroupIdealByGenerators(T3, [Transformation([1,1,1])]);; 
gap> T3conjclasses = AsSet(SubSgpsByIdeal(K31,S3));
true
gap> T3conjclasses = AsSet(SubSgpsByIdeal(K32,S3));
true
gap> T3conjclasses = AsSet(SubSgpsByIdeal(K33,S3));
true
gap> K33 := SemigroupIdealByGenerators(T3, [Transformation([1,2,3])]);;
gap> K32 := SemigroupIdealByGenerators(K33, [Transformation([1,1,2])]);; 
gap> K31 := SemigroupIdealByGenerators(K32, [Transformation([1,1,1])]);;
gap> T3conjclasses = AsSet(SubSgpsByIdealChain([K31,K32,K33], S3));
true
gap> T3ccsbyIS := IS(mt,ISCanCons);;
gap> Remove(T3ccsbyIS, Position(T3ccsbyIS, EmptySet(mt)));;
gap> Set(T3ccsbyIS, x-> BlistConjClassRep(SgpInMulTab(x,mt),mt)) = T3conjclasses;
true

#
gap> STOP_TEST( "SubSemi package: T3.tst", 100000);
