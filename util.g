# returns the position of the 1st entry, 1 if empty
FirstEntry := function(blist)
  if SizeBlist(blist) = 0 then return 1; fi;
  return Position(blist,true);
end;

# returns the position of the last entry, 1 if empty
LastEntry := function(blist)
local i;
  if SizeBlist(blist) = 0 then return 1; fi;
  i := Size(blist);
  while not blist[i] do i := i - 1; od;
  return i;
end;


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
