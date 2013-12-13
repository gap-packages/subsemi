################################################################################
##
## SubSemi
##
## Deciding isomorphism of multiplication tables.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
  local L, Aprofs,Bprofs,Bprofs2elts,used,N, tab,BackTrack,found,Atypes,Btypes, element_profiles;
  #-----------------------------------------------------------------------------
  BackTrack := function()
    local k,row,col,i,candidates,X,Y;
    if Size(L)=N then found := true; return; fi;
    k := Size(L)+1;
    candidates := Difference(AsSet(Bprofs2elts[Aprofs[k]]),used);
    if IsEmpty(candidates) then return; fi;
    for i in candidates do
      Add(L,i);
      AddSet(used, i);
      X := SubArray(mtA, [1..Size(L)]);
      X := List(X, x->List(x,function(y)if(y=0) then return 0; else return L[y];fi;end));
      Y := SubArray(mtB, L);
      if X = Y then
        BackTrack();
        if found then return;fi;
      fi;
      Remove(L);
      Remove(used, Position(used,i));
    od;
  end;
  #-----------------------------------------------------------------------------
  element_profiles := function(mt)
    local al;
    al:= AssociativeList();
    Perform(Indices(mt), function(x) Assign(al,x,ElementProfile(mt,x));end);
    return al;
  end;
  #-----------------------------------------------------------------------------
  #checking global invariants on by one
  if Size(Rows(mtA)) <> Size(Rows(mtB)) then return fail;fi;
  if MulTabFrequencies(mtA) <> MulTabFrequencies(mtB) then return fail;fi;
  if DiagonalFrequencies(mtA) <> DiagonalFrequencies(mtB) then return fail;fi;
  if IndexPeriodTypeFrequencies(mtA) <> IndexPeriodTypeFrequencies(mtB) then
    return fail;
  fi;
  #for lining-up the elements we need the profiles
  Aprofs := element_profiles(mtA);
  Atypes := AsSet(ValueSet(Aprofs));
  Bprofs := element_profiles(mtB);
  Btypes := AsSet(ValueSet(Bprofs));
  if Atypes <> Btypes then return fail;fi; #just another quick invariant
  Bprofs2elts := ReversedAssociativeList(Bprofs);
  #now the backtrack
  N := Size(Rows(mtA));
  used := [];
  found := false;
  tab := [];
  L := [];
  BackTrack();
  if Size(L)=N then 
    return PermList(L); 
  else
    return fail;
  fi;
end);

InstallGlobalFunction(IsomorphismSemigroups,
function(S,T)
  local mtS, mtT, perm,source, image, mappingfunc;
  if Size(S) <> Size(T) then return fail; fi;
  #calculating multiplication tables
  mtS := MulTab(S);
  mtT := MulTab(T);
  perm := IsomorphismMulTabs(mtS, mtT);
  if perm = fail then return fail; fi;
  source := SortedElements(mtS);
  image := List(ListPerm(perm, Size(T)), x->SortedElements(mtT)[x]);
  mappingfunc := function(s) return image[Position(source,s)];end;
  return MappingByFunction(S,T,mappingfunc);
end);


IsomorphicSgps := function(sgps)
local R,S;
  R:=[];
  for S in sgps do
    if First(R, T->IsomorphismMulTabs(MulTab(S),MulTab(T))<>fail) = fail then
      Add(R,S);
    fi;
  od;
  return R;
end;

