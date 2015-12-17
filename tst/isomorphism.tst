gap> START_TEST("SubSemi package: isomorphism.tst");
gap> LoadPackage("SubSemi", false);;
gap> ConjugacyClassOfTransformationCollection:= function(T,G)
> local conjclass;
>  conjclass := [];
>  Perform(G, function(g)
>    AddSet(conjclass,AsSortedList(Set(T,t->t^g)));end);
>  return conjclass;
> end;;
gap> S := Semigroup([Transformation([1,3,5,1,3]),Transformation([4,5,2,4,5]),
> Transformation([5,2,4,1,5])]);;
gap> Rows(MulTab(S))=Columns(AntiMulTab(S));
true
gap> S5 := SymmetricGroup(IsPermGroup,5);;
gap> classes := ConjugacyClassOfTransformationCollection(S,S5);;
gap> i := Random([1..Size(classes)]);;
gap> j := Random([1..Size(classes)]);;
gap> mtI := MulTab(Semigroup(classes[i]));;
gap> mtJ:=MulTab(Semigroup(classes[j]));;
gap> perm := IsomorphismMulTabs(mtI,mtJ);;
gap> Rows(mtJ)= ProductTableOfElements(Permuted(ShallowCopy(Elts(mtI)),perm));
true

#
gap> STOP_TEST( "SubSemi package: isomorphism.tst", 10000);
