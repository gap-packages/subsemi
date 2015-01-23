gap> START_TEST("SubSemi package: gensets.tst");
gap> LoadPackage("SubSemi", false);;
gap> S := Semigroup([Transformation([1,3,5,2,3]),Transformation([5,1,5,3,3])]);;
gap> subs := AsSortedList(SubSgpsByMinExtensions(MulTab(S)));;
gap> subs2 := AsSortedList(Concatenation(SubSgpsByMinimalGenSets(MulTab(S))));;
gap> subs = subs2;
true

#
gap> STOP_TEST( "SubSemi package: gensets.tst", 10000);
