T3 := FullTransformationSemigroup(3);
Sing3 := SingularTransformationSemigroup(3);

mtorig := MulTab(T3);
I := SemigroupIdealByGenerators(T3,[Transformation([2,2,2])]);
rfh := ReesFactorHomomorphism(I);
R := Range(rfh);
mtR := MulTab(R);
subs := AsList(SubSgpsBy1Extensions(mtR));
realsubs := List(subs, x->ElementsByIndicatorSet(x,SortedElements(mtR)));
torsos := Unique(List(realsubs, x->RFHNonZeroPreImages(x,rfh)));

blists := List(torsos, x->IndicatorSetOfElements(x,SortedElements(mtorig)));

x := Unique(List(blists, x->GenerateSg(Rows(mtorig),Indices(mtorig),ListBlist(Indices(mtorig),x)))); #the last parameter sucks

mtlittle := MulTab(I);

Is := List(AsList(SubSgpsBy1Extensions(mtlittle)),
           x->ReCodeIndicatorSet(x,SortedElements(mtlittle),SortedElements(mtorig)));

Add(Is,BlistList(Indices(mtorig),[]));
Add(x,BlistList(Indices(mtorig),[]));
