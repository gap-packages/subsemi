###BINARY RELATION##############################################################
B2 := Semigroup([
              BinaryRelationOnPoints([[2],[1]]),
              BinaryRelationOnPoints([[1,1],[]]),
              BinaryRelationOnPoints([[1,2],[1]]),
              BinaryRelationOnPoints([[1,2],[]])]);
#ClassifySubsemigroups(B2, SymmetricGroup(IsPermGroup,2),"B2_");

###TRANSFORMATION###############################################################
for degree in [1..3] do  
  ClassifySubsemigroups(FullTransformationSemigroup(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("T",String(degree),"_"));  
od;

###PARTIAL TRANSFORMATION#######################################################
# for degree in [1..3] do  
#   ClassifySubsemigroups(PartialTransformationSemigroup(degree),
#           SymmetricGroup(IsPermGroup, degree),
#           Concatenation("PT",String(degree),"_"));  
# od;


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
# for degree in [1..5] do  
#   ClassifySubsemigroups(JonesMonoid(degree),
#           Group(PermList(Reversed([1..degree]))),
#           Concatenation("J",String(degree),"_"));  
# od;

###BRAUER#######################################################################
# for degree in [1..4] do  
#   ClassifySubsemigroups(BrauerMonoid(degree),
#           SymmetricGroup(IsPermGroup, degree),
#           Concatenation("Br",String(degree),"_"));  
# od;

###BIPARTITION##################################################################
for degree in [1..2] do  
  ClassifySubsemigroups(PartitionMonoid(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("P",String(degree),"_"));  
od;
