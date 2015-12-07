MaxSubSgpsInMulTab := function(sgp,mt)
  local S, maxsgps;
  S := Semigroup(SetByIndicatorFunction(sgp,mt));
  maxsgps := List(MaximalSubsemigroups(S),
                  x->SgpInMulTab(IndicatorFunction(AsList(x),mt),mt));
  return Set(maxsgps, x->ConjugacyClassRep(x,mt));
end;

EnumByMaxSubSgps := function(mt)
  local layers, newlayer, total;
  layers := [[FullSet(mt)]];
  total := [FullSet(mt)];
  repeat
    newlayer := Difference(Union(List(layers[1], x->MaxSubSgpsInMulTab(x,mt))),
                        total);
    Info(SubSemiInfoClass, 1, String(Size(newlayer)), " new maximal subsgps");
    total := Union(total, newlayer);
    Add(layers, newlayer,1);
  until IsEmpty(newlayer);
  return layers;
end;
