################################################################################
##
## SubSemi
##
## Distributing subsemigroup enumeration along the ideal structure
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

#actually building the Rees factor semigroup as the right regular representation
#of the quotient by ideal I
InstallGlobalFunction(ReesFactorHomomorphism,
function(I)
  local quotienthom,regrepisom;
  quotienthom:=HomomorphismQuotientSemigroup(ReesCongruenceOfSemigroupIdeal(I));
  regrepisom:=IsomorphismTransformationSemigroup(Range(quotienthom));
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

# upper torso conjugacy reps, expressed as elements of S
# I an ideal in S (S is contained as a parent)
# G the automorphism group of S
UpperTorsos := function(I,G)
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
  return  List(Unique(tmp),x-> List(x, y->Position(Elts(mtS),y)) );
end;

# calculates all sub conjugacy reps of S/I then extends all upper torsos
# I semigroup ideal
# G automorphism group
# calcideal flag if true, then the empty uppertorso is used
SubSgpsByUpperTorsos := function(I,G,uppertorsos)
  local extended, filter, result, S,mtS;
  S := Parent(I);
  mtS := MulTab(S,G);
  extended := List(uppertorsos, x-> SgpInMulTab(x,mtS));
  filter := List(I, x-> Position(Elts(mtS), x));
  result := [];
  Perform(extended, function(x)
    Append(result,AsList(
            SubSgpsByMinExtensionsParametrized(mtS,x,filter,Stack(),[])));end);
  return result; #TODO duplicates when the ideal has only one element
end;

InstallOtherMethod(SubSgpsByIdeals,"for an ideal and an automorphism group",
        [IsSemigroupIdeal,IsPermGroup],
function(I,G)
  return SubSgpsByUpperTorsos(I,G,UpperTorsos(I,G));
end);

InstallOtherMethod(SubSgpsByIdeals,"for an ideal and an automorphism group",
        [IsSemigroupIdeal],
        function(I)
  return SubSgpsByUpperTorsos(I,Group(()),UpperTorsos(I,Group(())));
end);
