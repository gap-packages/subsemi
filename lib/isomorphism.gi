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
  local L, Aprofs,Bprofs,used,N, tab,BT,found,Atypes,Btypes;
  #-----------------------------------------------------------------------------
  BT := function()
    local k,row,col,i,candidates;
    Display(L);
    if found then return;fi;
    if Size(L)=N then found := true; return; fi;
    k := Size(L)+1;
    candidates := Difference(AsSet(Bprofs[ElementProfile(mtA,k)]),used);
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
        #Display(tab);
        BT();
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
  #checking size, then profile
  if not (Size(Rows(mtA)) = Size(Rows(mtB))) then return fail;fi;
  if not (MulTabProfile(mtA) = MulTabProfile(mtB)) then return fail;fi;
  N := Size(Rows(mtA));
  #for lining-up the elements we need the profiles TODO have this automated
  Aprofs := AssociativeList();
  Perform(Indices(mtA), function(x) Assign(Aprofs,x,ElementProfile(mtA,x));end);
  Atypes := AsSet(ValueSet(Aprofs));
  Aprofs := ReversedAssociativeList(Aprofs);
  Bprofs := AssociativeList();
  Perform(Indices(mtB), function(x) Assign(Bprofs,x,ElementProfile(mtB,x));end);
  Btypes := AsSet(ValueSet(Bprofs));
  if Atypes <> Btypes then return fail;fi;
  Bprofs := ReversedAssociativeList(Bprofs);
  #now the backtrack
  used := [];
  found := false;
  tab := [];
  L := [];
  BT();
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
