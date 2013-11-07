################################################################################
##
## SubSemi
##
## General functions for semigroups
##
## Copyright (C) 2013  Attila Egri-Nagy
##

InstallGlobalFunction(Is3NilPotent,
function(S)
  local zero,L;
  L := AsList(S);
  zero := L[1]*L[1]*L[1];
  if ForAll(Tuples(L,3), tup->Product(tup)=zero) then
    return ForAll(L, t-> (t*zero=zero) and (zero*t=zero));
  fi;
  return false;
end);

InstallGlobalFunction(IsZeroElement,
function(s,S)
  return ForAll(S, t -> s*t=s and t*s=s);
end);

InstallGlobalFunction(HasZeroElement,
function(S)
  return ForAny(S, function(s) return IsZeroElement(s,S);end);
end);
