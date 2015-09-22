#incremental generating sets for Sn

IsSymGWithDegree := function(gens, deg)
  local G;
  G := Group(gens);
  return NrMovedPoints(G) = deg
         and IsSymmetricGroup(G);
end;

IsIncrementalSymmetricGrpGenSet := function(gens)
  local G,deg;
  G := Group(gens);
  if not IsNaturalSymmetricGroup(G) then
    Error("Not natural symmetric group generators!");
  fi;
  deg := NrMovedPoints(G) - 1;
  return ForAny(gens, x-> IsSymGWithDegree(Difference(gens,[x]),deg));
end;

IsIncrementalSymmetricGrpGenSetSlow := function(gens)
  local G,target;
  G := Group(gens);
  if not IsNaturalSymmetricGroup(G) then
    Error("Not natural symmetric group generators!");
  fi;
  target := SymmetricGroup(IsPermGroup, NrMovedPoints(G) - 1);
  return ForAny(gens, x-> fail <> IsomorphismGroups(target,Group(Difference(gens,[x]))));
end;


IsStronglyIncrementalSymmetricGrpGenSet := function(gens)
  local G,deg,target;
  G := Group(gens);
  if not IsSymmetricGroup(G) then Error("Not symmetric group generators!");fi;
  deg := SymmetricDegree(G);
  target := SymmetricGroup(IsPermGroup,deg-1);
  return ForAll(gens, x-> fail <> IsomorphismGroups(target,Group(Difference(gens,[x]))));
end;

IsRecursivelyIncrementalSymmetricGrpGenSet := function(gens)
  local G,deg,target;
  if IsEmpty(gens) then return true;fi;
  G := Group(gens);
  if not IsSymmetricGroup(G) then return false;fi;
  deg := SymmetricDegree(G);
  if deg = 1 then return true;fi;
  target := SymmetricGroup(IsPermGroup,deg-1);
  return ForAll(gens, x-> IsRecursivelyIncrementalSymmetricGrpGenSet(Difference(gens,[x])));
end;
