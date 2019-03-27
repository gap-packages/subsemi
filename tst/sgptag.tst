gap> START_TEST("SubSemi package: sgptag.tst");
gap> LoadPackage("SubSemi", false);;
gap> SgpTag(FullTransformationSemigroup(2),3);
"S004_I003_L003_R002_D002_RD002_M001_E001_G002_rm"
gap> T := Semigroup([Transformation([2,2]), Transformation([1,1])]);; #GroupOfUnits fails for this
gap> SgpTag(T,2);
"S02_I02_L02_R01_D01_RD01_M01_E00_G00_br"

#
gap> STOP_TEST( "SubSemi package: sgptag.tst", 10000);
