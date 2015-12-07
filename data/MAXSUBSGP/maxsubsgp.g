MaxSubSgpsInMulTab := function(sgp,mt)
  local S, maxsgps;
  S := Semigroup(SetByIndicatorFunction(sgp,mt));
  maxsgps := List(MaximalSubsemigroups(S),
                  x->SgpInMulTab(IndicatorFunction(Generators(x),mt),mt));
  return Set(maxsgps, x->ConjugacyClassRep(x,mt));
end;
