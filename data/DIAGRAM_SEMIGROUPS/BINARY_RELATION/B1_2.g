# TODO broken, these can't be pickled, and FullBooleanMatMonoid
# can't be conjugated
###BINARY RELATION##############################################################
B1 := Semigroup([
              BinaryRelationOnPoints([[]]),
              BinaryRelationOnPoints([[1]])]);
FileSubsemigroups(B1, Group(()),"B1");

B2 := Semigroup([
              BinaryRelationOnPoints([[2],[1]]),
              BinaryRelationOnPoints([[1],[]]),
              BinaryRelationOnPoints([[1,2],[1]]),
              BinaryRelationOnPoints([[1,2],[]])]);
FileSubsemigroups(B2, SymmetricGroup(IsPermGroup,2),"B2");
