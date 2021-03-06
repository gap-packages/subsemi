gap> START_TEST("SubSemi package: closures.tst");
gap> LoadPackage("SubSemi", false);;
gap> TestGenerateSg := function(mt)
>  local gens,blT,T;
>  gens := DuplicateFreeList(List([1..Random([1..7])], x->Random(Indices(mt))));
>  blT := SgpInMulTab(gens,mt);
>  T := Semigroup(SetByIndicatorFunction(BlistList(Indices(mt),gens),mt));
>  return blT = IndicatorFunction(AsList(T), mt);  
> end;;
gap> mt := MulTab(FullTransformationSemigroup(4));;
gap> ForAll([1..10], i-> TestGenerateSg(mt));
true
gap> TestDifferentTypeGenerateSg := function(mt)
>  local gens,blT,T;
>  gens := DuplicateFreeList(List([1..Random([1..7])], x->Random(Indices(mt))));
>  return SgpInMulTab(gens,mt) = SgpInMulTab(BlistList(Indices(mt),gens),mt);
> end;;
gap> ForAll([1..10], i-> TestDifferentTypeGenerateSg(mt));
true
gap> subs := EnumeratorOfCartesianProduct(List([1..27],x->[false,true]));;
gap> l := List([1..10000],x->Random(subs));;
gap> mt := MulTab(FullTransformationSemigroup(3));;
gap> ForAll(l, x-> SgpInMulTab(x,mt) = SgpInMulTabFunc(ClosureByLocalTables)( x, mt));
true
gap> l := List([1..10000],x->Random(subs));;
gap> ForAll(l, x-> SgpInMulTab(x,mt) = SgpInMulTabFunc(ClosureByGlobalTables)(x ,mt));
true

#
gap> STOP_TEST( "SubSemi package: closures.tst", 10000);
