gap> START_TEST("SubSemi package: J4.tst");
gap> LoadPackage("SubSemi", false);;
gap> J4 := JonesMonoid(4);;
gap> G := Group((1,4)(2,3));;
gap> mt := MulTab(J4,G);;
gap> J4subs := AsSet(SubSgpsByMinExtensions(mt));;
gap> Size(J4subs);
231
gap> dcls := DClasses(J4);;
gap> I1C := SemigroupIdealByGenerators(J4, [Representative(dcls[2])]);;
gap> I2C := SemigroupIdealByGenerators(J4, [Representative(dcls[3])]);;
gap> J4subs = AsSet(SubSgpsByIdeal(I1C,G));
true
gap> J4subs = AsSet(SubSgpsByIdeal(I2C,G));
true
gap> I1C := SemigroupIdealByGenerators(J4, [Representative(dcls[2])]);;
gap> I2C := SemigroupIdealByGenerators(I1C, [Representative(dcls[3])]);;
gap> J4subs = AsSet(SubSgpsByIdealChain([I2C,I1C], G));
true
gap> J4byIS := IS(mt,ISCanCons);;
gap> Remove(J4byIS, Position(J4byIS, EmptySet(mt)));;
gap> Set(J4byIS, x-> BlistConjClassRep(SgpInMulTab(x,mt),mt)) = J4subs;
true

#
gap> STOP_TEST( "SubSemi package: J4.tst", 100000);
