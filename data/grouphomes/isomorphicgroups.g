#takes a collection of groups and returns a list keeping non-isomorphic ones
IsomorphicGroupReps := function(groups)
local R,H,G;
  R:=[];
  for G in groups do
    if First(R, H->IsomorphismGroups(G,H)<>fail) = fail then
      Add(R,G);
    fi;
  od;
  return R;
end;

#A174511
NumOfIsomorphismClassesDegreeNPerms := function(n)
  return Size(IsomorphicGroupReps(
                 List(ConjugacyClassesSubgroups(SymmetricGroup(n)),
                                                Representative)));
end;
