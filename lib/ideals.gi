################################################################################
##
## SubSemi
##
## Distributing subsemigroup enumeration along the ideal structure
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#actually building the Rees factor semigroup
InstallGlobalFunction(ReesFactorHomomorphism,
function(I)
  local cong,quotienthom,regrepisom; 
  cong := ReesCongruenceOfSemigroupIdeal(I);
  quotienthom := HomomorphismQuotientSemigroup(cong);
  regrepisom := IsomorphismTransformationSemigroup(Range(quotienthom));
  return CompositionMapping(regrepisom, quotienthom);
end);

InstallGlobalFunction(RFHNonZeroPreImages,
function (l,rfh)
  local result,t,preimgs;
  result := [];
  for t in l do
    preimgs := PreImages(rfh,t);
    if Size(preimgs) = 1 then
      Add(result, preimgs[1]);
    fi;
  od;
  return result;
end);
