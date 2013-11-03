################################################################################
##
## SubSemi
##
## Distributing subsemigroup enumeration along the ideal structure
##
## Copyright (C) 2013  Attila Egri-Nagy
##

InstallGlobalFunction(ReesFactorHomomorphism,
function(I)
  local cong,quotienthom,regrepisom; 
  cong := ReesCongruenceOfSemigroupIdeal(I);
  quotienthom := HomomorphismQuotientSemigroup(cong);
  regrepisom := IsomorphismTransformationSemigroup(Range(quotienthom));
  return CompositionMapping(regrepisom, quotienthom);
end);
