################################################################################
##
## SubSemi
##
## Multiplication table for magmas
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#based on the order of the magma elements in list,
#indices are assigned to elements
#mulitplication table and table of frequencies calculated
InstallGlobalFunction(MagmaProducts,
function(M) #magma in a list
local n,freqs, mt,i,j,p;
  n := Size(M);
  freqs := List([1..n], x -> 0);
  mt := List([1..n], x->ListWithIdenticalEntries(n,0));
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      p := Position(M, M[i]*M[j]);
      mt[i][j] := p;
      freqs[p] := freqs[p] + 1;
    od;
  od;
  return rec(multiplicationtable:=mt,
             frequencies:=freqs);
end);

SortByMulTabFreqs := function(M)
  local freqs,l;
  freqs := CalcMulTabAndFreqs(M).frequencies;
  l := ShallowCopy(M);
  Sort(l,function(s,t)
    return freqs[Position(M,s)] < freqs[Position(M,t)];end);
    #return RankOfTransformation(s) < RankOfTransformation(t);end);
  return l;
end;

#ts - transformation semigroup, permutation group
#returns a record with the multiplication table and other extra info
MulTab := function(arg)
local n,freqs,p,i,j,mt,sortedts,syms,ts,mtrecord;
  ts := arg[1];
  n := Size(ts);
  #this sorting is used to construct the multiplication table
  sortedts := AsSortedList(ts);#(SortByMulTabFreqs(AsSortedList(ts)));
  #we store the table and also the frequencies of the elements
  freqs := List([1..n], x -> 0);
  mt := List([1..n], x->ListWithIdenticalEntries(n,0));
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      p := Position(sortedts, sortedts[i]*sortedts[j]);
      mt[i][j] := p;
      freqs[p] := freqs[p] + 1;
    od;
  od;
  mtrecord := rec(ts:=ts,
                  freqs:=freqs,
                  mt:=mt,
                  n:=n,
                  rn := [1..n], #for reusing it in loops to avoid excess objects
                  sortedts:=sortedts,
                  CONJUGACY:=false,
                  syms:=[],
                  BLOCKING:=false
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
  return mtrecord;
end;

#returns the diagonal elements of a multiplication  table in a list
MulTabDiagonal := function(mt)
  return List([1..mt.n], x -> mt.mt[x][x]);
end;
