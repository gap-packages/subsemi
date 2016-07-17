mtT := MulTab(T4,S4);
mtS := MulTab(T3);

#acting on a list by permutations
OnList := function(l,g) return List(l, x->x^g);end;
#conjugacy class representative
PosIntListConjRep := function(l,G) return Minimum(Set(G, x->OnList(l,x)));end;

MulTabEmbeddingsUpToConjugation := function(mtS, mtT)
  local phoms, i,l,r,nhoms,p;
  phoms := [ rec(phom:=[], stab:=SymmetryGroup(mtT))];
  for i in [1..Size(mtS)] do
    l := [];
    for r in phoms do
      nhoms := MultiplicationTableEmbeddingSearch(
                       Rows(mtS),
                       Rows(mtT),
                       CandidateLookup(EmbeddingProfiles(Rows(mtS)), EmbeddingProfiles(Rows(mtT))),
                       false,
                       r.phom,
                       i);
      nhoms := Set(nhoms, x-> PosIntListConjRep(x,r.stab));
      for p in nhoms do
        Add(l, rec(phom:=p, stab:=Stabilizer(r.stab,p,OnList)));
      od;
    od;
    phoms := l;
    Print(Size(phoms)," \c ");
  od;
  #return List(phoms, x->x.phom);
  return List(Classify(List(phoms, x->x.phom),
                 x->PosIntSetConjClassRep(Set(x),mtT),
                 \=),
              x->Representative(x));
end;
