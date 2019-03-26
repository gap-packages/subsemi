gap> START_TEST("SubSemi package: ui.tst");
gap> LoadPackage("SubSemi", false);;
gap> T3 := FullTransformationSemigroup(3);;
gap> S3 := SymmetricGroup(IsPermGroup,3);;
gap> Size(AllSubsemigroups(T3));
1298
gap> Size(ConjugacyClassRepSubsemigroups(T3,S3));
282
gap> IsIsomorphicSemigroupByMulTabs(S3,T3);
false
gap> T3p := Semigroup([Transformation([1,3,2,4]), Transformation([1,2,4,3]), Transformation([1,2,3,3])]);;
gap> IsIsomorphicSemigroupByMulTabs(T3p,T3);
true
gap> IsomorphismSemigroupsByMulTabs(T3p,T3);
MappingByFunction( <transformation semigroup of size 27, degree 4 with 3 
 generators>
 , <full transformation monoid of degree 3>, function( s ) ... end )
gap> StructureDescription(AutomorphismGroup(T3));
"S3"
gap> IndependentSets(S3);
[ [  ], [ (1,3) ], [ (1,3,2) ], [ (1,3,2), (1,3) ], [ (1,2,3) ], 
  [ (1,2,3), (1,3) ], [ (1,2) ], [ (1,2), (1,3) ], [ (1,2), (1,3,2) ], 
  [ (1,2), (1,2,3) ], [ (2,3) ], [ (2,3), (1,3) ], [ (2,3), (1,3,2) ], 
  [ (2,3), (1,2,3) ], [ (2,3), (1,2) ], [ () ] ]

#
gap> STOP_TEST( "SubSemi package: ui.tst", 10000);
