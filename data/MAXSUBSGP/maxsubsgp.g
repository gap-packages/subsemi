EnumByMaxSubSgps := function(mt)
  local layers, newlayer, total, newelts,i;
  layers := [[FullSet(mt)]];
  total := [FullSet(mt)];
  i := 0;
  repeat
    SaveIndicatorFunctions(layers[1], Concatenation(OriginalName(mt),
            "_", PaddedNumString(String(i),2)));
    newelts := Union(List(layers[1], x->MaxSubSgpsInMulTab(x,mt)));
    newlayer := Difference(newelts, total);
    Info(SubSemiInfoClass, 1, String(Size(newlayer)),
         " new maximal subsgps out of ", String(Size(newelts)),
         " TOTAL ", String(Size(total)));
    total := Union(total, newlayer);
    Add(layers, newlayer,1);
    i := i + 1;
  until IsEmpty(newlayer);
  return layers;
end;
