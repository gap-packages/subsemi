################################################################################
##
## SubSemi
##
## Distributing subsemigroup enumeration along the ideal structure
## using the minimal extension method.
##
## Copyright (C) 2013-2016  Attila Egri-Nagy
##

# calculating subs of S/I, convert them to uppertorsos, then extend them into
# subsemigroups, plus the subsemigroups of the ideal itself
InstallOtherMethod(SubSgpsByIdeal,
        "for a semigroup  ideal and its conjugacy stabilizer group",
        [IsSemigroupIdeal,IsPermGroup],
function(I,G)
  local mt;
  mt := MulTab(Parent(I),G);
  return Concatenation(
           SubSgpsByUpperTorsos(I,G,UpperTorsos(I,G)),
           SubsOfSubInAmbientSgp(IndicatorFunction(AsList(I),Elts(mt)),
                                 mt));
end);

InstallOtherMethod(SubSgpsByIdeal,"for a semigroup ideal", [IsSemigroupIdeal],
function(I) return SubSgpsByIdeal(I,Group(()));end);

# homomorphism onto the Rees quotient by ideal I
InstallGlobalFunction(ReesFactorHomomorphism,
function(I)
  return HomomorphismQuotientSemigroup(ReesCongruenceOfSemigroupIdeal(I));
end);

# non-empty upper torso conjugacy reps, expressed as elements of S
# I - an ideal in S (S is contained as a parent)
# G - normalizer group of S
InstallGlobalFunction(UpperTorsos,
function(I,G)
local rfh,mtSmodI,SmodIsubs,preimgs,elts,sgps,mtS;
  if Size(I) = 1 then # no need to do any division
    return SubSgpsByMinExtensions(MulTab(Parent(I),G));
  fi;
  rfh := ReesFactorHomomorphism(I); #SmodI := Range(rfh);
  #calculate subs of the quotient
  mtSmodI := MulTab(Range(rfh),G,rfh);
  SmodIsubs := SubSgpsByMinExtensions(mtSmodI);
  #mapping back the subs of the quotient to the original
  preimgs := List(Elts(mtSmodI),x->PreImages(rfh,x));
  #zero has more preimgs - put the empty list there instead
  elts := List(preimgs, function(x) if Size(x)> 1 then return [];
                                   else return x;fi;end);
  # we simply concatenate, so the empty set disappears
  sgps := Set(SmodIsubs, x->Set(Concatenation(SetByIndicatorFunction(x,elts))));
  mtS := MulTab(Parent(I),G);
  return List(Filtered(sgps, y->not IsEmpty(y)),
              x-> IndicatorFunction(x,mtS));
end);

# calculates all sub conjugacy reps of S/I then extends all upper torsos
# I semigroup ideal
# G automorphism group
InstallGlobalFunction(SubSgpsByUpperTorsos,
function(I,G,uppertorsos)
  local extended, Ielts, result,mt;
  mt := MulTab(Parent(I),G);
  extended := Set(uppertorsos, x-> BlistConjClassRep(SgpInMulTab(x,mt),mt));
  Ielts := IndicatorFunction(AsList(I),Elts(mt));
  result := [];
  Perform(extended,
          function(x)
            Add(result, x);
            Append(result,
                   SubSgpsByMinExtensionsParametrized(mt,
                                                      x,
                                                      Ielts,
                                                      Stack(),
                                                      BlistStorage(Size(I)),
                                                      []));
         end);
  return result;
end);
