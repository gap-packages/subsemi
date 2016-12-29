#embedding all subsemigroups of T3 into T5
T3 := FullTransformationSemigroup(3);
T5 := FullTransformationSemigroup(5);

S3 := SymmetricGroup(IsPermGroup, 3);
S5 := SymmetricGroup(IsPermGroup, 5);

mtT5 := MulTab(T5,S5);

T3subs := List(ConjugacyClassRepSubsemigroups(T3,S3), Semigroup);

imgs := [];
imgs2 := [];
# embeddings modulo the automorphisms of S in Sub(T3)
# and up to conjugacy in T5
for i in [1..Length(T3subs)] do
  imgs2[i] := Set(MulTabEmbeddings(MulTab(T3subs[i]), mtT5),
                  x->BlistConjClassRep(BlistList(Indices(mtT5),x),mtT5));
  imgs[i] := MulTabEmbeddingsUpToConjugation(MulTab(T3subs[i]), mtT5);
  Info(SubSemiInfoClass, 1,"sgp of size ",String(Size(T3subs[i])),
       " -> ", Size(imgs[i]), " copies");
od;

Info(SubSemiInfoClass,1," CHECK:" , List(imgs, Size) = List(imgs2,Size));
Info(SubSemiInfoClass,1," TOTAL:" , Sum(List(imgs, Size)));

