# delegates the calculation to MaximalSubsemigroups
# converts back and forth
# returns conjugacy class representatives according to symmetries in mt
InstallGlobalFunction(MaximalSubsemigroups@,
function(sgp,mt)
  local S, maxsgps;
  S := Semigroup(SetByIndicatorFunction(sgp,mt));
  maxsgps := Set(MaximalSubsemigroups(S),
                 x->SgpInMulTab(
                         IndicatorFunction(GeneratorsOfSemigroup(x),mt),mt));
  return Set(maxsgps, x->ConjugacyClassRep(x,mt));
end);
