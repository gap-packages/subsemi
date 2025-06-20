#EXPERIMENTAL
# delegates the calculation to MaximalSubsemigroups in Semigroups
# converts back and forth
# returns conjugacy class representatives according to symmetries in mt
InstallGlobalFunction(MaximalSubsemigroups@,
function(sgp,mt)
  local S, maxsgps;
  S := Semigroup(SetByIndicatorFunction(sgp,mt));
  maxsgps := Set(MaximalSubsemigroups(S),
                 x->SgpInMulTab(
                         IndicatorFunction(GeneratorsOfSemigroup(x),mt),mt));
  return Set(maxsgps, x->BlistConjClassRep(x,mt));
end);

### ENUMERATING BY DECREASING ORDER ############################################

# this function does one step for SubSgpsInDecreasingOrder: getting the next
# class of semigroups with maximal size assuming that the sorted content of
# the given storage is consistent
# WARNING!!! side-effecting in st
InstallGlobalFunction(NextOrderClassSubSgps,
function(st, mt)
  local sgp, sub, result, n;
  if IsEmpty(st) then return []; fi;
  n := SizeBlist(Peek@(st));
  result := [];
  repeat
    sgp := Retrieve(st);
    Add(result, sgp);
    for sub in MaximalSubsemigroups@SubSemi(sgp,mt) do
      Store(st, sub);
    od;
  until IsEmpty(st) or (n > SizeBlist(Peek@(st)));
  return result;
end);

# using MaximalSubsemigroups enumerating all subsgps in order
# of decreasing size
# SubSgpsInDecreasingOrder(MulTab(T4,S4), 234, function(x)Print(Size(x), " of size ", SizeBlist(x[1]),"\n");end);
InstallGlobalFunction(SubSgpsInDecreasingOrder,
function(mt, lowerbound, processor)
  local f, st, next, result;
  f := function(A,B) return SizeBlist(A) < SizeBlist(B); end;
  if lowerbound < 1 then
    st := PriorityQueue(f, x->false);
  else
    st := PriorityQueue(f, x->SizeBlist(x) < lowerbound);
  fi;
  Store(st, FullSet(mt));
  result := [];
  repeat
    next := NextOrderClassSubSgps(st,mt);
    if not IsEmpty(next) then processor(next); fi;
    Append(result,next);
  until IsEmpty(next);
  return result;
end);
