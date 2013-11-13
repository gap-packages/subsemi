
mtSing4 := MulTab(SingularTransformationSemigroup(4),S4);

#K42 := IndicatorSetOfElements(AsList(SemigroupIdealByGenerators(SingularTransformationSemigroup(4),[Transformation([1,1,2,2])])),SortedElements(mtSing4));
K41 := IndicatorSetOfElements(AsList(SemigroupIdealByGenerators(SingularTransformationSemigroup(4),[Transformation([1,2,2,2])])),SortedElements(mtSing4));

K43_42subs := LoadIndicatorSets("K43-K42torsos");
Display(FormattedMemoryString(MemoryUsage(K43_42subs)));


#Writer(Unique(List(K43_42subs,x->SgpInMulTab(x,mtSing4))),"K43-K42torsosG");
