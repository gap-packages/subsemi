###TRANSFORMATION###############################################################
for degree in [1..3] do  
  ClassifySubsemigroups(FullTransformationSemigroup(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("T",String(degree),"_"));  
od;

###PARTIAL PERMUTATION##########################################################
for degree in [1..3] do  
  ClassifySubsemigroups(SymmetricInverseMonoid(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("I",String(degree),"_"));  
od;
