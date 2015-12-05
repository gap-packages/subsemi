###PARTIAL TRANSFORMATION#######################################################
for degree in [1..2] do
  FileSubsemigroups(PartialTransformationSemigroup(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("PT",String(degree)));
od;
