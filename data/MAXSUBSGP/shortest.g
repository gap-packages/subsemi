GreedySubgroupChain := function(G)
  if Size(G) = 1 then return 0; fi;
  return Minimum(List(MaximalSubgroupClassReps(G), GreedySubgroupChain))+1;
end;

GreedySubsemigroupChain := function(S)
  if Size(S) = 1 then return 1; fi;
  return Minimum(List(MaximalSubsemigroups(S), GreedySubsemigroupChain))+1;
end;
