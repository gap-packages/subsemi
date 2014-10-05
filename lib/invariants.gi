################################################################################
##
## SubSemi
##
## Several derived properties for multiplication tables and their elements.
## Used for quickly deciding non-isomorphism.
##
## Copyright (C) 2013-14  Attila Egri-Nagy
##

# in a list we count the number of occurences of distinct elements,
# then we count how many times each frequency value appeared
# in other words, keeping only the frequency values of a frequency distribution
InstallGlobalFunction(Frequencies,
function(list)
  return Collected(List(Collected(list),p->p[2]));
end);

#ELEMENT-LEVEL INVARIANTS#######################################################

InstallGlobalFunction(Frequency,
function(mt,k) return Size(Positions(Flat(Rows(mt)),k));end);

InstallGlobalFunction(DiagonalFrequency,
function(mt,k) return Size(Positions(DiagonalOfMat(Rows(mt)),k));end);

InstallGlobalFunction(RowFrequencies,
function(mt,k) return Frequencies(Rows(mt)[k]);end);

InstallGlobalFunction(ColumnFrequencies,
function(mt,k) return Frequencies(Columns(mt)[k]);end);

InstallGlobalFunction(AbstractIndexPeriod,
function(rows,k)
local orbit, set,i,p,m;
  orbit := [k];
  set := [];
  m:=k;
  repeat
    AddSet(set,m);
    m := rows[m][k];
    Add(orbit,m);
  until m in set;
  i := Position(orbit,m);
  return [i,Size(orbit)-i];
end);

InstallGlobalFunction(ElementProfile,
function(mt,k)
  return [Frequency(mt,k),
          DiagonalFrequency(mt,k),
          AbstractIndexPeriod(Rows(mt),k),
          ColumnFrequencies(mt,k),
          RowFrequencies(mt,k)];
end);

#TABLE-LEVEL INVARIANTS#########################################################

InstallGlobalFunction(DiagonalFrequencies,
function(mt) return Frequencies(DiagonalOfMat(Rows(mt)));end);

InstallGlobalFunction(IndexPeriodTypeFrequencies,
function(mt)
  return Collected(List(Indices(mt),x->AbstractIndexPeriod(Rows(mt),x)));
end);

InstallGlobalFunction(ElementProfileLookup,
function(mt)
local al;
  al:= AssociativeList();
  Perform(Indices(mt), function(x) Assign(al,x,ElementProfile(mt,x));end);
  return al;
end);

InstallGlobalFunction(ElementProfileTypes,
function(mt) return ValueSet(ElementProfileLookup(mt));end);

InstallGlobalFunction(MulTabProfile,
function(mt)
  return [MulTabFrequencies(mt),
          DiagonalFrequencies(mt),
          IndexPeriodTypeFrequencies(mt),
          ElementProfileTypes(mt)];
end);

#calculate the frequencies of entries in a matrix of positive integers
InstallGlobalFunction(MulTabFrequencies,
function(mt) return Frequencies(Flat(Rows(mt)));end);

IdempotentsInMulTab := function(mt)
  return Filtered(Indices(mt), x-> Rows(mt)[x][x]=x);
end;

InstallGlobalFunction(IdempotentDiagonalFrequencies,
function(mt) 
  local idempotents;
  idempotents := IdempotentsInMulTab(mt);
  return Frequencies(Filtered(DiagonalOfMat(Rows(mt)), x->x in idempotents));
end);

InstallGlobalFunction(IdempotentFrequencies,
function(mt) 
  local idempotents;
  idempotents := IdempotentsInMulTab(mt);
  return Frequencies(Filtered(Flat(Rows(mt)), x->x in idempotents));
end);

NumOfProfileClasses := function(mt)
  local al, bl;
  al := AssociativeList();
  Perform(Indices(mt), function(x)Assign(al, x, ElementProfile(mt,x));end);
  bl := ReversedAssociativeList(al);
  return Size(Keys(bl));
end;
