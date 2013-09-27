

#the set of transformations  is a semigroup if they don't generate
#new elements
IsSG := function(transformations)
  return Size(transformations) = Size(Semigroup(transformations));
end;

InvertedCutAsList := function(mt, cut)
  return mt.sortedts{Difference(mt.rn,
                 ListBlist(mt.rn,cut))
                 };
end;

ConvertToSgps := function(mt,cuts)
  local invcuts;
  invcuts := List(cuts, x -> InvertedCutAsList(mt,x) );
  Remove(invcuts,Position(invcuts,[]));#removing the empty set
  return  List(invcuts, ic -> Semigroup(ic));
end;

RandomizeBySystemClock := function()
  local SEED;
  SEED := IO_gettimeofday().tv_sec;
  Reset(GlobalMersenneTwister, SEED);
  Print("#Random seed:", SEED, "\n");
end;
