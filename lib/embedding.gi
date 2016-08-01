################################################################################
##
## SubSemi
##
## Constructing embeddings and isomorphisms of multiplication tables.
##
## Copyright (C) 2013-16  Attila Egri-Nagy
##

### PARTITIONED BACKTRACK SEARCH ###############################################
# this is the main search algorithm for constructing embeddings,
# the rest of the file contains interface functions preparing input

# A backtrack algorithm to build an injective map from multiplication table A to
# multiplication table B. The map is built in hom, such that i->hom[i].
# A, B - matrices encoding multiplication tables, A source, B target
# candidates - lookup array, element of A -> set of elements of B
#              the possible choices for an image of an element in A
# onlyfirst: shall we stop after the first solution is found?
# hom - partial solution the homomorphism from A to B in a list: i->hom[i]
# N - the maximal size of the solutions we want
MultiplicationTableEmbeddingSearch := function(A, B, candidates, onlyfirst, hom, N)
  local PartitionedBackTrack, # the embedded recursive backtrack function
        cod, # keeping track of what elements are in hom (the codomain of hom)
        solutions; # cumulative collection of solutions
  #-----------------------------------------------------------------------------
  PartitionedBackTrack := function() # parameters: hom, cod, solutions
    local newelt, dom, f;
    if Size(hom)=N then  # when a solution is found, store it
      Add(solutions, ShallowCopy(hom));
      Info(SubSemiInfoClass,3,Size(solutions)," ",solutions[Size(solutions)]);
      return; #cut the search
    fi;
    for newelt in candidates[Size(hom)+1] do
      if not cod[newelt] then #is it really new? might be used already
        Add(hom,newelt); cod[newelt]:=true; # EXTEND hom by newelt
        dom := [1..Size(hom)];
        f := function(x,y) #function for checking for homomorphism
          local r,q;
          r := A[x][y]; # product in A
          q := B[hom[x]][hom[y]]; # product in B
          if r in dom then
            return hom[r] = q; #if product is defined in A, check homomorphism
          else
            return not cod[q]; #otherwise, it should not be defined in B yet
          fi;
        end;
        # to check the newly adjoined element first we reverse the domain
        if ForAll(Reversed(dom), x -> ForAll(dom, y -> f(x,y))) then
          PartitionedBackTrack();
          if onlyfirst and not IsEmpty(solutions) then return; fi;
        fi;
        Remove(hom); cod[newelt]:=false;# UNDO extending
      fi;
    od;
  end;
  #-----------------------------------------------------------------------------
  solutions := [];
  cod := BlistList([1..Size(B)], hom);
  PartitionedBackTrack();
  return solutions;
end;
MakeReadOnlyGlobal("MultiplicationTableEmbeddingSearch");

### PARTITIONING THE SEARCH SPACE ##############################################

# calculating profiles of multiplication table elements for embeddings
# we can only use the (index,period) pairs
InstallGlobalFunction(EmbeddingProfiles,
        M -> List([1..Size(M)], x->AbstractIndexPeriod(M,x)));

# ...for isomorphisms
# full profile an element can be used
InstallGlobalFunction(IsomorphismProfiles,
        M -> List([1..Size(M)],x->ElementProfile(M,x)));

# Aprofs, Bprofs: profiles of each element  in A and B, index -> profile
# returns: a lookup indexed by A mapping to classes of elements of B that
# are potential images in an embedding
CandidateLookup := function(Aprofs, Bprofs)
  local Acls, Bcls, # classifying elements of A and B by their profiles
        lookup, # the resulting lookup array
        N, # size of A and of the final lookup
        elt, # an element of A
        f; #just a classification function
  N := Size(Aprofs);
  #classifying by the supplied profiles
  f := M -> GeneralEquivClassMap([1..Size(M)], x -> M[x], \=);
  Acls := f(Aprofs);
  Bcls := f(Bprofs);
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
MakeReadOnlyGlobal("CandidateLookup");

# partialhom - a partial homomorphism from A to B (a homomorphism of a sub of A)
# candidates - a lookup table produced by CandidateLookup
RestrictCandidates := function(partialhom, candidates)
  local partialcod;
  partialcod := Set(partialhom);
  return List([1..Size(candidates)],
              function(x) if IsBound(partialhom[x]) then
                            return [partialhom[x]];
                          else
                            return Difference(candidates[x], partialcod);
                          fi;
                        end);
end;

# TODO this recalculates CandidateLookup - we should just use the lookup table
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

### EMBEDDINGS #################################################################

# A,B: matrices representing multiplication tables
# onlyfirst: Do we stop after first embedding found?
# This dispatcher checks whether we have an embedding or isomorphism.
EmbeddingsDispatcher := function(A,B,partialhom,onlyfirst)
  local f, Aprofs, Bprofs, candidates,
  Aprofsset,Bprofsset;
  if Size(A) > Size(B) then #no way to map the bigger onto the smaller
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
    if not (IsSubset(Bprofsset, Aprofsset)
            and ForAll(Aprofs,
                    x-> Size(Positions(Aprofs,x))<=Size(Positions(Bprofs,x))))
       then return []; fi;
  fi;
  candidates := CandidateLookup(Aprofs, Bprofs);
  if not IsEmpty(partialhom) then
    candidates := RestrictCandidates(partialhom, candidates);
  fi;
  Info(SubSemiInfoClass,2," Embeddings seem possible.");
  return MultiplicationTableEmbeddingSearch(A,B,
                                            candidates,
                                            onlyfirst,
                                            [],
                                            Size(A));
end;
MakeReadOnlyGlobal("EmbeddingsDispatcher");

InstallGlobalFunction(MulTabEmbeddings,
function(mtA,mtB) return EmbeddingsDispatcher(Rows(mtA),Rows(mtB),[],false);end);

InstallGlobalFunction(MulTabEmbeddingsByPartialHoms,
function(mtSubA, mtA,mtB)
local m, cls, phom;
  m := MulTabEmbeddings(mtSubA, mtB);
  cls := l -> List(Classify(l, Set, \=), x->x[1]);
  m := cls(m);

  phom := function(hom)
    local i, partialhom;
    partialhom := [];
    for i in [1..Size(mtSubA)] do
      partialhom[Position(Elts(mtA), Elts(mtSubA)[i])] := hom[i];
    od;
    return partialhom;
  end;
  return cls(Concatenation(List(m,
                                x->EmbeddingsDispatcher(Rows(mtA),
                                                        Rows(mtB),
                                                        phom(x),
                                                        false))));
end);


#returns an empty list or mappings of an embedding in a list
InstallGlobalFunction(MulTabEmbedding,
function(mtA,mtB)
  local result;
  result := EmbeddingsDispatcher(Rows(mtA),Rows(mtB),[],true);
  if IsEmpty(result) then
    return result;
  else
    return result[1]; #since we have only one embedding
  fi;
end);

### EMBEDDINGS UP TO ISOMORPHISMS ##############################################
#acting on a list by permutations
OnList := function(l,g) return List(l, x->x^g);end;
MakeReadOnlyGlobal("OnList");
#conjugacy class representative
PosIntListConjRep := function(l,G) return Minimum(Set(G, x->OnList(l,x)));end;
MakeReadOnlyGlobal("PosIntListConjRep");

EmbeddingSearchFunc := function(mtS, mtT)
  return function(psol, limit)
    if limit > Size(mtS) then
      return fail;
    else
      return MultiplicationTableEmbeddingSearch(
               Rows(mtS), Rows(mtT),
               CandidateLookup(EmbeddingProfiles(Rows(mtS)),
                               EmbeddingProfiles(Rows(mtT))),
               false,
               psol,
               limit);
    fi;
  end;  
end;

PartialEmbeddingsUpToOrderedConjugacy := function(searchfunc,G)
local i, # number of mappings in a partial solution
      queue, # elements waiting to be processed
      extended, # extended partial solutions
      newq, # the new queue
      p,q,  # (partial solution, stabilizer) pairs
      fixed; # psols that have trivial stabilizers
  queue := [ rec(psol:=[], stab:=G)];
  fixed := [];
  i := 1;
  while true do
    Info(SubSemiInfoClass,2,"size:",i,", ",Size(queue)," waiting");
    newq := [];
    for p in queue do
      extended := searchfunc(p.psol, i);
      if extended = fail then # we went over the size of source
        return Concatenation(fixed, List(queue, x->x.psol));
      fi;

      extended := Set(extended,
                      x-> PosIntListConjRep(x,p.stab));
      if Size(p.stab) = 1 then
        Append(fixed, extended);
      else
        for q in extended do
          Add(newq, rec(psol:=q, stab:=Stabilizer(p.stab,q,OnList)));
        od;
      fi;
    od;
    i := i + 1; 
    queue := newq;
  od;
  return fail;
end;

InstallGlobalFunction(MulTabEmbeddingsUpToConjugation,
function(mtS, mtT)
  local searchfunc, # just a curried function for simplifying code
        psols; # list of partial solutions
  searchfunc := EmbeddingSearchFunc(mtS, mtT); 
  
  psols := Concatenation(List(, x-> searchfunc(x,Size(mtS))));
                      Append(sols, ); #forgetting stabilizers
                      return List(Classify(sols,
                                           x->PosIntSetConjClassRep(Set(x),mtT), #conj rep of image as set
                                           \=),
                                  x->Representative(x)); #taking representatives
);

### ISOMORPHISM ################################################################
# returns a permutation that maps elements of mtA to mtB
# to prove isomorphism
InstallGlobalFunction(IsomorphismMulTabs,
function(mtA,mtB)
local l;
  l := EmbeddingsDispatcher(Rows(mtA),Rows(mtB),[],true);
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
