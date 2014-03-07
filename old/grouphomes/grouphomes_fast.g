Read("A174511.g");

slices := [];
total := [];
results := [];
for i in [1..6] do
  G := SymmetricGroup(i);
  subs := IsomorphicGroupReps(List(ConjugacyClassesSubgroups(G),Representative));
  ids := List(subs,IdSmallGroup);
  Add(results, ids);
  slice := Difference(ids,total);
  Add(slices,slice);
  total := Union(total,slice);
od;

names := List(slices, slice -> List(slice, id-> StructureDescription(SmallGroup(id))));
Perform(names,Display);
Display(List(names,Size));
