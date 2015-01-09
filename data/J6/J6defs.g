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

I1CmodI2Csubs := function() ImodJSubs(I1C,I2C,"I1C","I2C",G);end;
I2CmodI3Csubs := function() ImodJSubs(I2C,I3C,"I2C","I3C",G);end;

I1CSubsFromUpperTorsos := function(filename)
  ISubsFromJUpperTorsos(I1C,I2C,filename,G);
end;

I2CSubsFromUpperTorsos := function(filename)
  ISubsFromJUpperTorsos(I2C,I3C,filename,G);
end;
