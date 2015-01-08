# for calculating the subs of J6

J6 := JonesMonoid(6);
S6 := SymmetricGroup(IsPermGroup,6);
G := Group(Filtered(S6, g -> AsSet(J6) = Set(J6, x->x^g)));

#ideals are defined by the minimal number of caps (cups) the diagrams have
#so notation: InC is the ideal with n cups, I0C is the whole sgp ideal
DClassesJ6 := DClasses(J6);

I1C:=SemigroupIdealByGenerators(J6, [Representative(DClassesJ6[2])]);
GeneratorsOfSemigroup(I1C); #TODO why do we need to call this?
I2C:=SemigroupIdealByGenerators(I1C, [Representative(DClassesJ6[3])]);
GeneratorsOfSemigroup(I2C);
I3C:=SemigroupIdealByGenerators(I2C, [Representative(DClassesJ6[4])]);
GeneratorsOfSemigroup(I3C);

# I semigroup or ideal, J an ideal of I
# output: .reps file containing Sub(I/J), also as upper torsos 
ImodJSubs := function(I,J,Iname, Jname)
local rfh, T, mtT, reps,mtI, preimgs, elts, itf, otf, s, indset, torso;
  rfh := ReesFactorHomomorphism(J);
  T := Range(rfh);
  SetName(T,Concatenation(Iname,"mod",Jname));
  mtT := MulTab(T,G,rfh);
  reps := SubSgpsByMinExtensions(mtT);
  SaveIndicatorSets(reps, Concatenation(Name(T),".reps"));
  mtI := MulTab(I);
  preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
  elts := List(preimgs,
               function(x) 
                 if Size(x)> 1 then return fail;else return x[1];fi;end);
  itf := InputTextFile(Concatenation(Name(T),".reps"));
  otf := OutputTextFile(Concatenation(Name(T),".uppertorsos"),false);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    indset := AsBlist(DecodeBitString(s));
    torso := ElementsByIndicatorSet(indset,elts);
    if fail in torso then Remove(torso,Position(torso,fail));fi;
    WriteLine(otf,EncodeBitString(AsBitString(
            IndicatorSetOfElements(torso,mtI))));
    s := ReadLine(itf);
  until s=fail;
end;
