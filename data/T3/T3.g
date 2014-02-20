T3 := FullTransformationSemigroup(3);
K32 := SingularTransformationSemigroup(3);
K31:= SemigroupIdealByGenerators(K32, [Transformation([1,1,1])]); 
S3 := SymmetricGroup(3);

mt := MulTab(T3);
T3allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

mt := MulTab(T3,S3);
T3conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mt)));

#getting conjugacy classes from all subs
T3conjclasses2 := AsSortedList(Unique(List(T3allsubs,x->ConjugacyClassRep(x,mt))));

mtK32 := MulTab(K32);
K32allsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mtK32)));

mtK32 := MulTab(K32,S3);
K32conjclasses := AsSortedList(AsList(SubSgpsByMinExtensions(mtK32)));

#getting conjugacy classes from all subs
K32conjclasses2 := AsSortedList(Unique(List(K32allsubs,x->ConjugacyClassRep(x,mtK32))));


#doing the ideal thingy
rfh := ReesFactorHomomorphism(K31);
T := Range(rfh);
mtT := MulTab(T,S3,rfh);
Tsubs := AsSortedList(AsList(SubSgpsByMinExtensions(mtT)));

preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
elts := List(preimgs, function(x) if Size(x)> 1 then return fail; else return x[1];fi;end);

tmp := List(Tsubs, x->ElementsByIndicatorSet(x,elts));
Perform(tmp, function(x) if fail in x then Remove(x, Position(x,fail));fi;end);
Tuppertorsos := List(AsSortedList(Unique(tmp)), x-> IndicatorSetOfElements(x,mtK32));

Textended := List(Tuppertorsos, x->SgpInMulTab(x,mtK32));
filter := IndicatorSetOfElements(AsList(K31),SortedElements(mtK32));
result := [];
for S in Textended do
  Append(result, AsList(SubSgpsByMinExtensionsParametrized(mtK32, S, filter, Stack())));
od;
K32conjclasses3 := AsSortedList(result);
