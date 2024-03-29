gap> START_TEST("SubSemi package: embedding.tst");
gap> LoadPackage("SubSemi", false);;
gap> TableEmbeddings([[1,2],[2,2]],[[1,2,3],[2,2,3],[3,3,3]]);
[ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ]
gap> T3 := FullTransformationSemigroup(3);;
gap> S3 := SymmetricGroup(IsPermGroup,3);;mt := MulTab(T3);;
gap> ForAll(ConjugacyClassRepSubsemigroups(T3,S3),
>        x-> not IsEmpty(MulTabEmbedding(MulTab(Semigroup(x)), MulTab(T3))));
true
gap> TL3 := JonesMonoid(3);;mt := MulTab(TL3);;
gap> ForAll(AllSubsemigroups(TL3),
>        x-> not IsEmpty(MulTabEmbedding(MulTab(Semigroup(x)), mt)));
true

#
gap> STOP_TEST( "SubSemi package: embedding.tst", 10000);
