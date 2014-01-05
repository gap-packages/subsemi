gap> START_TEST("SubSemi package: indicatorset.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> MT := MulTab(FullTransformationSemigroup(2));;
gap> blists := List(Combinations(Indices(MT)), l -> BlistList(Indices(MT),l));;
gap> ForAll(blists, b -> b = IndicatorSetOfElements(ElementsByIndicatorSet(b,SortedElements(MT)),SortedElements(MT)));
true
gap> MT := MulTab(Semigroup([Transformation([3,2,1,1]),Transformation([4,1,1,1])]));;
gap> blists := List(Combinations(Indices(MT)), l -> BlistList(Indices(MT),l));;
gap> ForAll(blists, b -> b = IndicatorSetOfElements(ElementsByIndicatorSet(b,SortedElements(MT)),SortedElements(MT)));
true

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: indicatorset.tst", 100);