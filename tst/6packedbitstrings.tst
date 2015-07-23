gap> START_TEST("SubSemi package: 6packedbitstring.tst");
gap> LoadPackage("SubSemi", false);;
gap> EncodeBitString("");
""
gap> B := "01";;
gap> ForAll(EnumeratorOfCartesianProduct([B]),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct(ListWithIdenticalEntries(4,B)),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct(ListWithIdenticalEntries(6,B)),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct(ListWithIdenticalEntries(7,B)),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct(ListWithIdenticalEntries(12,B)),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true
gap> ForAll(EnumeratorOfCartesianProduct(ListWithIdenticalEntries(15,B)),
>     bs -> bs = DecodeBitString(EncodeBitString(bs)));
true

# now code key specific
gap> EncodeBitString("00000010101011001111111101");
"+Knz01"
gap> Concatenation(List(EnumeratorOfCartesianProduct([B,B,B,B,B,B]),EncodeBitString));
"+VFk8cNs4ZJoBgRw2XHm=ePu6aLqDiTy-WGl9dOt5_KpChSx3YInAfQv7bMrEjUz"

#
gap> STOP_TEST( "SubSemi package: 6packedbitstring.tst", 10000);
