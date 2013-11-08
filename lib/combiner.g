# two sets plainly
Combiner := function(A,B,mt)
  local result, a,b;
  result := [];
  for a in A do
    for b in B do
      AddSet(result, SgpInMultab(UnionBlist(a,b),mt));
    od;
  od;
  return result;
end;
