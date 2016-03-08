#for counting the number of embeddings

MulTabEmbeddingsUpToConjugation := function(mtS, mtT)
  return  Set(Set(MulTabEmbeddings(mtS,mtT), Set),
              x->PosIntSetConjClassRep(x,mtT));
end;
