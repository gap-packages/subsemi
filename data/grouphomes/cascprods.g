Read("isomorphicgroups.g");

Slices := function(top, bottoms)
  local bottom, cp,total,slice,slices,subs, ids, G;
  total := [];
  slices := [];
  for bottom in bottoms do
    cp := FullCascadeGroup([top,bottom]);
    G := Range(IsomorphismPermGroup(cp));
    subs := IsomorphicGroupReps(List(ConjugacyClassesSubgroups(G),Representative));  
    ids := List(subs,IdSmallGroup);
    #Add(results, ids);
    slice := Difference(ids,total);
    Add(slices,slice);
    total := Union(total,slice);    
  od;
  return slices;
end;
