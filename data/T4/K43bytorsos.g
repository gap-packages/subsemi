Read("sgps.g");
SetInfoLevel(SubSemiInfoClass,0);

K43Subs := function(exts)
  local ext, result, mt, K42elts;
  result := [];
  mt := MulTab(K43,S4);
  K42elts := IndicatorSetOfElements(K42, SortedElements(mt));
  for ext in exts do
    Append(result, AsList(SubSgpsByMinClosuresParametrized(mt, ext, K42elts)));
    Print("#\c");
  od;
  return result;
end;
