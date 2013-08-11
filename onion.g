GeneratorChain := function(S)
  local gens,i,lS, diff, sizes,gS;
  #list gives better random element
  lS := AsList(S);
  gens := [Random(S)];
  repeat;
    gS := Semigroup(gens);
    diff := Difference(lS, AsList(gS));
    if not IsEmpty(diff) then
      sizes := List(diff, t->Size(ClosureSemigroup(gS,t))-Size(gS));
      Add(gens, diff[Position(sizes, Minimum(sizes))]);
    fi;
  until IsEmpty(diff);
  return gens;
end;
