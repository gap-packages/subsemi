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
  #nxn matrix (intialized with invalid value zero)
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
# sortedelements - a sorted list of multiplicative elements
# G - a group of automorphisms of the multiplicative elements
# name - fail if no need for naming (search algorithm will not dump)
# hom - a Rees factor homomorphism
InstallGlobalFunction(CreateMulTab,
function(sortedelements, G, name, hom)
local mt,inds;
  mt := Objectify(MulTabType, rec());
  SetRows(mt,ProductTableOfElements(sortedelements));
  SetSortedElements(mt,sortedelements);
  inds := [1..Size(sortedelements)];
  MakeImmutable(inds);
  SetIndices(mt,inds);
  if hom = fail then
    SetSymmetries(mt,
            NonTrivialSymmetriesOfElementIndices(SortedElements(mt),G));
  else
    SetSymmetries(mt,
            NonTrivialSymmetriesOfElementIndicesThroughHom(SortedElements(mt),
                    G,
                    hom));
  fi;
  if  name <> fail then SetOriginalName(mt,name);fi;
  return mt;
end);

InstallOtherMethod(MulTab,"for closed ordered list of multiplicative elements",
[IsSortedList],
function(l)
  return CreateMulTab(l, Group(()), fail, fail);
end);

InstallMethod(MulTab, "for a semigroup",
[IsSemigroup],
function(S)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), Group(()),Name(S),fail);
  else
    return CreateMulTab(AsSortedList(S), Group(()),fail,fail);
  fi;
end);

InstallOtherMethod(MulTab, "for a semigroup and an automorphism  group",
[IsSemigroup,IsGroup],
function(S,G)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), G, Name(S),fail);
  else
    return CreateMulTab(AsSortedList(S), G,fail,fail);
  fi;
end);

InstallOtherMethod(MulTab, "for a semigroup and an automorphism  group",
[IsSemigroup,IsGroup,IsMapping],
function(S,G,hom)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), G, Name(S),hom);
  else
    return CreateMulTab(AsSortedList(S), G,fail,hom);
  fi;
end);

InstallMethod(Columns,"for multab",
        [IsMulTab],
function(mt)
  return TransposedMat(Rows(mt));
end);

InstallGlobalFunction(ConjugacyClassOfSet,
function(indset,mt)
  return Unique(List(Symmetries(mt), g->OnFiniteSet(indset,g)));
end);

InstallGlobalFunction(ConjugacyClassRep,
function(indset,mt)
local C;
  C := ConjugacyClassOfSet(indset,mt);
  Sort(C); #sorting in place instead of copy by AsSortedList
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

#experimental
InstallMethod(EquivalentGenerators,"for a multab",
        [IsMulTab],
function(mt)
local al,i;
  al := AssociativeList();
  for i in Indices(mt) do Assign(al,i,SgpInMulTab([i],mt));od;
  al := ReversedAssociativeList(al);
  return Filtered(ValueSet(al), x->Length(x)>1);
end);

InstallGlobalFunction(RemoveEquivalentGenerators,
function(indset,mt)
  local class, flag, i, set;
  set := ShallowCopy(indset);
  for class in EquivalentGenerators(mt) do #keep max one from each equiv class
    flag := false;
    for i in class  do
      if set[i] then
        if flag then set[i] := false; else flag := true;fi;
      fi;
    od;
  od;
  return set;
end);


InstallMethod(GlobalTables,"for multab",
        [IsMulTab],
function(mt)
  local i,j, boolfunctab,val, L;
  boolfunctab := List(Indices(mt),x -> []);
  for i in Indices(mt) do
    for j in Indices(mt) do
      val := Rows(mt)[i][j];
      if (not val = i) and (not val = j) then
        AddSet(boolfunctab[val],AsSortedList([i,j]));
      fi;
    od;
  od;
  #processing to make it more compact
  #this magically puts diagonal closure there  easily as it is the first entry int the second part, cool stuff
  L := List(Indices(mt),x -> []);
  for i in Indices(mt) do
    for j in AsSet(List(boolfunctab[i], x->x[1])) do
      Add(L[i], [j, List(Filtered(boolfunctab[i],x->x[1]=j),y->y[2])]);
    od;
  od;
  return L;
end);

#backward thinking
InstallMethod(LocalTables,"for multab", [IsMulTab],
function(mt)
  local i,j, tab,val, vals,row,col;
  tab := List(Indices(mt),x -> []);
  for i in Indices(mt) do
    row := Rows(mt)[i];
    col := Columns(mt)[i];
    vals := Unique(Union(row,col));
    for val in vals do
      Add(tab[i],[val,Unique(Union(Positions(row,val),Positions(col,val)))]);
    od;
  od;
  return tab;
end);

InstallMethod(FullSet,"for multab", [IsMulTab],
function(mt)
  return BlistList(Indices(mt),Indices(mt));
end);

InstallMethod(EmptySet,"for multab", [IsMulTab],
function(mt)
  return BlistList(Indices(mt),[]);
end);

#it is not sorted or anything
#0 indicate missing element, of course the subarray may not be closed
InstallGlobalFunction(SubArray,
function(mt, L)
  local sa,i,j;
  sa := [];
  for i in L do
    Add(sa,List(L,
            function(j) if Rows(mt)[i][j] in L then 
                          return Rows(mt)[i][j]; 
                        else 
                          return 0;fi;end));
  od;
  return sa;                  
end);

#just for convenience, TODO: include it properly
SmallGenSetSgpFromIndicatorSet := function(indset,mt)
  return SmallGeneratingSet(Semigroup(
                 ElementsByIndicatorSet(indset,SortedElements(mt))
                 ));
end;

#CONVENIENCE
InstallOtherMethod(ElementsByIndicatorSet, "for boolean list and multab",
        [IsList, IsMulTab],
function(indset, mt)
  return ElementsByIndicatorSet(indset, SortedElements(mt));
end);

InstallOtherMethod(IndicatorSetOfElements,
        "for a list of elements and multab",
        [IsList,IsMulTab],
function(elms, mt)
  return IndicatorSetOfElements(elms, SortedElements(mt));
end);

InstallOtherMethod(ReCodeIndicatorSet,
        "for a boolean list, a source and destiantion multabs",
        [IsList,IsMulTab,IsMulTab],
function(indset,srcmt, destmt)
  return IndicatorSetOfElements(ElementsByIndicatorSet(indset,srcmt),destmt);
end);
