#by order
SubSgpsByDecresingOrder := function(mt)
  local f, st, sgp, sub, result;
  f := function(A,B) return SizeBlist(A) < SizeBlist(B); end;
  st := SortedSet(f);
  Store(st, FullSet(mt));
  result := [];
  repeat
    sgp := Retrieve(st);
    Add(result, sgp);
    for sub in MaximalSubsemigroups@SubSemi(sgp,mt) do
      Store(st, sub);
    od;
  until IsEmpty(st);
  return result;
end;

#by chain length
EnumByMaxSubSgps := function(mt)
  local layers, newlayer, total, newelts,i;
  layers := [[FullSet(mt)]];
  total := [FullSet(mt)];
  i := 0;
  repeat
    SaveIndicatorFunctions(layers[1], Concatenation(OriginalName(mt),
            "_", PaddedNumString(String(i),2)));
    newelts := Union(List(layers[1], x->MaximalSubsemigroups@SubSemi(x,mt)));
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
