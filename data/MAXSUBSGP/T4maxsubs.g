Read("maxsubsgp.g");

mt := MulTab(FullTransformationSemigroup(4),
             SymmetricGroup(IsPermGroup,4));

SetOriginalName(mt, "T4_S4");

EnumByMaxSubSgps(mt);
