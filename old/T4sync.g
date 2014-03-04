Read("MTR.g");
mt := MulTab(T4,S4);
consts := Filtered(mt.rn, i->RankOfTransformation(mt.sortedts[i])=1);
conjclasses := ReduceMulTab(mt, consts);
sgs := [];
for class in conjclasses do
  cut := ListBlist(mt.rn,class[1]);
  transfs := mt.sortedts{Difference(mt.rn,cut)};
  if not IsEmpty(transfs) then
    WriteSemigroups("data/T4sync.dat",Semigroup(transfs));
  fi;
od;
