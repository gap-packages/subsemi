################################################################################
##
## SubSemi
##
## User Interface - high-level, easy-to-use functions
##
## Copyright (C) 2014-2019  Attila Egri-Nagy
##

### SUBSEMIGROUPS ##############################################################
# returning all nonempty subsemigroups of semigroup S
InstallGlobalFunction(AllSubsemigroups,
function(S)
  local mt; # multiplication table
  mt := MulTab(S);
  return List(AsList(SubSgpsByMinExtensions(mt)),
              x->SmallSemigroupGeneratingSet(SetByIndicatorFunction(x,mt)));
end);

# returning all representatives of conjugacy classes of
# nonempty subsemigroups of semigroup S (conjugating semigroup elements by G)
InstallGlobalFunction(ConjugacyClassRepSubsemigroups,
function(S, G)
  local mt; # multiplication table
  mt := MulTab(S,G);
  return List(AsList(SubSgpsByMinExtensions(mt)),
              x->SmallSemigroupGeneratingSet(SetByIndicatorFunction(x,mt)));
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

### SEMIGROUP ISOMORPHISM ######################################################

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
  source := Elts(mtS);
  image := List(ListPerm(perm, Size(T)), x->Elts(mtT)[x]);
  mappingfunc := function(s) return image[Position(source,s)];end;
  return MappingByFunction(S,T,mappingfunc);
end);

### AUTOMORPHISM GROUPS ########################################################
InstallMethod(AutomorphismGroup, "for a semigroup", [IsSemigroup],
function(S)
  local mt, G;
  mt := MulTab(S);
  G := Group(List(MulTabEmbeddings(mt,mt), PermList));
  if Size(G) = 1 then
    return G;
  else
    return Group(SmallGeneratingSet(G));
  fi;
end);

### INDEPENDENT SETS ###########################################################
InstallGlobalFunction(IndependentSets,
function(S)
  local mt;
  mt := MulTab(S);
  return List(IS(mt, ISCanCons), x -> SetByIndicatorFunction(x,mt));
end);
