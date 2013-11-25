gap> START_TEST("SubSemi package: 1extensions.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> TestGenerateSg := function(mt)
>  local gens,blT,T;
>  gens := DuplicateFreeList(List([1..Random([1..7])], x->Random(Indices(mt))));
>  blT := SgpInMulTab(gens,mt);
>  T := Semigroup(ElementsByIndicatorSet(BlistList(Indices(mt),gens),SortedElements(mt)));
>  return blT = IndicatorSetOfElements(T, SortedElements(mt));  
> end;;
gap> mt := MulTab(FullTransformationSemigroup(4));;
gap> ForAll([1..10], i-> TestGenerateSg(mt));
true

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: 1extensions.tst", 10000);