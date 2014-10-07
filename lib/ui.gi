################################################################################
##
## SubSemi
##
## User Interface - high-level, easy-to-use functions
##
## Copyright (C) 2014  Attila Egri-Nagy
##

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
