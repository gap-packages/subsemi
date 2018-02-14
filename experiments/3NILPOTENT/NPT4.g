Read("3nilpt.g");

mt := MulTab(FullTransformationSemigroup(4),
             SymmetricGroup(IsPermGroup,4));

SaveIndicatorFunctions(ThreeNilpotentSubSgps(mt), "NPT4.reps");
