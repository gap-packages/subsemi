Read("sgps.g");

rfh := ReesFactorHomomorphism(K42);
T := Range(rfh);
SetName(T,"K43modK42");
mtT := MulTab(T,S4,rfh);
SubSgpsByMinClosures(mtT);

mtK43 := MulTab(K43);

preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
elts := List(preimgs, function(x) if Size(x)> 1 then return fail; else return x[1];fi;end);

itf := InputTextFile("K43modK42.reps");
otf := OutputTextFile("K43modK42.uppertorsos",false);

s := ReadLine(itf);
repeat
  NormalizeWhitespace(s);
  indset := AsBlist(DecodeBitString(s));
  torso := ElementsByIndicatorSet(indset,elts);
  if fail in torso then Remove(torso,Position(torso,fail));fi;
  WriteLine(otf,EncodeBitString(AsBitString(
          IndicatorSetOfElements(torso,SortedElements(mtSing4)))));
  s := ReadLine(itf);
until s=fail;
