TwoGenEmbeddings := function(mtS,mtT)
  local l;
  l := Filtered(NGeneratedSubSgps(mtT,2),
               x->SizeBlist(x)>=Size(mtS));
  l := List(l, x-> Semigroup(SetByIndicatorFunction(x,mtT)));
  return Set(Filtered(List(l, x -> MulTabEmbedding(mtS, MulTab(x))),
                 y -> not IsEmpty(y)),Set);
end;
