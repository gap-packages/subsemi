################################################################################
##
## SubSemi
##
## Several properties for multiplication tables and their elements.
## Used for quickly deciding non-isomorphism.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

# in a list we count the number of occurences of distinct elements,
# then we count how many times each frequency value appeared
InstallGlobalFunction(Frequencies,
function(list)
  return Collected(List(Collected(list),p->p[2]));
end);

#ELEMENT-LEVEL INVARIANTS#######################################################

InstallGlobalFunction(Frequency,
function(mt,k) return Size(Positions(Flat(mt.mt),k));end);

InstallGlobalFunction(DiagonalFrequency,
function(mt,k) return Size(Positions(DiagonalOfMat(mt.mt),k));end);

InstallGlobalFunction(RowFrequencies,
function(mt,k) return Frequencies(mt.mt[k]);end);

InstallGlobalFunction(ColumnFrequencies,
function(mt,k) return Frequencies(List(mt.rn, i->mt.mt[i][k]));end);

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

InstallGlobalFunction(ElementProfile,
function(mt,k)
  return [Frequency(mt,k),
          DiagonalFrequency(mt,k),
          AbstractIndexPeriod(mt,k),
          ColumnFrequencies(mt,k),
          RowFrequencies(mt,k)];
end);

CheckAIP := function(mt)
  return ForAll(mt.rn,
                i->AbstractIndexPeriod(mt,i)=IndPer(mt.sortedts[i]));
end;

#TABLE-LEVEL INVARIANTS#########################################################

InstallGlobalFunction(DiagonalFrequencies,
function(mt) return Frequencies(DiagonalOfMat(mt.mt));end);

InstallGlobalFunction(MulTabProfile,
function(mt)
  return [MulTabFrequencies(mt),
          DiagonalFrequencies(mt),
          Collected(List(mt.rn,x->AbstractIndexPeriod(mt,x)))];
end);

IndPerTypes := function(T)
local types;
  types := [];
  #for t in T do AddSet(types,IndPer(t));od;
  Perform(T,function(t) AddSet(types,IndPer(t));end);
  return types;
end;


#calculate the frequencies of entries in a matrix of positive integers
InstallGlobalFunction(MulTabFrequencies,
function(mt) return Frequencies(Flat(mt.mt));end);
