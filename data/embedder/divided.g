T3 := FullTransformationSemigroup(3);
T4 := FullTransformationSemigroup(4);

Sing3 := SingularTransformationSemigroup(3);

mtT4 := MulTab(T4);
mtT3 := MulTab(T3);
mtSing3 := MulTab(Sing3);

m := MulTabEmbeddings(mtSing3, mtT4);
m := List(Classify(m, Set, \=), x->x[1]);

hom:=m[1];
partialhom := [];

for i in [1..Size(mtSing3)] do
  partialhom[Position(Elts(mtT3), Elts(mtSing3)[i])] := hom[i];
od;
