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
                     MulTab,
                     function(x,y)
                       return IsomorphismMulTabs(x,y) <> fail;
                     end);
  return List(classes, Representative);
end;

LengthOfShortestSubsemigroupChain := function(S)
  if Size(S) = 1 then return 1; fi;
  return Minimum(List(SgpIsomClassReps(MaximalSubsemigroups(S)),
                 LengthOfShortestSubsemigroupChain)) + 1;
end;

### GREEDY BY SIZE #############################################################
# Length of Shortest Greedy Maximal Sub* Chain - higher order function
# S - semigroup, group
# MaxSubs - function that gives the maximal subs of S
# ClassReps - function that gives class representatives of a collection
LOSGMSC := function(S, MaxSubs, ClassReps)
  local maxsubs, min, minimalmaxsubs;
  if Size(S) = 1 then return 1; fi;
  maxsubs := MaxSubs(S);
  min := Minimum(List(maxsubs, Size));
  minimalmaxsubs := Filtered(maxsubs, x-> min = Size(x));
  return Minimum(List(ClassReps(minimalmaxsubs),
                 x -> LOSGMSC(x,MaxSubs,ClassReps))) + 1;
end;

LengthOfShortestGreedySubSgpChain := function(S)
  return LOSGMSC(S, MaximalSubsemigroups, SgpIsomClassReps);
end;

LengthOfShortestGreedySubGrpChain := function(G)
  return LOSGMSC(G, MaximalSubgroupClassReps, x->x);
end;
