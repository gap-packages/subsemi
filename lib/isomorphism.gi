################################################################################
##
## SubSemi
##
## Deciding isomorphism of multiplication tables,
## and based on that of semigroups.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

# returns fail or a permutation
InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
  local L, # the mapping i->L[i]
        N, # the number of elements of the semigroups
        Aprofs,Bprofs, #lookup tables i->ElementProfile(i)
        Bprofs2elts, #lookup table a profile in mtB -> elements of mtB
        BackTrack, # the embedded recursive backtrack function
        used, # keeping track of what elements we used when building up L
        found; # flag for exiting from backtrack gracefully (keeping  L)
  #-----------------------------------------------------------------------------
  BackTrack := function() # receiving L and used as parameters
    local k,i,candidates,X,Y;
    if Size(L)=N then found := true; return; fi;
    k := Size(L)+1; # the index of the next element
    # getting elements of B with matching profiles, not used yet
    candidates := Difference(AsSet(Bprofs2elts[Aprofs[k]]),used);
    if IsEmpty(candidates) then return; fi;
    for i in candidates do
      Add(L,i); AddSet(used, i); # EXTEND by i
      #subarray of mtA, taking the upper left corner
      X := SubArray(mtA, [1..Size(L)]);
      #using the mapping we already have, we map part of mtA to mtB
      X := List(X, x->List(x,
                   function(y)if(y=0) then return 0; else return L[y];fi;
                   end)); # 0 indicates missing elements
      Y := SubArray(mtB,L);
      if X = Y then
        BackTrack();
        if found then return;fi;
      fi;
      Remove(L); Remove(used, Position(used,i)); #UNDO extending
    od;
  end;
  #checking global invariants one by one
  if Size(Rows(mtA)) <> Size(Rows(mtB)) then return fail;fi;
  if DiagonalFrequencies(mtA) <> DiagonalFrequencies(mtB) then return fail;fi;
  if IdempotentDiagonalFrequencies(mtA) <> IdempotentDiagonalFrequencies(mtB) then return fail;fi;
  if MulTabFrequencies(mtA) <> MulTabFrequencies(mtB) then return fail;fi;
  if IdempotentFrequencies(mtA) <> IdempotentFrequencies(mtB) then return fail;fi;
  if IndexPeriodTypeFrequencies(mtA) <> IndexPeriodTypeFrequencies(mtB) then
    return fail;
  fi;
  #for lining-up the elements we need the profiles
  Aprofs := List(Indices(mtA), x->ElementProfile(mtA,x));
  Bprofs := List(Indices(mtB), x->ElementProfile(mtB,x));
  #just another quick invariant
  if AsSet(Aprofs) <> AsSet(Bprofs) then return fail;fi;
  Bprofs2elts := AssociativeList();
  Perform([1..Size(Bprofs)], function(x) Collect(Bprofs2elts, Bprofs[x], x);end);
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

InstallGlobalFunction(IsIsomorphicMulTab,
function(mtS,mtT)
  if Size(mtS) = Size(mtT) 
     and IsomorphismMulTabs(mtS, mtT)<> fail then
    return true;
  else
    return false;
  fi;
end);

InstallGlobalFunction(IsIsomorphicSemigroupByMulTabs,
function(S,T)
  if Size(S) = Size(T) 
     and IsomorphismMulTabs(MulTab(S), MulTab(T))<> fail then
    return true;
  else
    return false;
  fi;
end);

InstallGlobalFunction(SgpIsomorphismClasses,
function(sgps)
  local mts, classes, S, mtS, pos;
  mts := [];
  classes := [];
  for S in sgps do
    mtS := MulTab(S);
    pos := First([1..Size(classes)],
                 x -> IsIsomorphicMulTab(mts[x],mtS));
    if pos = fail then
      Add(classes, [S]);
      Add(mts, mtS);
    else
      Add(classes[pos],S);
    fi;
  od;
  return classes;
end);


#returns a mapping for the whole semigroup
InstallGlobalFunction(IsomorphismSemigroupsByMulTabs,
function(S,T)
  local mtS, mtT, perm,source, image, mappingfunc;
  if Size(S) <> Size(T) then return fail; fi;
  if NrIdempotents(S) <> NrIdempotents(T) then return fail; fi;
  #calculating multiplication tables
  mtS := MulTab(S);
  mtT := MulTab(T);
  perm := IsomorphismMulTabs(mtS, mtT);
  if perm = fail then return fail; fi; #not isomorphic
  #if they are isomorphic then we construct the mapping
  source := SortedElements(mtS);
  image := List(ListPerm(perm, Size(T)), x->SortedElements(mtT)[x]);
  mappingfunc := function(s) return image[Position(source,s)];end;
  return MappingByFunction(S,T,mappingfunc);
end);

# given a list of semigroups returns isomorphism class representatives
IsomorphismClassesSgpsReps := function(sgps)
  local fullcheck,al, k,tmp, result, sgp;
  #-----------------------------------------------------------------------------
  fullcheck := function(semis) # tried to improve this by precalc mts, no good
    local reps,S;
    reps:=[];
    for S in semis do
      if First(reps,T->IsomorphismMulTabs(MulTab(S),MulTab(T))<>fail)=fail then
        Add(reps,S); #adding it if it is not isomorphic to any sgp in reps
      fi;
    od;
    return reps;
  end;
  #-----------------------------------------------------------------------------
  #we want to prefilter by table profiles
  al := AssociativeList();
  for sgp in sgps do
    Collect(al,MulTabProfile(MulTab(sgp)) ,sgp);
  od;
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
