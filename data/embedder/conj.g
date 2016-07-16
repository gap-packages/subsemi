mtT := MulTab(T5,S5);
mtS := MulTab(T4);

#do the first step
search := function(hom,N)
  return MultiplicationTableEmbeddingSearch(
                 Rows(mtS),
                 Rows(mtT),
                 CandidateLookup(EmbeddingProfiles(Rows(mtS)), EmbeddingProfiles(Rows(mtT))),
                 false,
                 hom,
                 N);
end;

#acting on a list by permutations
OnList := function(l,g) return List(l, x->x^g);end;

#conjugacy classes
conjrep := function(l,G) return Minimum(Set(G, x->OnList(l,x)));end;

phoms := [ rec(phom:=[], stab:=SymmetryGroup(mtT))];
for i in [1..Size(mtS)] do
  l := [];
  for r in phoms do
    nhoms := search(r.phom,i);
    nhoms := Set(nhoms, x-> conjrep(x,r.stab));
    for p in nhoms do
      Add(l, rec(phom:=p, stab:=Stabilizer(r.stab,p,OnList)));
    od;
  od;
  phoms := l;
  Print(Size(phoms)," \c ");
od;
