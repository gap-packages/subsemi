mtT := MulTab(T4,S4);
mtS := MulTab(T3);

#acting on a list by permutations
OnList := function(l,g) return List(l, x->x^g);end;
#conjugacy class representative
PosIntListConjRep := function(l,G) return Minimum(Set(G, x->OnList(l,x)));end;

MulTabEmbeddingsUpToConjugation := function(mtS, mtT)
local i, # number of mappings in a partial solution
      queue, # elements waiting to be processed
      extended, # extended partial solutions
      newq, # the new queue
      p,q;  # (partial solution, stabilizer) pairs
  queue := [ rec(psol:=[], stab:=SymmetryGroup(mtT))];
  for i in [1..Size(mtS)] do
    Info(SubSemiInfoClass,2,"size:",i,", ",Size(queue)," waiting");
    newq := [];
    for p in queue do
      extended := MultiplicationTableEmbeddingSearch(
                          Rows(mtS),
                          Rows(mtT),
                          CandidateLookup(EmbeddingProfiles(Rows(mtS)),
                                  EmbeddingProfiles(Rows(mtT))),
                          false,
                          p.psol,
                          i);
      extended := Set(extended, x-> PosIntListConjRep(x,p.stab));
      for q in extended do
        Add(newq, rec(psol:=q, stab:=Stabilizer(p.stab,q,OnList)));
      od;
    od;
    queue := newq;
  od;
  return List(Classify(List(newq, x->x.psol), #forgetting stabilizers
                 x->PosIntSetConjClassRep(Set(x),mtT), #conj rep of image as set
                 \=),
              x->Representative(x)); #taking representatives
end;
