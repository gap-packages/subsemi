LoadPackage("subsemi");

SetInfoLevel(SubSemiInfoClass,0);

k := [1..6];
slices := [];
total := [];
results := [];
mult := fail; #just need to be a global variable for inline function 
for i in k do
  G := SymmetricGroup(i);
  mult := MulTab(G,G);
  subs := SubSgpsByMinClosures(mult);
  ids := Unique(List(AsList(subs),
                 x->IdSmallGroup(Group(
                         ElementsByIndicatorSet(
                                 x,
                                 mult)))));
  Add(results, ids);
  slice := Difference(ids,total);
  Add(slices,slice);
  total := Union(total,slice);
od;

names := List(slices, slice -> List(slice, id-> StructureDescription(SmallGroup(id))));
Display(names);
Display(List(names,Size));
