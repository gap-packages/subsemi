for degree in [1..3] do  
  ClassifySubsemigroups(FullTransformationSemigroup(degree),
          SymmetricGroup(IsPermGroup, degree),
          Concatenation("T",String(degree),"_"));  
od;
