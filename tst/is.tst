gap> START_TEST("SubSemi package: is.tst");
gap> LoadPackage("SubSemi", false);;
gap> S5 := SymmetricGroup(IsPermGroup,5);;
gap> mt := MulTab(S5,S5);;
gap> AsSortedList(IS(mt,ISDatabase)) = AsSortedList(IS(mt,ISCanCons));
true

#
gap> STOP_TEST( "SubSemi package: is.tst", 10000);
