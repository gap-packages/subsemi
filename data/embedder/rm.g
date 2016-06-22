# product of sets in multab S
SetProd := function(A,B,M)
  return Set(EnumeratorOfCartesianProduct([A,B]), p -> M[p[1]][p[2]]);
end;

isrm := function(rm, S, T)
  return ForAll(Tuples([1..Size(S)],2),
                p -> IsSubset(rm[S[p[1]][p[2]]],
                        SetProd(rm[p[1]],rm[p[2]],T)));
end;
