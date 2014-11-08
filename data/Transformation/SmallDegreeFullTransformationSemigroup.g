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
  SaveIndicatorSets(subreps,Concatenation(prefix{[1..Size(prefix)-1]},".reps"));
  IndicatorSetsTOClassifiedSmallGenSet(subreps,mt,prefix,ndigits);#,
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileAntiAndIsomClasses);
  Perform(PostfixMatchedListDir(".","ais"),GensFileIsomClasses);
end;

for i in [1..3] do  
  BuildSubsOfFullTransformationSemigroup(i);  
od;
