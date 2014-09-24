################################################################################
##
## SubSemi
##
## User Interface - high-level, easy-to-use functions
##
## Copyright (C) 2014  Attila Egri-Nagy
##

InstallGlobalFunction(AllSubsemigroups,
function(S)
  local mt; # multiplication table
  mt := MulTab(S);
  return List(AsList(SubSgpsByMinExtensions(mt)),
                 x->Semigroup(
                         SmallSemigroupGeneratingSet(
                                 ElementsByIndicatorSet(x,mt))));
end);
