################################################################################
##
## SubSemi
##
## User Interface - high-level, easy-to-use functions
##
## Copyright (C) 2014-2015  Attila Egri-Nagy
##

### SUBSEMIGROUPS ##############################################################
# returning all nonempty subsemigroups of semigroup S
InstallGlobalFunction(AllSubsemigroups,
function(S)
  local mt; # multiplication table
  mt := MulTab(S);
  return List(AsList(SubSgpsByMinExtensions(mt)),
              x->BlistToSmallGenSet(x,mt));
end);

# returning all representatives of conjugacy classes of
# nonempty subsemigroups of semigroup S (conjugating semigroup elements by G)
InstallGlobalFunction(ConjugacyClassRepSubsemigroups,
function(S, G)
  local mt; # multiplication table
  mt := MulTab(S,G);
  return List(AsList(SubSgpsByMinExtensions(mt)),
              x->BlistToSmallGenSet(x,mt));
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
  source := SortedElements(mtS);
  image := List(ListPerm(perm, Size(T)), x->SortedElements(mtT)[x]);
  mappingfunc := function(s) return image[Position(source,s)];end;
  return MappingByFunction(S,T,mappingfunc);
end);
