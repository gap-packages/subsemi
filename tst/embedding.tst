gap> START_TEST("SubSemi package: embedding.tst");
gap> LoadPackage("SubSemi", false);;
gap> EmbeddingsDispatcher([[1,2],[2,2]],[[1,2,3],[2,2,3],[3,3,3]],[],false);
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
gap>  f :=  G -> IsomorphismGroups(AutomorphismGroup(G), AutGrpOfMulTab(MulTab(G)))<>fail;;
gap>  ForAll([1..15], n -> ForAll(AllSmallGroups(n), G -> f(G)));
true
gap>  MulTabEmbeddings(MulTab(OrderEndomorphisms(2)), MulTab(SymmetricGroup(IsPermGroup,3), SymmetricGroup(IsPermGroup,3)));
[  ]
gap> T4 := FullTransformationSemigroup(4);;
gap> S4 := SymmetricGroup(IsPermGroup,4);;
gap> mtT3 := MulTab(T3);;
gap> mtT4 := MulTab(T4,S4);;
gap> Size(MulTabEmbeddingsUpToConjugation(mtT3,mtT4));
4
gap> Size(MulTabEmbeddingsByPartialHoms(MulTab(Semigroup(Transformation([2,3,1]))), mtT3, MulTab(T4)));
24

#
gap> STOP_TEST( "SubSemi package: embedding.tst", 10000);
