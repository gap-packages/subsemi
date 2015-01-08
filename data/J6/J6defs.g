# for calculating the subs of J6

J6 := JonesMonoid(6);
S6 := SymmetricGroup(IsPermGroup,6);
G := Group(Filtered(S6, g -> AsSet(J6) = Set(J6, x->x^g)));

#ideals are defined by the minimal number of caps (cups) the diagrams have
#so notation: InC is the ideal with n cups, I0C is the whole sgp ideal
DClassesJ6 := DClasses(J6);

I1C:=SemigroupIdealByGenerators(J6, [Representative(DClassesJ6[2])]);
I2C:=SemigroupIdealByGenerators(I1C, [Representative(DClassesJ6[3])]);
I3C:=SemigroupIdealByGenerators(I2C, [Representative(DClassesJ6[4])]);

#takes couple of days, requires at least 4GB RAM
#there are a few more reps than uppertorsos
I2CmodI3Csubs := function()
local rfh, T, mtT, reps,mtI2C, preimgs, elts, itf, otf, s, indset, torso;
  rfh := ReesFactorHomomorphism(I3C);
  T := Range(rfh);
  SetName(T,"I2CmodI3C");
  mtT := MulTab(T,G,rfh);
  reps := SubSgpsByMinExtensions(mtT);
  SaveIndicatorSets(reps, "I2CmodI3C.reps");
  mtI2C := MulTab(I2C);
  preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
  elts := List(preimgs,
               function(x) 
                 if Size(x)> 1 then return fail;else return x[1];fi;end);
  itf := InputTextFile("I2CmodI3C.reps");
  otf := OutputTextFile("I2CmodI3C.uppertorsos",false);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    indset := AsBlist(DecodeBitString(s));
    torso := ElementsByIndicatorSet(indset,elts);
    if fail in torso then Remove(torso,Position(torso,fail));fi;
    WriteLine(otf,EncodeBitString(AsBitString(
            IndicatorSetOfElements(torso,mtI2C))));
    s := ReadLine(itf);
  until s=fail;
end;
