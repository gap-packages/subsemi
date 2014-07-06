BuildSubsOfPartialTransformationSemigroup := function(degree) 
  local S,G,mt,prefix,subreps,ndigits;
  S := PartialTransformationSemigroup(degree);
  ndigits := Size(String(Size(S)));
  SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  G := SymmetricGroup(IsPermGroup,degree);
  mt := MulTab(S,G);
  prefix := Concatenation("PT",String(degree),"_");
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  IndicatorSetsTOClassifiedSmallGenSet(subreps,mt,prefix,ndigits);
  #converting to small generator sets
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileIsomClasses);
end;

for i in [1..2] do  
  BuildSubsOfPartialTransformationSemigroup(i);  
od;
