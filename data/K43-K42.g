Read("MTR.g");

K42 := SemigroupIdealByGenerators(SingularTransformationSemigroup(4),[Transformation([1,1,2,2])]);
rfh := ReesFactorHomomorphism(K42);
T := Range(rfh);
SetName(T,"K43-K42");

SubSgpsBy1Extensions(MulTab(T,S4,rfh));

