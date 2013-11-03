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
  return MulTab(AsSortedList(S));
end);

InstallOtherMethod(MulTab, "for a semigroup and an automorphism  group",
[IsSemigroup,IsGroup],
function(S,G)
local mt;  
  mt := MulTab(S);
  SetSymmetries(mt,NonTrivialSymmetriesOfElementIndices(SortedElements(mt),G));
  return mt;
end);


#ts - transformation semigroup, permutation group
#returns a record with the multiplication table and other extra info
hupi := function(arg)
local n,p,rcs,sortedts,syms,ts,mtrecord;
  ts := arg[1];
  n := Size(ts);
  #this sorting is used to construct the multiplication table
  sortedts := AsSortedList(ts);#(SortByMulTabFreqs(AsSortedList(ts)));
  MakeImmutable(sortedts);#to be on the safe side
  rcs := ProductTableOfElements(sortedts);
  mtrecord := rec(ts:=ts,
                  rows:=rcs.rows,
                  cols:=rcs.cols,
                  mt:=rcs.rows, #legacy
                  n:=n,
                  rn := [1..n], #for reusing it in loops to avoid excess objects
                  sortedts:=sortedts,
                  CONJUGACY:=false,
                  syms:=[],
                  #BLOCKING:=false
                  );
  #arg[2] is an automorphism group of ts in case it is there
  if IsBound(arg[2]) then
    if IsBound(arg[3]) then
      mtrecord.syms := NonTrivialSymmetriesOfElementIndicesThroughHom(sortedts,arg[2],arg[3]);
    else
      mtrecord.syms := NonTrivialSymmetriesOfElementIndices(sortedts,arg[2]);
    fi;
    mtrecord.CONJUGACY:=true;
  fi;
  return Objectify(MulTabType,mtrecord);
end;

InstallGlobalFunction(ElementsByIndicatorSet,
function(indset, mt)
  return List(ListBlist(mt.rn,indset),x->mt.sortedts[x]);
end);

InstallGlobalFunction(IndicatorSetOfElements,
function(elms, mt)
  local blist;
  blist := BlistList(mt.rn,[]);
  Perform(elms, function(t) blist[Position(mt.sortedts,t)]:=true;end);
  return blist;
end);
