for degree in [1..3] do
  FileSubsemigroups(FullTransformationSemigroup(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("T",String(degree)));
od;
