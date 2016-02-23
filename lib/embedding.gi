################################################################################
##
## SubSemi
##
## Deciding embedding and isomorphism of multiplication tables.
##
## Copyright (C) 2013-16  Attila Egri-Nagy
##

# A backtrack algorithm to build a map from multiplication table A (mtA) to
# multiplication table B (mtB). The map is built in L, i->L[i].
# mtA, mtB: matrices or MulTab objects
# Aprofs, Bprofs: for each element we associate a profile object (provided
# by the caller), and this profile information is used for restricting search
# integer -> inhomogeneous lists
SubTableMatchingSearch := function(mtA, mtB, Aprofs, Bprofs, onlyfirst)
  local L, # the mapping i->L[i]
        N, # the number of elements of the semigroups
        matchedBprofs, #lookup: element of A -> class of B with the same profile
        BackTrack, # the embedded recursive backtrack function
        used, # keeping track of what elements we used when building up L
        Acls, Bcls, # classifying A by its profiles
        solutions,elt; # cumulative collection of solutions
  #-----------------------------------------------------------------------------
  BackTrack := function() # parameters: L, used
    local k,i,candidates,X,Y;
    # when a solution is found
    if Size(L)=N then
      Add(solutions, ShallowCopy(L));
      Info(SubSemiInfoClass,2,Size(solutions)," ",
           solutions[Size(solutions)]);
      return;
    fi;
    k := Size(L)+1; # the index of the next element
    # getting elements of B with profiles matching profile of A, not used yet
    candidates := Difference(matchedBprofs[k],used);
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
  # figuring out target size
  if IsMulTab(mtA) then
    N := Size(Rows(mtA));
  else
    N := Size(mtA);
  fi;
  #checking for the right set of target profile types
  if not IsSubset(Set(Bprofs), Set(Aprofs)) then return []; fi;
  #classifying by profiles
  Acls := GeneralEquivClassMap([1..N], x -> Aprofs[x], \=);
  Bcls := GeneralEquivClassMap([1..Size(Bprofs)], x -> Bprofs[x], \=);
  matchedBprofs := EmptyPlist(N);
  #bit of searching in order to avoid using hashtables
  for elt in [1..N] do
    #for each element in mtA we find the elements of mtB with same profile
    matchedBprofs[elt] := Bcls.classes[Position(Bcls.data, Aprofs[elt])];
    #there should be enough elements in each class
    if Size(Acls.classes[Position(Acls.data, Aprofs[elt])])
       > Size(matchedBprofs[elt]) then
      return [];
    fi;
  od;
  Info(SubSemiInfoClass,2," Embeddings seem possible.");
  #calling backtrack
  used := []; L := []; solutions := [];
  BackTrack();
  return solutions;
end;
MakeReadOnlyGlobal("SubTableMatchingSearch");

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

InstallGlobalFunction(AutGrpOfMulTab,
function (mt)
  return Group(List(MulTabEmbeddings(mt, mt), PermList));
end);

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
  return not (IsomorphismMulTabs(mtA,mtB) = fail);
end);
