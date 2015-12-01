gap> START_TEST("SubSemi package: classifier.tst");
gap> LoadPackage("SubSemi", false);;
gap> Classify([1..100], x-> x mod 3, \=);
[ [ 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, 52, 55, 
      58, 61, 64, 67, 70, 73, 76, 79, 82, 85, 88, 91, 94, 97, 100 ], 
  [ 2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50, 53, 56, 
      59, 62, 65, 68, 71, 74, 77, 80, 83, 86, 89, 92, 95, 98 ], 
  [ 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 
      60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99 ] ]
gap> sgps := List(ConjugacyClassRepSubsemigroups(BrauerMonoid(3),S3), Semigroup);;
gap> Size(Classify(sgps, MulTab, IsIsomorphicMulTab));
14

#
gap> STOP_TEST( "SubSemi package: classifier.tst", 1000);
