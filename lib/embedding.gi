################################################################################
##
## SubSemi
##
## Deciding embedding and isomorphism of multiplication tables.
##
## Copyright (C) 2013-16  Attila Egri-Nagy
##

PartionedSearchSpace := function(Aprofs, Bprofs)
  local Acls, Bcls, # classifying elements of A and B by their profiles
        targetcls,
        N,
        elt; # an element of A
  N := Size(Aprofs);
  #checking for the right set of target profile types
  if not IsSubset(Set(Bprofs), Set(Aprofs)) then return fail; fi;
  #classifying by the supplied profiles
  Acls := GeneralEquivClassMap([1..N], x -> Aprofs[x], \=);
  Bcls := GeneralEquivClassMap([1..Size(Bprofs)], x -> Bprofs[x], \=);
  targetcls := EmptyPlist(N);
  #bit of searching in order to avoid using hashtables
  for elt in [1..N] do
    #for each element in A we find the elements of B with same profile
    targetcls[elt] := Bcls.classes[Position(Bcls.data, Aprofs[elt])];
    #there should be enough elements in each class
    if Size(Acls.classes[Position(Acls.data, Aprofs[elt])])
       > Size(targetcls[elt]) then
      return fail;
    fi;
  od; #TODO separate this class matching, so we can check the search space size
  return rec(targetcls:=targetcls,
             Acls:=Acls,
             Bcls:=Bcls);
end;

SearchSpaceSize := function(Acls, Bcls)
  local pairs;
  pairs := List([1..Size(Acls.classes)],
                x-> [Size(Acls.classes[x]),
                     Size(Bcls.classes[Position(Bcls.data,Acls.data[x])])]);
  return Product(List(pairs, p->Factorial(p[2])/Factorial(p[2]-p[1])));
end;

# A backtrack algorithm to build a map from multiplication table A (mtA) to
# multiplication table B (mtB). The map is built in L, i->L[i].
# mtA, mtB: matrices or MulTab objects
# Aprofs, Bprofs: for each element we associate a profile object (provided
# by the caller), and this profile information is used for restricting search
# integer -> inhomogeneous lists
SubTableMatchingSearch := function(A, B, Aprofs, Bprofs, onlyfirst)
  local hom, # the homomorphism from A to B in a list: i->hom[i]
        N, # the number of elements of A
        targetcls, #lookup: element of A -> class of B with the same profile
        BackTrack, # the embedded recursive backtrack function
        cod, # keeping track of what elements we used when building up hom
        solutions; # cumulative collection of solutions
  #-----------------------------------------------------------------------------
  BackTrack := function() # parameters: hom, used
    local newelt, dom, rdom, f;
    # when a solution is found
    if Size(hom)=N then
      Add(solutions, ShallowCopy(hom));
      Info(SubSemiInfoClass,2,Size(solutions)," ",
           solutions[Size(solutions)]);
      return;
    fi;
    for newelt in targetcls[Size(hom)+1] do
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
          BackTrack();
          if onlyfirst and not IsEmpty(solutions) then return; fi;
        fi;
        Remove(hom); cod[newelt]:=false;#UNDO extending
      fi;
    od;
  end;
  #-----------------------------------------------------------------------------
  # figuring out target size
  N := Size(A);
  targetcls := PartionedSearchSpace(Aprofs, Bprofs).targetcls;
  if targetcls = fail then return []; fi;
  Info(SubSemiInfoClass,2," Embeddings seem possible.");
  #calling backtrack
  hom := []; solutions := []; cod := BlistList([1..Size(B)], []);
  BackTrack();
  return solutions;
end;
MakeReadOnlyGlobal("SubTableMatchingSearch");

# trying the represent semigroup (multiplication table) mtA as a subtable of mtB
# mtA,mtB: multiplication tables
# onlyfirst: Do we stop after first embedding found?
# This dispatcher checks whether we have an embedding or isomorphism.
EmbeddingsDispatcher := function(A,B,onlyfirst)
  local f, Aprofs, Bprofs;
  if Size(A) > Size(B) then
    return [];
  elif Size(A) = Size(B) then # isomorphism
    f := M -> List([1..Size(M)],x->ElementProfile(M,x));
  else # embedding
    f := M -> List([1..Size(M)], x->AbstractIndexPeriod(M,x));
  fi;
  Aprofs := f(A);
  Bprofs := f(B);
  #for isomorphisms the set of profiles should be the same
  if Size(A) = Size(B)
     and AsSet(Aprofs) <> AsSet(Bprofs) then
    return [];
  fi;
  return SubTableMatchingSearch(A,B,Aprofs,Bprofs,onlyfirst);
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

InstallGlobalFunction(AutGrpOfMulTab,
function (mt)
  return Group(List(MulTabEmbeddings(mt, mt), PermList));
end);

#returns a permutation
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

InstallGlobalFunction(IsIsomorphicMulTab,
function(mtA,mtB)
  return not (IsomorphismMulTabs(mtA,mtB) = fail);
end);
