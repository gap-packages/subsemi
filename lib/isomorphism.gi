################################################################################
##
## SubSemi
##
## Deciding embedding and isomorphism of multiplication tables,
## and based on that of semigroups.
##
## Copyright (C) 2013-14  Attila Egri-Nagy
##

# A backtrack algorithm to build a map from multiplication table A (mtA) to
# multiplication table B (mtB). The map is built in L, i->L[i].
# mtA, mtB: matrices or MulTab objects
# Aprofs, Bprofs: for each element we associate a profile object (provided
# by the caller), and this profile information is used for restricting search
SubTableMatchingSearch := function(mtA, mtB, Aprofs, Bprofs, firstsolution)
  local L, # the mapping i->L[i]
        N, # the number of elements of the semigroups
        Aprofs2elts, #lookup table a profile in mtA -> elements of mtA
        Bprofs2elts, #lookup table a profile in mtB -> elements of mtB
        BackTrack, # the embedded recursive backtrack function
        used, # keeping track of what elements we used when building up L
        solutions; # cumulative collection of solutions
  #-----------------------------------------------------------------------------
  BackTrack := function() # parameters: L, used
    local k,i,candidates,X,Y;
    # when a solution is found
    if Size(L)=N then
      Add(solutions, ShallowCopy(L));
      return;
    fi;
    k := Size(L)+1; # the index of the next element
    # getting elements of B with profiles matching profile of A, not used yet
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
        if firstsolution and not IsEmpty(solutions) then return; fi;
      fi;
      Remove(L); Remove(used, Position(used,i)); #UNDO extending
    od;
  end;
  #-----------------------------------------------------------------------------
  #checking for enough profile types
  Aprofs2elts := AssociativeList();
  Perform([1..Size(Aprofs)], function(x) Collect(Aprofs2elts, Aprofs[x], x);end);
  Bprofs2elts := AssociativeList();
  Perform([1..Size(Bprofs)], function(x) Collect(Bprofs2elts, Bprofs[x], x);end);
  if not ForAll(Keys(Aprofs2elts),
             x-> (Bprofs2elts[x] <> fail)
             and Size(Aprofs2elts[x]) <= Size(Bprofs2elts[x])) then
    return fail; #not enough elements of some type to represent A
  fi;
  # figuring out target size
  if IsMulTab(mtA) then
    N := Size(Rows(mtA));
  else
    N := Size(mtA);
  fi;
  #now the backtrack
  used := []; L := []; solutions := [];
  BackTrack();
  return solutions;
end;
MakeReadOnlyGlobal("SubTableMatchingSearch");

# trying the represent semigroup (multiplication table) mA as a subtable of mB
# mA,mB: positive integer matrices representing multiplication tables
InstallGlobalFunction(EmbedAbstractSemigroup,
function(mA,mB)
  local f;
  #for embeddings we only use the index-period information
  f := m -> List([1..Size(m)], x->AbstractIndexPeriod(m,x));
  return SubTableMatchingSearch(mA,mB,f(mA),f(mB),false);
end);

# mtA, mtB: MulTab objects
# returns a permutation of the element indices of mtA if isomorphism
# can be established, otherwise returns fail
InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
  local Aprofs,Bprofs, #lookup arrays i->ElementProfile(i)
        map; #the resulting map from the search
  #-----------------------------------------------------------------------------
  #checking global invariants one by one
  if not PotentiallyIsomorphicMulTabs(mtA,mtB) then return false; fi;
  #for lining-up the elements we need the profiles
  Aprofs := List(Indices(mtA), x->ElementProfile(mtA,x));
  Bprofs := List(Indices(mtB), x->ElementProfile(mtB,x));
  #just another quick invariant
  if AsSet(Aprofs) <> AsSet(Bprofs) then return fail;fi;
  map := SubTableMatchingSearch(mtA,mtB,Aprofs,Bprofs,true);
  if map = fail then
    return fail;
  else
    return PermList(map[1]);
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

#returns a mapping for the whole semigroup
InstallGlobalFunction(IsomorphismSemigroupsByMulTabs,
function(S,T)
  local mtS, mtT, perm,source, image, mappingfunc;
  if Size(S) <> Size(T)
     or NrIdempotents(S) <> NrIdempotents(T)
     or NrRClasses(S) <> NrRClasses(T)
     or NrDClasses(S) <> NrDClasses(T)
     or NrLClasses(S) <> NrLClasses(T) then
    return fail;
  fi;
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
