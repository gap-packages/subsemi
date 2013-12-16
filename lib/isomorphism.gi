################################################################################
##
## SubSemi
##
## Deciding isomorphism of multiplication tables,
## and based on that of semigroups.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
  local L,Aprofs,Bprofs,Bprofs2elts,used,N,BackTrack,found,Atypes,Btypes,
        element_profiles;
  #-----------------------------------------------------------------------------
  BackTrack := function()
    local k,i,candidates,X,Y;
    if Size(L)=N then found := true; return; fi;
    k := Size(L)+1;
    candidates := Difference(AsSet(Bprofs2elts[Aprofs[k]]),used);
    if IsEmpty(candidates) then return; fi;
    for i in candidates do
      Add(L,i);
      AddSet(used, i);
      #subarray of mtA, taking the upper left corner
      X := SubArray(mtA, [1..Size(L)]);
      #using the mapping we already have
      X := List(X, x->List(x,
                   function(y)if(y=0) then return 0; else return L[y];fi;
                   end));
      Y := SubArray(mtB,L);
      if X = Y then
        BackTrack();
        if found then return;fi;
      fi;
      Remove(L);
      Remove(used, Position(used,i));
    od;
  end;
  #-----------------------------------------------------------------------------
  element_profiles := function(mt) #just calculating the element->profile map
    local al;
    al:= AssociativeList();
    Perform(Indices(mt), function(x) Assign(al,x,ElementProfile(mt,x));end);
    return al;
  end;
  #-----------------------------------------------------------------------------
  #checking global invariants one by one
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
  L := [];
  BackTrack();
  if Size(L)=N then
    return PermList(L);
  else
    return fail;
  fi;
end);

#returns a mapping for the whole semigroup
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

# given a list of semigroups returns isomorphism class representatives
#IsomorphismClassesSgpsReps := function(sgps)
#local R,S;
#  R:=[];
#  for S in sgps do
#    if First(R, T->IsomorphismMulTabs(MulTab(S),MulTab(T))<>fail) = fail then
#      Add(R,S); #adding it if it is not isomorphic to any in R
#    fi;
#  od;
#  return R;
#end;

# given a list of semigroups returns isomorphism class representatives
IsomorphismClassesSgpsReps := function(sgps)
  local fullcheck,al, k,tmp, result, sgp;
  #-----------------------------------------------------------------------------
  fullcheck := function(semis)
    local R,S;
    R:=[];
    for S in semis do
      if First(R, T->IsomorphismMulTabs(MulTab(S),MulTab(T))<>fail) = fail then
        Add(R,S); #adding it if it is not isomorphic to any in R
      fi;
    od;
    return R;
  end;
  #-----------------------------------------------------------------------------
  al := AssociativeList();
  for sgp in sgps do
    Collect(al,MulTabProfile(MulTab(sgp)) ,sgp);
  od;
  #al := ReversedAssociativeList(al);
  Print("hopszi\c");
  result := [];
  for k in Keys(al) do
    tmp := al[k];
    if Size(tmp) = 1 then
      Append(result, tmp);
    else
      Append(result,fullcheck(tmp));
    fi;
  od;
  return result;
end;
