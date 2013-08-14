# type of the chain is the integer list containig the sizes of subsemigroups
GeneratorChain := function(S)
  local genchain,lS, extend, id, result, sgps,type, types;
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
      sgps := List([1..Size(genchain)], x-> Semigroup(genchain{[1..x]}));
      type := List(sgps, Size);
      if not (type in types) then
        Display(type); # for the impatient
        Add(result, ShallowCopy(genchain));
        AddSet(types, type);
      fi;
    fi;
  end;
  #-----------------------------------------------------------------------------
  lS := AsList(S);
  result := [];
  types := [];
  #starting from all idempotents - they are minimal subsemigroups
  for id in Idempotents(S) do
    extend([id]);
  od;
  return result;
end;

RandomMinimalGeneratorChain := function(S,T)
end;

AllGeneratorChainsOfDistinctType := function()
end;
