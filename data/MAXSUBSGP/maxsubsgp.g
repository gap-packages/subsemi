# delegates the calculation to MaximalSubsemigroups
#converts back and forth
MaxSubSgpsInMulTab := function(sgp,mt)
  local S, maxsgps;
  Print("#\c");
  S := Semigroup(SetByIndicatorFunction(sgp,mt));
  maxsgps := Set(MaximalSubsemigroups(S),
                  x->SgpInMulTab(
                          IndicatorFunction(GeneratorsOfSemigroup(x),mt),mt));
  return Set(maxsgps, x->ConjugacyClassRep(x,mt));
end;

EnumByMaxSubSgps := function(mt)
  local layers, newlayer, total, newelts,i;
  layers := [[FullSet(mt)]];
  total := [FullSet(mt)];
  i := 1;
  repeat
    newelts := Union(List(layers[1], x->MaxSubSgpsInMulTab(x,mt)));
    newlayer := Difference(newelts, total);
    Info(SubSemiInfoClass, 1, String(Size(newlayer)),
         " new maximal subsgps out of ", String(Size(newelts)));
    total := Union(total, newlayer);
    Add(layers, newlayer,1);
    SaveIndicatorFunctions(newlayer, Concatenation(OriginalName(mt),
            PaddedNumString(String(i),2)));
  until IsEmpty(newlayer);
  return layers;
end;
