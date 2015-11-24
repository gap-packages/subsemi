################################################################################
##
## SubSemi
##
## Deciding embedding and isomorphism of multiplication tables.
##
## Copyright (C) 2013-15  Attila Egri-Nagy
##

# A backtrack algorithm to build a map from multiplication table A (mtA) to
# multiplication table B (mtB). The map is built in L, i->L[i].
# mtA, mtB: matrices or MulTab objects
# Aprofs, Bprofs: for each element we associate a profile object (provided
# by the caller), and this profile information is used for restricting search
SubTableMatchingSearch := function(mtA, mtB, Aprofs, Bprofs, onlyfirst)
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
      Info(SubSemiInfoClass,1,Size(solutions)," ",
           solutions[Size(solutions)]);
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
        if onlyfirst and not IsEmpty(solutions) then return; fi;
      fi;
      Remove(L); Remove(used, Position(used,i)); #UNDO extending
    od;
  end;
  #-----------------------------------------------------------------------------
  #checking for enough profile types
  Aprofs2elts := AssociativeList();
  Perform([1..Size(Aprofs)], function(x) Collect(Aprofs2elts,Aprofs[x],x);end);
  Bprofs2elts := AssociativeList();
  Perform([1..Size(Bprofs)], function(x) Collect(Bprofs2elts,Bprofs[x],x);end);
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

#just convenience for testing without multiplication tables
InstallGlobalFunction(TableEmbeddings,
function(mA,mB)
  local f, Aprofs, Bprofs;
  if Size(mA) > Size(mB) then
    return [];
  else # embedding
    f := m -> List([1..Size(m)], x->AbstractIndexPeriod(m,x));
    return SubTableMatchingSearch(mA,mB,f(mA),f(mB), false);
  fi;
end);

# trying the represent semigroup (multiplication table) mtA as a subtable of mtB
# mtA,mtB: multiplication tables
# onlyfirst: Do we stop after first embedding found?
# This dispatcher checks whether we have an embedding or isomorphism.
EmbeddingsDispatcher := function(mtA,mtB,onlyfirst)
  local f, Aprofs, Bprofs;
  if Size(mtA) > Size(mtB) then
    return [];
  elif Size(mtA) = Size(mtB) then # isomorphism
    f := mt -> List([1..Size(mt)],x->ElementProfile(mt,x));
  else # embedding
    f := mt -> List([1..Size(mt)], x->AbstractIndexPeriod(Rows(mt),x));
  fi;
  Aprofs := f(mtA);
  Bprofs := f(mtB);
  #for isomorphisms the set of profiles should be the same
  if Size(mtA) = Size(mtB)
     and AsSet(Aprofs) <> AsSet(Bprofs) then
    return [];
  fi;
  return SubTableMatchingSearch(mtA,mtB,Aprofs,Bprofs,onlyfirst);
end;
MakeReadOnlyGlobal("EmbeddingsDispatcher"); #TODO silly name, change it

InstallGlobalFunction(MulTabEmbeddings,
function(mtA,mtB) return EmbeddingsDispatcher(mtA,mtB,false);end);

InstallGlobalFunction(MulTabEmbedding,
function(mtA,mtB) return EmbeddingsDispatcher(mtA,mtB,true);end);

#returns a permutation
InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
local l;
  l := EmbeddingsDispatcher(mtA,mtB,true);
  if IsEmpty(l) then
    return fail;
  else
    return PermList(l[1]);
  fi;
end);


InstallGlobalFunction(IsIsomorphicMulTab,
function(mtA,mtB)
  return not (IsomorphismMulTabs = fail);
end);
