################################################################################
##
## SubSemi
##
## Several properties for multiplication tables and their elements.
## Used for quickly deciding non-isomorphism.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

# the number of occurences of each distinct element in a list
# in ascending order
InstallGlobalFunction(Frequencies,
function(list)
  return AsSortedList(List(Collected(list),p->p[2]));
end);

#calculate the frequencies of entries in a matrix of positive integers
#InstallGlobalFunction(Frequencies,
#function(mt)
#local l,freqs;
#  freqs := ListWithIdenticalEntries(Size(mt.mt),0);
#  Perform(Collected(Flat(mt.mt)),
#          function(pair) freqs[pair[1]]:=pair[2];end);
#  return freqs;
#end);

InstallGlobalFunction(DiagonalPartition,
function(mt)
local diag;
  diag := DiagonalOfMat(mt.mt);
  return AsSortedList(List(Collected(diag),p->p[2]));
end);

InstallGlobalFunction(RowPartition,
function(mt,k)
local row;
  row := mt.mt[k];
  return AsSortedList(List(Collected(row),p->p[2]));
end);

InstallGlobalFunction(ColumnPartition,
function(mt,k)
local column;
  column := List(mt.rn, i->mt.mt[i][k]);
  return AsSortedList(List(Collected(column),p->p[2]));
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
          AbstractIndexPeriod(mt,k),
          ColumnPartition(mt,k),
          RowPartition(mt,k)];
end);


CheckAIP := function(mt)
  return ForAll(mt.rn,
                i->AbstractIndexPeriod(mt,i)=IndPer(mt.sortedts[i]));
end;
