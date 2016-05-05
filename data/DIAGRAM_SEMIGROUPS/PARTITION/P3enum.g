P3 := PartitionMonoid(3);
S3 := SymmetricGroup(IsPermGroup,3);

P3I1 := SemigroupIdealByGenerators(P3,
                [Bipartition([ [ 1, -2 ], [ 2, 3 ], [ -1, -3 ]  ])]);

FileSubsemigroups(P3I1, S3, "P3I1");
