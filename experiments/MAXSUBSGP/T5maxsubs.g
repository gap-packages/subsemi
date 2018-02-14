Read("maxsubsgp.g");

mt := MulTab(FullTransformationSemigroup(5),
             SymmetricGroup(IsPermGroup,5));

SetOriginalName(mt, "T5_S5");

EnumByMaxSubSgps(mt);
