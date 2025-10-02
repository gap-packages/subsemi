# v0.86
s1 := Matrix(Integers, [[0,0],[0,0]]);
s2 := Matrix(Integers, [[0,0],[0,1]]);
s3 := Matrix(Integers, [[0,0],[1,0]]);
s4 := Matrix(Integers, [[0,1],[0,1]]);
s5 := Matrix(Integers, [[1,0],[1,0]]);

S := Semigroup([s1,s2,s3,s4,s5]);

#these are the minimal degree embeddings

MulTabEmbedding(MulTab(S), MulTab(BrauerMonoid(5)));
MulTabEmbedding(MulTab(S), MulTab(PartitionMonoid(3)));
#bit misleading, as as the partial transformation monoid is on n+1 points
MulTabEmbedding(MulTab(S), MulTab(PartialTransformationMonoid(2)));