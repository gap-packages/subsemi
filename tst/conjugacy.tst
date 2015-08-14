gap> START_TEST("SubSemi package: conjugacy.tst");
gap> LoadPackage("SubSemi", false);;
gap> S5 := SymmetricGroup(IsPermGroup,5);;
gap> mt := MulTab(S5,S5);;
gap> rnds := List([1..100], x -> Random(EnumeratorOfCombinations([62..120])));;
gap> ForAll(rnds, x-> SetConjugacyClassRep(x,Symmetries(mt)) = SetConjugacyClassRep(x,PossibleMinConjugators(x,mt)));
true

#
gap> STOP_TEST( "SubSemi package: conjugacy.tst", 10000);
