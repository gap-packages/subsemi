T3 := FullTransformationSemigroup(3);
T4 := FullTransformationSemigroup(4);

Sing3 := SingularTransformationSemigroup(3);

mtT4 := MulTab(T4);
mtT3 := MulTab(T3);
mtSubT3 := MulTab(Semigroup([Transformation([2,3,1]), Transformation([2,2,3])]));

m := MulTabEmbeddings(mtSubT3, mtT4);
cls := l -> List(Classify(l, Set, \=), x->x[1]);
m := cls(m);

phom := function(hom, mtsub, mt)
  local i, partialhom;
  partialhom := [];  
  for i in [1..Size(mtsub)] do
    partialhom[Position(Elts(mt), Elts(mtsub)[i])] := hom[i];
  od;
  return partialhom;
end;

r := List(m, x->EmbeddingsDispatcher(Rows(mtT3), Rows(mtT4), phom(x,mtSubT3,mtT3), false));

