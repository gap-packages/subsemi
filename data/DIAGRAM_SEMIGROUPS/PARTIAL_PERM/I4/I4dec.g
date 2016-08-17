 SEMIGROUPS_DefaultOptionsRec.hashlen := 211;

mt := MulTab(SymmetricInverseMonoid(4),
             SymmetricGroup(IsPermGroup,4));

f := function(subs)
  local n;
  n := SizeBlist(subs[1]);
  Print(Size(subs), " of size ", SizeBlist(subs[1]),"\n");
  SaveIndicatorFunctions(subs, Concatenation("I4dec_", PaddedNumString(n,3),SUBS@SubSemi));
end;

SubSgpsInDecreasingOrder(mt,160, f);
