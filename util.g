FirstEntryPlusOne := function(blist)
  if Size(blist) = 0 then return 1; fi;
  return Position(blist,true)+1;
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
