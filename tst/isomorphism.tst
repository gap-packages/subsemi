gap> START_TEST("SubSemi package: isomorphism.tst");
gap> LoadPackage("SubSemi", false);;
gap> S := RandomTransformationSemigroup(3,4);;
gap> Rows(MulTab(S))=Columns(AntiMulTab(S));
true
gap> S5 := SymmetricGroup(IsPermGroup,5);;
gap> classes := ConjugacyClassOfTransformationCollection(S,S5);;
gap> i := Random([1..Size(classes)]);;
gap> j := Random([1..Size(classes)]);;
gap> mtI := MulTab(Semigroup(classes[i]));;
gap> mtJ:=MulTab(Semigroup(classes[j]));;
gap> perm := IsomorphismMulTabs(mtI,mtJ);;
gap> Rows(mtJ)= ProductTableOfElements(Permuted(ShallowCopy(SortedElements(mtI)),perm));
true

#
gap> STOP_TEST( "SubSemi package: isomorphism.tst", 10000);