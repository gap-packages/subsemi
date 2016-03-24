################################################################################
##
## SubSemi
##
## Distributing subsemigroup enumeration along the ideal structure
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

InstallOtherMethod(SubSgpsByIdeals,
        "for a semigroup  ideal and its conjugacy stabilizer group",
        [IsSemigroupIdeal,IsPermGroup],
        function(I,G)
  return SubSgpsByUpperTorsos(I,G,UpperTorsos(I,G));
end);

InstallOtherMethod(SubSgpsByIdeals,"for a semigroup ideal",
        [IsSemigroupIdeal],
        function(I)
  return SubSgpsByUpperTorsos(I,Group(()),UpperTorsos(I,Group(())));
end);

# homomorphism onto the Rees quotient by ideal I
InstallGlobalFunction(ReesFactorHomomorphism,
function(I)
  return HomomorphismQuotientSemigroup(ReesCongruenceOfSemigroupIdeal(I));
end);

# non-empty upper torso conjugacy reps, expressed as elements of S
# I an ideal in S (S is contained as a parent)
# G the conjugacy stabilizer group of S
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
  sgps := Set(SmodIsubs, x->Concatenation(SetByIndicatorFunction(x,elts)));
  mtS := MulTab(Parent(I),G);
  return List(sgps,x-> IndicatorFunction(x,mtS));
end);

# calculates all sub conjugacy reps of S/I then extends all upper torsos
# I semigroup ideal
# G automorphism group
# calcideal flag if true, then the empty uppertorso is used
InstallGlobalFunction(SubSgpsByUpperTorsos,
function(I,G,uppertorsos)
  local extended, gens, result,mt;
  mt := MulTab(Parent(I),G);
  extended := List(uppertorsos, x-> BlistConjClassRep(SgpInMulTab(x,mt),mt));
  gens := IndicatorFunction(AsList(I),Elts(mt));
  result := [];
  Perform(extended,
          function(x)
            if SizeBlist(x) > 0 then Add(result, x); fi;
            Append(result,
                   SubSgpsByMinExtensionsParametrized(mt,
                           x,gens,Stack(),BlistStorage(Size(I)),[]));
         end);
  return result;
end);
