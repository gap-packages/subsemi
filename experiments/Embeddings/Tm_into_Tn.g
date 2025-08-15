#SubSemi v0.86

#works up to n=5 as the multiplication needs to fit in memory

CountTnEmbeddings := function(n)
  local Tn,Sn,mtTm,mtTn,m;
  Tn := FullTransformationSemigroup(n);
  Sn := SymmetricGroup(n);
  mtTn := MulTab(Tn,Sn);
  for m in [1..n-1] do
    mtTm := MulTab(FullTransformationSemigroup(m));
    Print(m, " into ", n," : ",
      Size(MulTabEmbeddingsUpToConjugation(mtTm,mtTn)), "\n");
  od;
end;