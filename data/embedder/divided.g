T3 := FullTransformationSemigroup(3);
T4 := FullTransformationSemigroup(4);

Sing3 := SingularTransformationSemigroup(3);

mtT4 := MulTab(T4);
mtT3 := MulTab(T3);
mtSing3 := MulTab(Sing3);

m := MulTabEmbeddings(mtSing3, mtT4);
m := List(Classify(m, Set, \=), x->x[1]);

hom:=m[1];


phom := function(hom, mtsub, mt)
  local i, partialhom;
  partialhom := [];  
  for i in [1..Size(mtsub)] do
    partialhom[Position(Elts(mt), Elts(mtsub)[i])] := hom[i];
  od;
  return partialhom;
end;

r := List(m, x->EmbeddingsDispatcher(Rows(mtT3), Rows(mtT4), phom(x,mtSing3,mtT3), false));

