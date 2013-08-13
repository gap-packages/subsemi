GeneratorChain := function(S)
  local genchain,lS, extend, id, result, tmp;
  #-----------------------------------------------------------------------------
  #extend a generator chain
  extend := function(genchain)
    local T, diff, sizes,pos;
    T := Semigroup(genchain);
    diff := Difference(lS, AsList(T));
    if not IsEmpty(diff) then
      sizes := List(diff, t->Size(ClosureSemigroup(T,[t]))-Size(T));
      for pos in Positions(sizes, Minimum(sizes)) do
        Add(genchain, diff[pos]);
        extend(genchain);
        Remove(genchain);
      od;
    else
      #process
      tmp := List([1..Size(genchain)], x->Size(Semigroup(genchain{[1..x]})));
      if not (tmp in result) then Display(tmp);fi; # for the impatient
      AddSet(result, tmp);
    fi;
  end;
  #-----------------------------------------------------------------------------
  lS := AsList(S);
  result := [];
  #starting from all idempotents - they are minimal subsemigroups
  for id in Idempotents(S) do
    extend([id]);
  od;
  return result;
end;

RandomMinimalGeneratorChain := function(S,T)
end;
