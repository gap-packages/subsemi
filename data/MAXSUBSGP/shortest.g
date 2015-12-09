LengthOfShortestSubgroupChain := function(G)
  if Size(G) = 1 then return 0; fi;
  return Minimum(List(MaximalSubgroupClassReps(G),
                 LengthOfShortestSubgroupChain)) + 1;
end;

AllShortestSubgroupChains := function(G)
  local shortchains, min, l;
  if Size(G) = 1 then return [[0, [G]]]; fi;
  shortchains := Concatenation(List(MaximalSubgroupClassReps(G),
                         AllShortestSubgroupChains));
  min := Minimum(List(shortchains, x -> x[1]));
  l := Filtered(shortchains, x -> min = x[1]);
  return List(l, x -> [min + 1, Concatenation([G], x[2])]);
end;

GrpChainDescription :=
  l -> List(l, x -> [x[1], List(x[2], y -> StructureDescription(y))]);

SgpIsomClassReps := function(sgps)
  local classes;
  classes := Classify(sgps,
                     x->x,
                     function(x,y)
                       return IsomorphismSemigroupsByMulTabs(x,y) <> fail;
                     end);
  return List(classes, Representative);
end;

GreedySubsemigroupChain := function(S)
  if Size(S) = 1 then return 1; fi;
  return Minimum(List(MaximalSubsemigroups(S), GreedySubsemigroupChain))+1;
end;
