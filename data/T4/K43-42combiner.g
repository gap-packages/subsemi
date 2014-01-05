mtSing4 := MulTab(SingularTransformationSemigroup(4),S4);

#K43_42subs := LoadIndicatorSets("K43-K42torsos");
#Display(FormattedMemoryString(MemoryUsage(K43_42subs)));

K42subs := LoadIndicatorSets("K42ccs");
Display(FormattedMemoryString(MemoryUsage(K42subs)));


subs := LoadIndicatorSets("LowerTorso_00_20_3263"); 
 A := subs{[10]};
# B := K43_42subs{[9999]};

SaveIndicatorSets(AsList(ConjugacyClassCombiner(A,K42subs,mtSing4)), "xyz");

#SaveIndicatorSets(Unique(List(K43_42subs,x->SgpInMulTab(x,mtSing4))),"K43-K42torsosG");
