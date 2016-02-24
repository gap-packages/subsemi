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

# frequency distribution of elements in the diagonal (without the elements)
InstallGlobalFunction(DiagonalFrequencies,
function(M) return Frequencies(DiagonalOfMat(M));end);

# frequency distribution of index-period types
InstallGlobalFunction(IndexPeriodTypeFrequencies,
function(M)
  return Collected(List([1..Size(M)],x->AbstractIndexPeriod(M,x)));
end);

#the set of all element profiles
InstallGlobalFunction(ElementProfileTypes,
function(M) return Set([1..Size(M)], x -> ElementProfile(M,x)); end);

InstallGlobalFunction(MulTabProfile,
function(M)
  return [MulTabFrequencies(M),
          DiagonalFrequencies(M),
          IndexPeriodTypeFrequencies(M),
          ElementProfileTypes(M)];
end);

#calculate the frequencies of entries in a matrix of positive integers
InstallGlobalFunction(MulTabFrequencies,
function(M) return Frequencies(Flat(M));end);

IdempotentsInMulTab := function(M)
  return Filtered([1..Size(M)], x-> M[x][x]=x);
end;

InstallGlobalFunction(IdempotentDiagonalFrequencies,
function(M)
  local idempotents;
  idempotents := IdempotentsInMulTab(M);
  return Frequencies(Filtered(DiagonalOfMat(M), x -> x in idempotents));
end);

InstallGlobalFunction(IdempotentFrequencies,
function(M)
  local idempotents;
  idempotents := IdempotentsInMulTab(M);
  return Frequencies(Filtered(Flat(M), x -> x in idempotents));
end);
