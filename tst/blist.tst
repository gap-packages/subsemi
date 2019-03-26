gap> START_TEST("SubSemi package: blist.tst");
gap> LoadPackage("SubSemi", false);;
gap> EncodeBitString("");
""
gap> AsBitString([true,false,true,false,false]);
"10100"
gap> AsBlist("001");
[ false, false, true ]
gap> BlistString(AsBlist("10100011"));
"{1,3,7,8}"
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
gap> bools := [true, false];;
gap> SaveIndicatorFunctions(AsList(EnumeratorOfCartesianProduct(ListWithIdenticalEntries(4,bools))), "4bitstrings.dat");
true
gap> LoadIndicatorFunctions("4bitstrings.dat");
[ [ true, true, true, true ], [ true, true, true, false ], 
  [ true, true, false, true ], [ true, true, false, false ], 
  [ true, false, true, true ], [ true, false, true, false ], 
  [ true, false, false, true ], [ true, false, false, false ], 
  [ false, true, true, true ], [ false, true, true, false ], 
  [ false, true, false, true ], [ false, true, false, false ], 
  [ false, false, true, true ], [ false, false, true, false ], 
  [ false, false, false, true ], [ false, false, false, false ] ]
gap> MT := MulTab(FullTransformationSemigroup(2));;
gap> blists := List(Combinations(Indices(MT)), l -> BlistList(Indices(MT),l));;
gap> ForAll(blists, b -> b = IndicatorFunction(SetByIndicatorFunction(b,MT),MT));
true
gap> MT := MulTab(Semigroup([Transformation([3,2,1,1]),Transformation([4,1,1,1])]));;
gap> blists := List(Combinations(Indices(MT)), l -> BlistList(Indices(MT),l));;
gap> ForAll(blists, b -> b = IndicatorFunction(SetByIndicatorFunction(b,MT),MT));
true

#
gap> STOP_TEST( "SubSemi package: blist.tst", 10000);
