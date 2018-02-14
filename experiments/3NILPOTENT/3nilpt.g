# enumerating 3-nilpotent subsemigroup of semigroup given by its multiplication
# table
Extend3NilpotentSubSgp := function(sgp, mt)
  local extendedsgps;
  extendedsgps := Set(Difference(Indices(mt),ListBlist(Indices(mt),sgp)),
                      x->BlistConjClassRep(ClosureByIncrements(sgp,x,mt),mt));
  return Filtered(extendedsgps,
                 x->Is3NilpotentInMulTab(ListBlist(Indices(mt),x),mt));
end;

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
