# delegates the calculation to MaximalSubsemigroups
# converts back and forth
# returns conjugacy class representatives according to symmetries in mt
InstallGlobalFunction(MaximalSubsemigroups@,
function(sgp,mt)
  local S, maxsgps;
  S := Semigroup(SetByIndicatorFunction(sgp,mt));
  maxsgps := Set(MaximalSubsemigroups(S),
                 x->SgpInMulTab(
                         IndicatorFunction(GeneratorsOfSemigroup(x),mt),mt));
  return Set(maxsgps, x->ConjugacyClassRep(x,mt));
end);

# side-effecting in st
SubSgpsNextStep := function(st, mt)
  local sgp, sub, result, n;
  if IsEmpty(st) then return []; fi;
  n := SizeBlist(Peek(st));
  result := [];
  repeat
    sgp := Retrieve(st);
    Add(result, sgp);
    for sub in MaximalSubsemigroups@SubSemi(sgp,mt) do
      Store(st, sub);
    od;
  until IsEmpty(st) or (n > SizeBlist(Peek(st)));
  return result;
end;


SubSgpsByDecresingOrder := function(mt)
  local f, st, next, result;
  f := function(A,B) return SizeBlist(A) < SizeBlist(B); end;
  st := SortedSet(f);
  Store(st, FullSet(mt));
  result := [];
  repeat
    next := SubSgpsNextStep(st,mt);
    Append(result,next);
  until IsEmpty(next);
  return result;
end;
