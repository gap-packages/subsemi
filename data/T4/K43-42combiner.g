mtSing4 := MulTab(SingularTransformationSemigroup(4),S4);

K43_42subs := LoadIndicatorSets("K43-K42torsos");
Display(FormattedMemoryString(MemoryUsage(K43_42subs)));

#K42subs := Loader("K42ccs");
#Display(FormattedMemoryString(MemoryUsage(K42subs)));

# A := K42subs{[22]};
# B := K43_42subs{[9999]};

#Writer(AsList(ConjugacyClassCombiner(A,A,mtSing4)), "xyz");

SaveIndicatorSets(Unique(List(K43_42subs,x->SgpInMulTab(x,mtSing4))),"K43-K42torsosG");
