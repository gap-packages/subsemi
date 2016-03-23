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
local rfh,T,mtT,Treps,preimgs,elts,tmp,mtS;
  #get the Rees quotient as ts
  rfh := ReesFactorHomomorphism(I);
  T := Range(rfh);
  #calculate its subsgp classes
  mtT := MulTab(T,G,rfh);
  Treps := AsList(SubSgpsByMinExtensions(mtT));
  #mapping back the subs of the quotient to the original
  preimgs := List(Elts(mtT),x->PreImages(rfh,x));
  #from preimageset to elements, getting rid of zero by failing it
  elts := List(preimgs,function(x) if Size(x)> 1 then return fail;
                                   else return x[1];fi;end);
  tmp := List(Treps, x->SetByIndicatorFunction(x,elts));
  Perform(tmp, function(x) if fail in x then
      Remove(x, Position(x,fail));fi;end);
  mtS := MulTab(Parent(I),G);
  return  List(Unique(tmp),x-> IndicatorFunction(x,mtS));
end);

# calculates all sub conjugacy reps of S/I then extends all upper torsos
# I semigroup ideal
# G automorphism group
# calcideal flag if true, then the empty uppertorso is used
InstallGlobalFunction(SubSgpsByUpperTorsos,
function(I,G,uppertorsos)
  local extended, filter, result, S,mtS;
  S := Parent(I);
  mtS := MulTab(S,G);
  extended := Set(uppertorsos, x-> BlistConjClassRep(SgpInMulTab(x,mtS),mtS));
  filter := IndicatorFunction(AsList(I),Elts(mtS));
  result := [];
  Perform(extended,
          function(x)
            if SizeBlist(x) > 0 then Add(result, x); fi;
            Append(result,
                   SubSgpsByMinExtensionsParametrized(mtS,
                           x,filter,Stack(),BlistStorage(Size(I)),[]));
         end);
  return result; #TODO duplicates when the ideal has only one element
end);
