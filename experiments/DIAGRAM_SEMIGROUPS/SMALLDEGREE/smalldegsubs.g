###PARTITONED BINARY RELATION###################################################
PBR1 := PartitionedBinaryRelationMonoid(1);
ClassifySubsemigroupsBySize(PBR1, SymmetricGroup(IsPermGroup,1),"PBR1_");

###PARTIAL PERMUTATION##########################################################
for degree in [1..3] do
  ClassifySubsemigroups(SymmetricInverseMonoid(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("I",String(degree),"_"));
od;

###PARTIAL PERMUTATION##########################################################
for degree in [1..3] do
  ClassifySubsemigroups(DualSymmetricInverseMonoid(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("DI",String(degree),"_"));
od;


###TEMPERLEY-LIEB###############################################################
for degree in [1..5] do
  ClassifySubsemigroups(JonesMonoid(degree),
          Group(PermList(Reversed([1..degree]))),
          Concatenation("J",String(degree),"_"));
od;

###BRAUER#######################################################################
for degree in [1..4] do
  ClassifySubsemigroups(BrauerMonoid(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("Br",String(degree),"_"));
od;
