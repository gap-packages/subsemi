gap> START_TEST("SubSemi package: indicatorset.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> mt := MulTab(FullTransformationSemigroup(2));;
gap> blists := List(Combinations(mt.rn), l -> BlistList(mt.rn,l));;
gap> ForAll(blists, b -> b = IndicatorSetOfElements(ElementsByIndicatorSet(b,mt),mt));
true

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: indicatorset.tst", 10000);