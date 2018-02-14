# enumerating 3-nilpotent subsemigroup of semigroup given by its multiplication
# table

LoadPackage("subsemi");

# A naive search for 3-nilpotent subsemigroups: it extends a subsemigroup
# (assumed to be 3-nilpotent) in multiplication table mt.
# Extending is done by adding a new generator.
# To do improvements:
# Better would be to have a closure function that checks for 3-nilpotency.
# Also, not extending by elements that generate non-3-nilpotent subsgps.
Extend3NilpotentSubSgp := function(sgp, mt)
  local extendedsgps;
  extendedsgps := Set(Difference(Indices(mt),ListBlist(Indices(mt),sgp)),
                      x->BlistConjClassRep(ClosureByIncrements(sgp,x,mt),mt));
  return Filtered(extendedsgps,
                 x->Is3NilpotentInMulTab(ListBlist(Indices(mt),x),mt));
end;

# searching by the number of generators
ThreeNilpotentSubSgps := function(mt)
  local total, l;
  total := [];
  l := [EmptySet(mt)];
  repeat
    l := Difference(Union(List(l, x->Extend3NilpotentSubSgp(x,mt))), total);
    Info(SubSemiInfoClass, 1, String(Size(l))," new 3-nilpotent subsgps");
    total := Union(total, l);
  until IsEmpty(l);
  return total;
end;
