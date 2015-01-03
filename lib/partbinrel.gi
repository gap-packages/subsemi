################################################################################
##
## SubSemi
##
## Partitioned Binary Relations
## Binary relations on 2n points with a different multiplication
##
## Copyright (C) 2015  Attila Egri-Nagy
##

InstallGlobalFunction(PartitionedBinaryRelation,
function(binrel)
  local a11, a12, a21, a22, deg, half, successors,i;
  deg := DegreeOfBinaryRelation(binrel);
  if not IsEvenInt(deg) then return fail; fi;
  half := deg/2;
  a11 := List([1..deg], x->[]); 
  a12 := List([1..deg], x->[]); 
  a21 := List([1..deg], x->[]); 
  a22 := List([1..deg], x->[]); 
  #sorting relations
  successors := Successors(binrel);
  for i in [1..half] do
    a11[i] := Filtered(successors[i], x-> x <= half);
    a12[i] := Filtered(successors[i], x-> x > half);
  od;
  for i in [half+1..deg] do
    a21[i] := Filtered(successors[i], x-> x <= half);
    a22[i] := Filtered(successors[i], x-> x > half);  
  od;
  return Objectify(PartitionedBinaryRelationType,
                 rec(a11:=a11,a12:=a12,a21:=a21,a22:=a22));
end);

BinRelOrbit := function(binrel)
  local orbit, x;
  orbit := [];
  x := binrel;
  while not x in orbit do AddSet(orbit,x); x := x*binrel; od;
  return orbit;
end;

InstallGlobalFunction(CombinePartitionedBinaryRelations,
function(alpha, beta)
  local a11, a12, a21, a22;
  
  #a11
  
end);

