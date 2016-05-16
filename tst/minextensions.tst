gap> START_TEST("SubSemi package: minextensions.tst");
gap> LoadPackage("SubSemi", false);;
gap> T2 := FullTransformationSemigroup(2);;
gap> S2 := SymmetricGroup(2);;
gap> mt := MulTab(T2,S2);;
gap> SubsOfSubInAmbientSgp(SgpInMulTab([3],mt),mt);
[ {2,3}, {2} ]

#
gap> STOP_TEST( "SubSemi package: minextensions.tst", 100000);
