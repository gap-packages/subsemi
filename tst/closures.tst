gap> START_TEST("SubSemi package: closures.tst");
gap> LoadPackage("SubSemi", false);;
gap> TestGenerateSg := function(mt)
>  local gens,T1,T2;
>  gens := DuplicateFreeList(List([1..Random([1..7])], x->Random(Indices(mt))));
>  T1 := Set(Elts(mt){SgpInMulTab(gens,mt)});
>  T2 := Semigroup(SetByIndicatorFunction(gens,mt));
>  return  T1 = AsSet(T2);  
> end;;
gap> mt := MulTab(FullTransformationSemigroup(4));;
gap> ForAll([1..10], i-> TestGenerateSg(mt));
true
gap> f := x -> DuplicateFreeList(List([1..Random([1..7])], y->Random(Indices(mt))));;
gap> l := List([1..100], f);;
gap> ForAll(l, x-> SgpInMulTab(x,mt) = SgpInMulTab(x,mt,ClosureByIncrementsAndLocalTables));
true
gap> ForAll(l, x-> SgpInMulTab(x,mt) = SgpInMulTab(x,mt,ClosureByComplement));
true

#
gap> STOP_TEST( "SubSemi package: closures.tst", 10000);
