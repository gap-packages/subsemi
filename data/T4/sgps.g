LoadPackage("subsemi");

S4 := SymmetricGroup(IsPermGroup,4);
T4 := FullTransformationSemigroup(4);

K43 := SingularTransformationSemigroup(4);
SetName(K43,"K43");
K42 := SemigroupIdealByGenerators(K43,[Transformation([1,2,2,2])]);
SetName(K42,"K42");
