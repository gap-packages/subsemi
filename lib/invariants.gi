################################################################################
##
## SubSemi - GAP package for enumearting subsemigroups
##
## Several derived properties for multiplication tables and their elements.
## Used as invariants in embeddings and isomorphisms.
##
## Copyright (C) 2013-2016  Attila Egri-Nagy
##

### GENERIC FUNCTIONS ##########################################################
# in a list we count the number of occurences of distinct elements,
# then we count how many times each frequency value appeared
# in other words, keeping only the frequency values of a frequency distribution
# in a sorted list
InstallGlobalFunction(Frequencies,
function(list)
  return Collected(List(Collected(list),p->p[2]));
end);

#ELEMENT-LEVEL INVARIANTS#######################################################
# M - square matrix of position integers representing a multiplication table
# k - an element of the multiplication table

# the number of occurences of element k
InstallGlobalFunction(Frequency,
function(M,k) return Size(Positions(Flat(M),k));end);

# the number of occurences of k in the diagonal of the matrix
InstallGlobalFunction(DiagonalFrequency,
function(M,k) return Size(Positions(DiagonalOfMat(M),k));end);

# frequency distribution of elements in the row of k
InstallGlobalFunction(RowFrequencies,
function(M,k) return Frequencies(M[k]);end);

# frequency distribution of elements in the column of k
InstallGlobalFunction(ColumnFrequencies,
function(M,k) return Frequencies(List([1..Size(M)], x -> M[x][k]));end);

# index period of an element calculated in a multiplication table,
# the semigroup analogue of the order of an element
InstallGlobalFunction(AbstractIndexPeriod,
function(M,k)
local orbit, set,i,p,m;
  orbit := [k];
  set := [];
  m:=k;
  repeat
    AddSet(set,m);
    m := M[m][k];
    Add(orbit,m);
  until m in set;
  i := Position(orbit,m);
  return [i,Size(orbit)-i];
end);

# comprehensive profile of a multiplication table element
InstallGlobalFunction(ElementProfile,
function(M,k)
  return [Frequency(M,k),
          DiagonalFrequency(M,k),
          AbstractIndexPeriod(M,k),
          ColumnFrequencies(M,k),
          RowFrequencies(M,k)];
end);

#TABLE-LEVEL INVARIANTS#########################################################

InstallGlobalFunction(DiagonalFrequencies,
function(mt) return Frequencies(DiagonalOfMat(Rows(mt)));end);

InstallGlobalFunction(IndexPeriodTypeFrequencies,
function(mt)
  return Collected(List(Indices(mt),x->AbstractIndexPeriod(Rows(mt),x)));
end);

InstallGlobalFunction(ElementProfileTypes,
function(mt) return Set(Indices(mt), x -> ElementProfile(mt,x));
end);

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
