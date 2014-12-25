# matrix approach - lot more than the relabelling symmetries, and it is not the same
# UPDATE: the multiplication is not in the boolean algebra, hence the difference
matrices := Tuples(Tuples([0*Z(2),Z(2)^0],2),2);

S := Semigroup(matrices);

G := Filtered(S, x->fail <> Inverse(x));

Filtered(G, x->Set(S) = Set(S, y-> Inverse(x)*y*x));

# just list based 


U := BinaryRelationOnPoints([[2],[1]]);
V := BinaryRelationOnPoints([[1,1],[]]);
Y := BinaryRelationOnPoints([[1,2],[1]]);
W := BinaryRelationOnPoints([[1,2],[]]);

B2 := Semigroup([U,V,Y,W]);


# just a crude algorithm for combining binary relations
ConjugateBinaryRelations := function(rel, perm)
  local l,newrel, i;
  newrel := [];
  l := Successors(rel);
  #first moving the domains
  for i in [1..Size(l)] do
    newrel[i^perm] := l[i];
  od;
  #then moving the images
  newrel := List(newrel, x-> List(x, y->y^perm));
  return BinaryRelationOnPoints(newrel);
end;

InstallOtherMethod(\^, "for relabelling list based binary relations", [IsBinaryRelation, IsPerm], ConjugateBinaryRelations);
