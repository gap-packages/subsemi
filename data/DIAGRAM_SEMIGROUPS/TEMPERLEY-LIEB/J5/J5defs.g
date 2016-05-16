# for calculating the subs of J5
# a control experiment for the single shot calculation

SubSemiOptions.LOGFREQ:=1000000;
SubSemiOptions.CHECKPOINTFREQ:=200000000;


J5 := JonesMonoid(5);
S5 := SymmetricGroup(IsPermGroup,5);
G := Group(Filtered(S5, g -> AsSet(J5) = Set(J5, x->x^g)));

#ideals are defined by the minimal number of caps (cups) the diagrams have
#so notation: InC is the ideal with n cups, I0C is the whole sgp ideal
DClassesJ5 := DClasses(J5);

I1C:=SemigroupIdealByGenerators(J5, [Representative(DClassesJ5[2])]);
I2C:=SemigroupIdealByGenerators(I1C, [Representative(DClassesJ5[3])]);

#1
I2CSubs := function()
local mt, subs, MT, SUBS;
  mt := MulTab(I2C,G);
  subs := SubSgpsByMinExtensions(mt);
  MT := MulTab(J5,G);
  SUBS := List(subs, x -> RecodeIndicatorFunction(x,
                Elts(mt),
                Elts(MT)));
  SaveIndicatorFunctions(SUBS, Concatenation("I2C",SUBS@SubSemi));
end;

#2
I1CmodI2Csubs := function()
  SaveIndicatorFunctions(UpperTorsos(I2C,G),
          Concatenation("I1CmodI2C",SUBS@SubSemi) );
end;

#3
# J - ideal of I<S
# mtI - multab of I<S
# mt - multab of ambient semigroup
SubsFromUpperTorsosFunc := function(J,G,mtI,mt)
  return
    function(filename)
        SaveIndicatorFunctions(
          List(SubSgpsByUpperTorsos(J,
                                    G,
                                    LoadIndicatorFunctions(filename)),
               x-> RecodeIndicatorFunction(x,mtI,mt)),
          Concatenation(filename,SUBS@SubSemi));
  end;
end;

I2CSubsFromUpperTorsos:=SubsFromUpperTorsosFunc(I2C,G,MulTab(I1C,G),MulTab(J5));
