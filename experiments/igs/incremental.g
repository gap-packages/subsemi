#incremental generating sets for Sn

AllBut := function(A,a) return Difference(A,[a]);end;

GetMaximals := function(gens)
  return Set(gens, x-> Group(AllBut(gens,x)));
end;

GetAll := function(gens)
  return Set(Filtered(Combinations(gens), x -> not IsEmpty(x)),
             Group);
end;

IsSymGWithDegree := function(gens, deg)
  local G;
  G := Group(gens);
  return NrMovedPoints(G) = deg
         and IsNaturalSymmetricGroup(G);
end;

IsIncrementalSymmetricGrpGenSet := function(gens)
  local G,deg;
  G := Group(gens);
  if not IsNaturalSymmetricGroup(G) then
    Error("Not natural symmetric group generators!");
  fi;
  deg := NrMovedPoints(G) - 1;
  return ForAny(gens, x-> IsSymGWithDegree(AllBut(gens,x),deg));
end;

#calculating actual isomorphism to S_{n-1}
IsIncrementalSymmetricGrpGenSetSlow := function(gens)
  local G,target;
  G := Group(gens);
  if not IsNaturalSymmetricGroup(G) then
    Error("Not natural symmetric group generators!");
  fi;
  target := SymmetricGroup(IsPermGroup, NrMovedPoints(G) - 1);
  return ForAny(gens, x-> fail <> IsomorphismGroups(target,Group(AllBut(gens,x))));
end;

IsStronglyIncrementalSymmetricGrpGenSet := function(gens)
  local G,deg,target;
  G := Group(gens);
  if not IsSymmetricGroup(G) then Error("Not symmetric group generators!");fi;
  deg := SymmetricDegree(G);
  target := SymmetricGroup(IsPermGroup,deg-1);
  return ForAll(gens, x-> fail <> IsomorphismGroups(target,Group(AllBut(gens,x))));
end;

IsRecursivelyIncrementalSymmetricGrpGenSet := function(gens)
  local G,deg,target;
  if IsEmpty(gens) then return true;fi;
  G := Group(gens);
  if not IsSymmetricGroup(G) then return false;fi;
  deg := SymmetricDegree(G);
  if deg = 1 then return true;fi;
  target := SymmetricGroup(IsPermGroup,deg-1);
  return ForAll(gens, x-> IsRecursivelyIncrementalSymmetricGrpGenSet(AllBut(gens,x)));
end;
