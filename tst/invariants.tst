gap> START_TEST("SubSemi package: invariants.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> mt := MulTab(FullTransformationSemigroup(4));;
gap> MulTabProfile(mt);
[ [ [ 24, 24 ], [ 120, 144 ], [ 408, 36 ], [ 504, 48 ], [ 2200, 4 ] ], 
  [ [ 1, 56 ], [ 2, 3 ], [ 4, 36 ], [ 10, 5 ] ], 
  [ [ [ 1, 1 ], 41 ], [ [ 1, 2 ], 69 ], [ [ 1, 3 ], 32 ], [ [ 1, 4 ], 6 ], 
      [ [ 2, 1 ], 60 ], [ [ 2, 2 ], 24 ], [ [ 3, 1 ], 24 ] ] ]

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: invariants.tst", 10000);