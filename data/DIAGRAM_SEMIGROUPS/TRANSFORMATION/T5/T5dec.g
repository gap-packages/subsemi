 SEMIGROUPS_DefaultOptionsRec.hashlen := 3137;

mt := MulTab(FullTransformationSemigroup(5),
             SymmetricGroup(IsPermGroup,5));

f := function(subs)
  local n;
  n := SizeBlist(subs[1]);
  Print(Size(subs), " of size ", SizeBlist(subs[1]),"\n");
  SaveIndicatorFunctions(subs, Concatenation("T5dec_", PaddedNumString(n,4),SUBS@SubSemi));
end;

SubSgpsInDecreasingOrder(mt,3000, f);
