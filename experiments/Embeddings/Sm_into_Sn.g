#SubSemi v0.86

#works up to n=7 as the multiplication table needs to fit in memory

CountTnEmbeddings := function(n)
  local Sn,mtSm,mtSn,m;
  Sn := SymmetricGroup(n);
  mtSn := MulTab(Sn,Sn);
  for m in [1..n-1] do
    mtSm := MulTab(SymmetricGroup(m));
    Print(m, " into ", n," : ",
      Size(MulTabEmbeddingsUpToConjugation(mtSm,mtSn)), "\n");
  od;
end;