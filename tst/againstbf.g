#calculating subs with BF and 1extension, compare results
TestAgainstBruteForce := function(M)
  local mt,l1,l2;
  mt := MulTab(M);
  l1 := BFSubSemis(M);
  Perform(l1,Sort);
  Sort(l1);
  l2 := List(AsList(SubSgpsByMinClosures(mt)),
             b->ElementsByIndicatorSet(b,mt));
  Perform(l2,Sort);
  Sort(l2);
  return l1 = l2;
end;
