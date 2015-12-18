################################################################################
##
## SubSemi
##
## Multiplication table for magmas
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

#mulitplication table based on the order of the magma elements in a list,
InstallGlobalFunction(ProductTableOfElements,
function(M) #magma in a list
local n, mat,i,j;
  n := Size(M);
  #nxn matrix (initialized with invalid value zero)
  mat := NullMat(n,n);
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      mat[i][j] := Position(M, M[i]*M[j]);
    od;
  od;
  return mat;
end);

### CONSTRUCTORS ###############################################################
# elts - a list of multiplicative elements, the order defines indices
# G - a group of automorphisms of the multiplicative elements
# name - fail if no need for naming (search algorithm will not dump)
# hom - a Rees factor homomorphism
# isanti - flag to make anti multiplication table
InstallGlobalFunction(CreateMulTab,
function(elts, G, name, hom, isanti)
local mt,inds;
  mt := Objectify(MulTabType, rec());
  SetIsAnti(mt,isanti);
  if isanti then
    SetRows(mt,TransposedMat(ProductTableOfElements(elts)));
  else
    SetRows(mt,ProductTableOfElements(elts));
  fi;
  SetElts(mt,elts);
  inds := [1..Size(elts)];
  MakeImmutable(inds);
  SetIndices(mt,inds);
  if hom = fail then
    #conjugations expressed as permutations of the set elements (indices of)
    if Size(G) > 1 then
      SetSymmetries(mt,Set(G,
              g->AsPermutation(TransformationOp(g,Elts(mt),\^))));
    else
      SetSymmetries(mt, [()]);
    fi;
  else
    #same as above, except
    SetSymmetries(mt,Set(G,
            g->AsPermutation(TransformationOp(g,Elts(mt),
                    function(p,t)
                      return Image(hom,PreImagesRepresentative(hom,p)^t);
                    end))));
  fi;
  if  name <> fail then SetOriginalName(mt,name);fi;
  return mt;
end);

# allowed copying: straight -> straight
#                  straight -> anti #TODO think about this
InstallGlobalFunction(CopyMulTab,
function(multab, isanti)
local mt;
  mt := Objectify(MulTabType, rec());
  if IsAnti(multab) and isanti then return fail;fi;
  SetIsAnti(mt,isanti);
  if isanti then
    SetRows(mt,Columns(multab));
  else
    SetRows(mt,Rows(multab));
  fi;
  SetElts(mt,Elts(multab));
  SetIndices(mt,Indices(multab));
  SetSymmetries(mt, Symmetries(multab)); # TODO is this correct? symmetries are the same?
  if HasOriginalName(multab) then
    SetOriginalName(mt,OriginalName(multab));
  fi;
  return mt;
end);

InstallOtherMethod(MulTab,"for closed ordered list of multiplicative elements",
[IsSortedList],
function(l)
  return CreateMulTab(l, Group(()), fail, fail,false);
end);

InstallMethod(MulTab, "for a semigroup",
[IsSemigroup],
function(S)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), Group(()),Name(S),fail,false);
  else
    return CreateMulTab(AsSortedList(S), Group(()),fail,fail,false);
  fi;
end);

InstallMethod(AntiMulTab, "for a semigroup",
[IsSemigroup],
function(S)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), Group(()), Name(S),fail,true);
  else
    return CreateMulTab(AsSortedList(S), Group(()),fail,fail,true);
  fi;
end);


InstallOtherMethod(MulTab, "for a semigroup and an automorphism  group",
[IsSemigroup,IsGroup],
function(S,G)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), G, Name(S),fail,false);
  else
    return CreateMulTab(AsSortedList(S), G,fail,fail,false);
  fi;
end);

InstallOtherMethod(MulTab,
        "for a semigroup an automorphism  group, and a homomorphism",
        [IsSemigroup,IsGroup,IsMapping],
function(S,G,hom)
  if HasName(S) then
    return CreateMulTab(AsSortedList(S), G, Name(S),hom,false);
  else
    return CreateMulTab(AsSortedList(S), G,fail,hom,false);
  fi;
end);

InstallMethod(SymmetryGroup,"for multab", [IsMulTab],
function(mt)
  if Size(Symmetries(mt)) = 1 then return Group(()); fi;
  return Group(SmallGeneratingSet(Group(Symmetries(mt))));
end);

InstallMethod(Columns,"for multab", [IsMulTab],
function(mt) return TransposedMat(Rows(mt)); end);

### DISPLAY ####################################################################
InstallOtherMethod(Size, "for a multab", [IsMulTab],
function(mt) return Size(Indices(mt)); end);

InstallMethod(ViewObj, "for a multab", [IsMulTab],
function(mt)
  local str;
  if IsAnti(mt) then str := "<anti-"; else str := "<"; fi;
  if HasOriginalName(mt) then
    Print(str,"multiplication table of ",OriginalName(mt),">");
  else
    Print(str,"multiplication table of ",Size(mt)," elements>");
  fi;
end);

InstallGlobalFunction(GeneratorReps,
function(set, mt)
  return Set(Classify(set, x->SgpInMulTab([x],mt), \=),
             y -> y[1]);
end);



InstallMethod(GlobalTables, "for multab", [IsMulTab],
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

#local table: the positions of elements in a given ith column and row
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

# S,S^1,S^2,...,S^n=S^{n+1}
InstallMethod(ConvergingSets,"for multab and list",
        [IsMulTab,IsList],
function(mt,l)
  local tr,img;
  tr := [];
  img := l;
  repeat
    Add(tr, img, 1);
    img := AsSet(Concatenation(
                   List(Columns(mt){tr[1]}, x->AsSet(x{tr[1]}))));
  until img=tr[1];
  return Reversed(tr);
end);

InstallOtherMethod(ConvergingSets,"for multab", [IsMulTab],
function(mt)
  return ConvergingSets(mt,Indices(mt));
end);

InstallGlobalFunction(NilpotencyDegreeByMulTabs,
function (sgp)
  local sets;
  sets := ConvergingSets(MulTab(sgp));
  if Size( sets[Size(sets)]) = 1  then
    return Size(sets);
  else
    return fail;
  fi;
end);

# returns the subarray of the multiplication table mt spanned by
# elements in L (positive integers as indices)
# the order of the elements in L kept
# 0 indicate any product outside L (since subarrays may not be closed)
# mt can be just a matrix, or a MulTab object
InstallGlobalFunction(SubArray,
function(mt, L)
  local sa,i,j,tab;
  if IsMulTab(mt) then
    tab := Rows(mt);
  else
    tab := mt;
  fi;
  sa := [];
  for i in L do
    Add(sa,List(L,
            function(j) if tab[i][j] in L then
                          return tab[i][j];
                        else
                          return 0;fi;end));
  od;
  return sa;
end);

#just for convenience, TODO: include it properly
SmallGenSetSgpFromIndicatorFunction := function(indset,mt)
  return SmallGeneratingSet(Semigroup(
                 SetByIndicatorFunction(indset,Elts(mt))
                 ));
end;

#CONVENIENCE
InstallOtherMethod(SetByIndicatorFunction, "for boolean list and multab",
        [IsList, IsMulTab],
function(indset, mt)
  return SetByIndicatorFunction(indset, Elts(mt));
end);

InstallOtherMethod(IndicatorFunction,
        "for a list of elements and multab",
        [IsList,IsMulTab],
function(elms, mt)
  return IndicatorFunction(elms, Elts(mt));
end);

InstallOtherMethod(RecodeIndicatorFunction,
        "for a boolean list, a source and destination multabs",
        [IsList,IsMulTab,IsMulTab],
function(indset,srcmt, destmt)
  return IndicatorFunction(SetByIndicatorFunction(indset,srcmt),destmt);
end);
