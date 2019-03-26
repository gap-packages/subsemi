gap> START_TEST("SubSemi package: util.tst");
gap> LoadPackage("SubSemi", false);;
gap> FloatString(1/3);
"0.33"
gap> PercentageString(11,101);
"10.89%"
gap> TimeString(123456789);
"1d10h17m36s789ms"
gap> MemoryString(123456789);
"117.73MB"
gap> BigNumberString(12345678910111213);
"12Q 345T 678B 910M 111K"

#
gap> STOP_TEST( "SubSemi package: util.tst", 10000);
