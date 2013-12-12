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
    local k,row,col,i,candidates;
    if found then return;fi;
    if Size(L)=N then found := true; return; fi;
    k := Size(L)+1;
    candidates := Difference(AsSet(Bprofs2elts[Aprofs[k]]),used);
    if IsEmpty(candidates) then return; fi;
    for i in candidates do
      Add(L,i);
      AddSet(used, i);
      #create the extension
      col := List([1..k-1], x-> Rows(mtB)[L[x]][k]);
      row := List([1..k], x-> Rows(mtB)[k][L[x]]);
      # check it against the existing one
      if ForAll([1..k-1], x-> Rows(mtA)[x][k] = col[x])
         and ForAll([1..k], x-> Rows(mtA)[k][x] = row[x]) then
        #glue
        Perform([1..k-1], function(x)Add(tab[x],col[x]);end);
        Add(tab,row);
        BackTrack();
        if found then return;fi;
        #unglue
        Perform([1..k-1], function(x)Remove(tab[x]);end);
        Remove(tab);
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
