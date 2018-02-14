for degree in [1..2] do
  FileSubsemigroups(PartitionMonoid(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("P",String(degree)));
od;
