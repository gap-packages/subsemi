# product of sets in multab S
SetProd := function(A,B,M)
  return Set(EnumeratorOfCartesianProduct([A,B]), p -> M[p[1]][p[2]]);
end;

isrm := function(rm, S, T)
  return ForAll(Tuples([1..Size(S)],2),
                p -> IsSubset(rm[S[p[1]][p[2]]],
                        SetProd(rm[p[1]],rm[p[2]],T)));
end;

srch := function(S,T)
  local tmp,Tsubs;
  tmp := EnumeratorOfCartesianProduct(List([1..Size(T)], x->[true,false]));
  Tsubs := List(tmp, x-> Filtered([1..Size(T)], y->x[y]));
  Tsubs := Filtered(Tsubs, x->Size(x)>0);
  return Filtered(EnumeratorOfCartesianProduct(List([1..Size(S)],x->Tsubs)),
                 x->isrm(x,S,T));
end;    


srch := function(S,T)
  local tmp,Tsubs;
  tmp := EnumeratorOfCartesianProduct(List([1..Size(T)], x->[true,false]));
  Tsubs := List(tmp, x-> Filtered([1..Size(T)], y->x[y]));
  Tsubs := Filtered(Tsubs, x->Size(x)>0);
  return Filtered(EnumeratorOfCartesianProduct(List([1..Size(S)],x->Tsubs)),
                 x->isrm(x,S,T));
end;    
