#embedding all subsemigroups of T3 into T4
T3 := FullTransformationSemigroup(3);
T4 := FullTransformationSemigroup(4);

S3 := SymmetricGroup(IsPermGroup, 3);
S4 := SymmetricGroup(IsPermGroup, 4);

mtT4 := MulTab(T4,S4);

T3subs := List(ConjugacyClassRepSubsemigroups(T3,S3), Semigroup);

imgs := [];

# embeddings modulo the automorphisms of S in Sub(T3)
# and up to conjugacy in T4
for i in [1..Length(T3subs)] do
#  imgs[i] := Set(MulTabEmbeddings(MulTab(T3subs[i]), mtT4),
#                 x->BlistConjClassRep(BlistList(Indices(mtT4),x),mtT4));
  imgs[i] := MulTabEmbeddingsUpToConjugation(MulTab(T3subs[i]), mtT4);
  Info(SubSemiInfoClass, 1,"sgp of size ",String(Size(T3subs[i])),
       " -> ", Size(imgs[i]), " copies");
od;
