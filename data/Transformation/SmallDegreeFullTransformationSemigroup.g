BuildSubsOfFullTransformationSemigroup := function(degree) 
  local S,G,mt,prefix,subreps,ndigits;
  S := FullTransformationSemigroup(degree);
  ndigits := Size(String(Size(S)));
  SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  G := SymmetricGroup(IsPermGroup,degree);
  mt := MulTab(S,G);
  prefix := Concatenation("T",String(degree),"_");
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  IndicatorSetsTOClassifiedSmallGenSet(subreps,mt,prefix,ndigits);#,
#          degree,SetDegreeOfTransformationSemigroup);
  # last 2 args: workaround for semigroups issue #100 on wrong degrees for trivial monoids 
  #converting to small generator sets
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileAntiAndIsomClasses);
end;

for i in [1..3] do  
  BuildSubsOfFullTransformationSemigroup(i);  
od;
