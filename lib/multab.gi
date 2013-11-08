################################################################################
##
## SubSemi
##
## Multiplication table for magmas
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#mulitplication table based on the order of the magma elements in list,
#indices are assigned to elements
InstallGlobalFunction(ProductTableOfElements,
function(M) #magma in a list
local n, rows,i,j;
  n := Size(M);
  #nxn matrix 
  rows := List([1..n], x->ListWithIdenticalEntries(n,0));
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      rows[i][j] := Position(M, M[i]*M[j]);
    od;
  od;
  return rows;
end);

### CONSTRUCTORS ###############################################################
InstallOtherMethod(MulTab, "for a closed ordered list of multiplicative elements",
[IsSortedList],
function(l)
  local mt,inds; 
  mt := Objectify(MulTabType, rec());
  SetRows(mt,ProductTableOfElements(l));
  SetSortedElements(mt,l);
  inds := [1..Size(l)];
  MakeImmutable(inds);
  SetIndices(mt,inds);
  return mt;
end);

InstallMethod(MulTab, "for a semigroup",
[IsSemigroup],
function(S)
  local mt;
  mt := MulTab(AsSortedList(S));
  if HasName(S) then SetOriginalName(mt,Name(S));fi;
  return mt;
end);

InstallOtherMethod(MulTab, "for a semigroup and an automorphism  group",
[IsSemigroup,IsGroup],
function(S,G)
local mt;  
  mt := MulTab(S);
  SetSymmetries(mt,NonTrivialSymmetriesOfElementIndices(SortedElements(mt),G));
  return mt;
end);


InstallGlobalFunction(ConjugacyClassRep,
function(indset,mt)
local C;
  C := [indset]; #this set is kept sorted
  Perform(Symmetries(mt), function(g) AddSet(C,OnFiniteSet(indset,g));end);
  return C[1]; #the canonical rep
end);

### DISPLAY ####################################################################
InstallOtherMethod(Size, "for a multab",
[IsMulTab],
function(mt)
  return Size(Indices(mt));
end);

InstallMethod(ViewObj, "for a multab",
[IsMulTab],
function(mt)
  if HasOriginalName(mt) then
    Print("<multiplication table of ",OriginalName(mt),">");
  else
    Print("<multiplication table of ",Size(mt)," elements>");
  fi;
end);

