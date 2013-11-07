Sing3 := FullTransformationSemigroup(3);
mtorig := MulTab(Sing3);
I := SemigroupIdealByGenerators(Sing3,[Transformation([2,2,3])]);
rfh := ReesFactorHomomorphism(I);
R := Range(rfh);
mtR := MulTab(R);
subs := AsList(SubSgpsBy1Extensions(mtR));
realsubs := List(subs, x->ElementsByIndicatorSet(x,mtR));
torsos := Unique(List(realsubs, x->RFHNonZeroPreImages(x,rfh)));

blists := List(torsos, x->IndicatorSetOfElements(x,mtorig));

x := Unique(List(blists, x->GenerateSg(Rows(mtorig),Indices(mtorig),ListBlist(Indices(mtorig),x)))); #the last parameter sucks

mtlittle := MulTab(I);

Is := List(AsList(SubSgpsBy1Extensions(mtlittle)),
           x->ReCodeIndicatorSet(x,mtlittle,mtorig));

Add(Is,BlistList(Indices(mtorig),[]));
Add(x,BlistList(Indices(mtorig),[]));

Combiner := function(A,B,mt)
  local result, a,b;
  result := [];
  for a in A do
    for b in B do
      AddSet(result, GenerateSg(Rows(mt),
                     Indices(mt),
              ListBlist(Indices(mt),UnionBlist(a,b))));
    od;
  od;
  return result;
end;
