################################################################################
# another way: trying to do by cardinality

# R - a set of elements in the multiplication table
# mt - multiplication table
# output: conjugacy class representatives of sets of size |R|+1
ExtdConjugacyClassReps := function(A,mt)
  local exts;
  exts := List(Difference(Indices(mt), A), x->Union(A,[x]));
  return Set(exts, x->SetConjugacyClassRep(x,PossibleMinConjugators(x,mt)));
end;

ExtendIGS := function(igs, mt)
  local cls;
  cls := Union(Set(igs, x->ExtdConjugacyClassReps(x,mt)));
  Print("Found cls:", Size(cls), "\n");
  return Filtered(cls, x->IsSgpIGS(x,mt,SgpInMulTab(x,mt)));#should filter for solutions at the same time
end;

process := function(mt)
  local igs, res, sols;
  igs := [[]];
  sols := [];
  res := [];
  repeat
    igs := ExtendIGS(igs,mt);
    Print("Found igs:", Size(igs), "\n");
    sols := Filtered(igs, x-> Size(mt)=SizeBlist(SgpInMulTab(x,mt)));
    Print("Found sols:", Size(sols), "\n");
    igs := Difference(igs,sols);
    Add(res, sols);
  until IsEmpty(igs);
  return res;
end;
