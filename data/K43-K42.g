K42 := SemigroupIdealByGenerators(
               SingularTransformationSemigroup(4),
               [Transformation([1,1,2,2])]);
rfh := ReesFactorHomomorphism(K42);
T := Range(rfh);
SetName(T,"K43-K42");

#SubSgpsBy1Extensions(MulTab(T,S4,rfh));
mtSing4 := MulTab(SingularTransformationSemigroup(4));
mtT := MulTab(T);

 L := List(SortedElements(mtT),x->PreImages(rfh,x));
LL := List(L, function(x) if Size(x)> 1 then return fail; else return x[1];fi;end);

itf := InputTextFile("K43-K42ccs");
otf := OutputTextFile("K43-K42torsos",false);

s := ReadLine(itf);
repeat
  NormalizeWhitespace(s);
  indset := AsBlist(DecodeBitString(s));
  #elts := ElementsByIndicatorSet(indset,mtT);
  #if IsSG(elts) then Print("#"); else Print("FAIL");Error();fi;
  #torso := RFHNonZeroPreImages(elts,rfh);
  torso := List(ListBlist(Indices(mtT),indset),x->LL[x]);
  if fail in torso then Remove(torso,Position(torso,fail));fi;
  WriteLine(otf,EncodeBitString(AsBitString(
          IndicatorSetOfElements(torso,mtSing4))));
  s := ReadLine(itf);
until s=fail;
     
     
