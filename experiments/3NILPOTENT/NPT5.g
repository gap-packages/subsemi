Read("3nilpt.g");

mt := MulTab(FullTransformationSemigroup(5),
             SymmetricGroup(IsPermGroup,5));

SaveIndicatorFunctions(ThreeNilpotentSubSgps(mt), "NPT5.reps");
