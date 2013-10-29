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
InstallGlobalFunction(ProductTableOfElements,
function(M) #magma in a list
local n, mt,i,j;
  n := Size(M);
  #nxn matrix 
  mt := List([1..n], x->ListWithIdenticalEntries(n,0));
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      mt[i][j] := Position(M, M[i]*M[j]);
    od;
  od;
  return mt;
end);

#calculate the frequencies of entries in a matrix of positive integers
InstallGlobalFunction(Frequencies,
function(mt)
local l,freqs;
  freqs := ListWithIdenticalEntries(Size(mt.mt),0);
  Perform(Collected(Flat(mt.mt)),
          function(pair) freqs[pair[1]]:=pair[2];end);
  return freqs;
end);

InstallGlobalFunction(DiagonalPartition,
function(mt)
local diag;
  diag := DiagonalOfMat(mt.mt);
  return AsSortedList(List(Collected(diag),p->p[2]));
end);

InstallGlobalFunction(AbstractIndexPeriod,
function(mt,k)
local orbit, set,i,p,m;
  orbit := [k];
  set := [];
  m:=k;
  repeat
    AddSet(set,m);
    m := mt.mt[m][k];
    Add(orbit,m);
  until m in set;
  i := Position(orbit,m);
  #Display(orbit);Display(set);
  return [i,Size(orbit)-i];
end);


IndPer := function(t)
local orbit, set, u, i;
  orbit := [t];
  set := [];
  u := t;
  repeat
    AddSet(set,u);
    u := u*t;
    Add(orbit,u);
  until u in set;
  i := Position(orbit,u);
  return [i,Size(orbit)-i];
end;

IndPerTypes := function(T)
local types;
  types := [];
  #for t in T do AddSet(types,IndPer(t));od;
  Perform(T,function(t) AddSet(types,IndPer(t));end);
  return types;
end;

InstallGlobalFunction(MulTabProfile,
function(mt)
  return [Collected(Frequencies(mt)),
          DiagonalPartition(mt),
          Collected(List(mt.rn,x->AbstractIndexPeriod(mt,x)))];
end);

InstallGlobalFunction(ElementProfile,
function(mt,k) #TODO optimize
  return [Size(Positions(Flat(mt.mt),k)), #freq
          Size(Positions(DiagonalOfMat(mt.mt),k)), #diagfreq
          AbstractIndexPeriod(mt,k)];
end);


CheckAIP := function(mt)
  return ForAll(mt.rn,
                i->AbstractIndexPeriod(mt,i)=IndPer(mt.sortedts[i]));
end;

#SortByMulTabFreqs := function(M)
#  local freqs,l;
#  freqs := CalcMulTabAndFreqs(M).frequencies;
#  l := ShallowCopy(M);
#  Sort(l,function(s,t)
#    return freqs[Position(M,s)] < freqs[Position(M,t)];end);
    #return RankOfTransformation(s) < RankOfTransformation(t);end);
#  return l;
#end;

#ts - transformation semigroup, permutation group
#returns a record with the multiplication table and other extra info
InstallGlobalFunction(MulTab,
function(arg)
local n,p,mt,sortedts,syms,ts,mtrecord;
  ts := arg[1];
  n := Size(ts);
  #this sorting is used to construct the multiplication table
  sortedts := AsSortedList(ts);#(SortByMulTabFreqs(AsSortedList(ts)));
  MakeImmutable(sortedts);#to be on the safe side
  mt := ProductTableOfElements(sortedts);
  mtrecord := rec(ts:=ts,
                  mt:=mt,
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
  return mtrecord;
end);

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
