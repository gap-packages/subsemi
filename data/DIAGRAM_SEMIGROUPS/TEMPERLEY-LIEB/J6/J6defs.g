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

#1
I3CSubs := function()
local mt, subs, MT, SUBS;
  mt := MulTab(I3C,G);
  subs := SubSgpsByMinExtensions(mt);
  MT := MulTab(J6,G);
  SUBS := List(subs, x -> RecodeIndicatorFunction(x,
                Elts(mt),
                Elts(MT)));
  SaveIndicatorFunctions(SUBS, Concatenation("I3C",SUBS@SubSemi));
end;

#2
I2CmodI3Csubs := function()
  SaveIndicatorFunctions(UpperTorsos(I3C,G),
          Concatenation("I2CmodI3C",SUBS@SubSemi) );
end;

#3
# J - ideal of I<S
# mtI - multab of I<S
# mt - multab of ambient semigroup
SubsFromUpperTorsosFunc := function(J,G,mtI,mt)
  return
    function(filename)
        subs := SubSgpsByUpperTorsos(I,G,LoadIndicatorFunctions(filename));
        SaveIndicatorFunctions(List(subs,
                                    x-> RecodeIndicatorFunction(x,mtI,mt)),
                               Concatenation(filename,SUBS@SubSemi));
  end;
end;

I2SubsFromUpperTorsos:=SubsFromUpperTorsosFunc(I3C,G,MulTab(I3C,G),MulTab(J6));
