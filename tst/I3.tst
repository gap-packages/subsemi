gap> START_TEST("SubSemi package: I3.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> I3 := SymmetricInverseSemigroup(3);;
gap> S3 := SymmetricGroup(3);;
gap> mt := MulTab(I3,S3);;
gap> I3conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));;
gap> K33 := SemigroupIdealByGenerators(I3, [PartialPerm([1,2,3])]);;
gap> K32 := SemigroupIdealByGenerators(I3, [PartialPerm([1,2,0])]);;
gap> K31 := SemigroupIdealByGenerators(I3, [PartialPerm([1,0,0])]);;
gap> K30 := SemigroupIdealByGenerators(I3, [PartialPerm([0,0,0])]);;
gap> I3conjclasses =  AsSortedList(AsList(SubSgpsByIdeals(K33,S3)));
true
gap> I3conjclasses = AsSortedList(AsList(SubSgpsByIdeals(K32,S3)));
true
gap> I3conjclasses = AsSortedList(AsList(SubSgpsByIdeals(K31,S3)));
true
gap> I3conjclasses = AsSortedList(Unique(AsList(SubSgpsByIdeals(K30,S3))));
true

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: I3.tst", 100000);