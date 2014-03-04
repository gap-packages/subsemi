# n points missing k points
IdealByRank := function(n,k)
local shapes, ggens,sgens,i,l,shp,c;
  shapes := Filtered(Partitions(n), l -> Size(l)=n-k);

  if k=0 then
    return FullTransformationSemigroup(n);
  fi;

  ggens := List(GeneratorsOfGroup(SymmetricGroup(IsPermGroup,n)),
                g->AsTransformation(g,n));
  sgens := [];
  for shp in shapes do
    l := [];
    c := 1;
    for i in [1..Size(shp)] do
      Append(l, ListWithIdenticalEntries(shp[i],c));
      c := c + 1;
    od;
    Add(sgens, Transformation(l));
  od;
  return Semigroup(SmallGeneratingSet(Semigroup(
                 Difference(Semigroup(Union(sgens,ggens)),Semigroup(ggens)))));
end;
