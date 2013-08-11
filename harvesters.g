# S - semigroup
# n - the number of generators
# N - number of iterations
# min - minimum size for the subsemigroup
# max - minimum size for the subsemigroup
# tag - prefix for the files
SimpleSizeRangeHarvester := function(S,n,N,min,max,tag)
local i,gens,T,mt,cuts,sgps;
  for i in [1..N] do
    gens := List([1..n], x->Random(AsList(S)));
    T := Semigroup(gens);
    if Size(T) <= max and Size(T) >= min then
      WriteSemigroups(Concatenation(tag,"_",String(i) , ".sgp.gz"), T);
      mt := MulTab(T);
      cuts := ReduceMulTab(mt)[1];
      sgps := ConvertToSgps(mt,cuts);
      Add(T,sgps);
      WriteSemigroups(Concatenation(tag,"_",String(i) , ".subs.gz"),sgps);
    fi;
  od;
end;

OnionHarvester := function(S,tag)
  WriteSemigroups(Concatenation(tag,"_orig.sgp.gz"), S);
  OnionReduceSgp(S,tag);
end;
