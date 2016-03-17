################################################################################
##
## SubSemi
##
## Deciding embedding and isomorphism of multiplication tables.
##
## Copyright (C) 2013-16  Attila Egri-Nagy
##

### PARTITIONED BACKTRACK SEARCH ###############################################
# this is the main search algorithm for constructing embeddings,
# the rest of the file contains interface functions preparing input

# A backtrack algorithm to build an injective map from multiplication table A to
# multiplication table B. The map is built in hom, such that i->hom[i].
# A, B: matrices encoding multiplication tables
# targetcls: lookup array
# i, element of A -> class of elements of B that are possible images if i
# onlyfirst: shall we stop after the first solution is found?
MultiplicationTableEmbeddingSearch := function(A, B, candidates, onlyfirst)
  local hom, # the homomorphism from A to B in a list: i->hom[i]
        N, # the number of elements of A, the source size
        PartitionedBackTrack, # the embedded recursive backtrack function
        cod, # keeping track of what elements we used when building up hom
        solutions; # cumulative collection of solutions
  #-----------------------------------------------------------------------------
  PartitionedBackTrack := function() # parameters: hom, used
    local newelt, dom, rdom, f;
    if Size(hom)=N then  # when a solution is found
      Add(solutions, ShallowCopy(hom));
      Info(SubSemiInfoClass,2,Size(solutions)," ",solutions[Size(solutions)]);
      return;
    fi;
    for newelt in candidates[Size(hom)+1] do
      if not cod[newelt] then #is it really new?
        Add(hom,newelt); cod[newelt]:=true; # EXTEND by newelt
        dom := [1..Size(hom)];
        f := function(x,y)
          local r,q;
          r := A[x][y];
          q := B[hom[x]][hom[y]];
          if r in dom then
            return hom[r] = q;
          else
            return not cod[q];
          fi;
        end;
        rdom := Reversed(dom); # to check the newly adjoined element first
        if ForAll(rdom, x -> ForAll(dom, y -> f(x,y))) then
          PartitionedBackTrack();
          if onlyfirst and not IsEmpty(solutions) then return; fi;
        fi;
        Remove(hom); cod[newelt]:=false;# UNDO extending
      fi;
    od;
  end;
  #-----------------------------------------------------------------------------
  N := Size(A);
  hom := []; solutions := []; cod := BlistList([1..Size(B)], []);
  PartitionedBackTrack();
  return solutions;
end;
MakeReadOnlyGlobal("MultiplicationTableEmbeddingSearch");

# Aprofs, Bprofs: profiles of each element  in A and B, index -> profile
# returns: a lookup indexed by A mapping to classes of elements of B that
# are potential images in an embedding
CandidateLookup := function(Aprofs, Bprofs)
  local Acls, Bcls, # classifying elements of A and B by their profiles
        lookup, # the resulting lookup array
        N, # size of A and of the final lookup
        elt; # an element of A
  N := Size(Aprofs);
  #classifying by the supplied profiles
  Acls := GeneralEquivClassMap([1..N], x -> Aprofs[x], \=);
  Bcls := GeneralEquivClassMap([1..Size(Bprofs)], x -> Bprofs[x], \=);
  lookup := EmptyPlist(N);
  #bit of searching in order to avoid using hashtables
  for elt in [1..N] do
    #for each element in A we find the elements of B with same profile
    lookup[elt] := Bcls.classes[Position(Bcls.data, Aprofs[elt])];
    #there should be enough elements in each class
    if Size(Acls.classes[Position(Acls.data, Aprofs[elt])])
       > Size(lookup[elt]) then
      return fail;
    fi;
  od;
  return lookup;
end;

SearchSpaceSize := function(Aprofs, Bprofs)
  local pairs, Acls, Bcls, f;
  #classifying by the supplied profiles (indices by content)
  f := M -> GeneralEquivClassMap([1..Size(M)], x -> M[x], \=);
  Acls := f(Aprofs);
  Bcls := f(Bprofs);
  pairs := List([1..Size(Acls.classes)],
                x-> [Size(Acls.classes[x]),
                     Size(Bcls.classes[Position(Bcls.data,Acls.data[x])])]);
  return Product(List(pairs, p->Factorial(p[2])/Factorial(p[2]-p[1])));
end;

# calculating profiles of multiplication table elements for embeddings
InstallGlobalFunction(EmbeddingProfiles,
        M -> List([1..Size(M)], x->AbstractIndexPeriod(M,x)));

# ...for isomorphisms
InstallGlobalFunction(IsomorphismProfiles,
        M -> List([1..Size(M)],x->ElementProfile(M,x)));

# A,B: matrices representing multiplication tables
# onlyfirst: Do we stop after first embedding found?
# This dispatcher checks whether we have an embedding or isomorphism.
EmbeddingsDispatcher := function(A,B,onlyfirst)
  local f, Aprofs, Bprofs,
  Aprofsset,Bprofsset;
  if Size(A) > Size(B) then
    return [];
  elif Size(A) = Size(B) then # isomorphism
    f := IsomorphismProfiles;
  else # embedding
    f := EmbeddingProfiles;
  fi;
  Aprofs := f(A);
  Bprofs := f(B);
  #checking for the right set of target profile types
  Aprofsset := Set(Aprofs);
  Bprofsset := Set(Bprofs);
  if Size(Aprofs) = Size(Bprofs) then
    if not IsSubset(Set(Bprofs), Set(Aprofs)) then return []; fi;
  else
    if not IsSubset(Bprofsset, Aprofsset) then return []; fi;
  fi;
  Info(SubSemiInfoClass,2," Embeddings seem possible.");
  return MultiplicationTableEmbeddingSearch(A,B,
                                            CandidateLookup(Aprofs, Bprofs),
                                            onlyfirst);
end;
MakeReadOnlyGlobal("EmbeddingsDispatcher"); #TODO silly name, change it

InstallGlobalFunction(MulTabEmbeddings,
function(mtA,mtB) return EmbeddingsDispatcher(Rows(mtA),Rows(mtB),false);end);

#returns an empty list or mappings of an embedding in a list
InstallGlobalFunction(MulTabEmbedding,
function(mtA,mtB)
  local result;
  result := EmbeddingsDispatcher(Rows(mtA),Rows(mtB),true);
  if IsEmpty(result) then
    return result;
  else
    return result[1]; #since we have only one embedding
  fi;
end);


### ISOMORPHISM ################################################################
# returns a permutation that maps elements of mtA to mtB
# to prove isomorphism
InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
local l;
  l := EmbeddingsDispatcher(Rows(mtA),Rows(mtB),true);
  if IsEmpty(l) then
    return fail;
  else
    return PermList(l[1]);
  fi;
end);

# returns true if multiplication table mtA is isomorphic to mtB
InstallGlobalFunction(IsIsomorphicMulTab,
function(mtA,mtB)
  return not (IsomorphismMulTabs(mtA,mtB) = fail);
end);

### AUTOMORPHISM ###############################################################

# finding the automorphsim group of a multiplication table by collecting all
# isomorphisms to itself
InstallGlobalFunction(AutGrpOfMulTab,
        function (mt)
  return Group(List(MulTabEmbeddings(mt, mt), PermList));
end);
