gap> START_TEST("SubSemi package: 6packedbitstring.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> EncodeBitString("");
""
gap> B := "01";;
gap> ForAll(EnumeratorOfCartesianProduct([B]),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct([B,B,B,B]),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct([B,B,B,B,B,B,B,B,B,B,B,B]),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true

# now code key specific
gap> EncodeBitString("00000010101011001111111101");
"AVz=01"
gap> Concatenation(List(EnumeratorOfCartesianProduct([B,B,B,B,B,B]),EncodeBitString));
"AgQwIoY6EkU2Msc_CiSyKqa8GmW4Oue+BhRxJpZ7FlV3Ntd-DjTzLrb9HnX5Pvf="

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "Sgpdec package: cartesianenum.tst", 10000);