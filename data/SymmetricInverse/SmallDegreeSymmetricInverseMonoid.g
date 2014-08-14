BuildSubsOfSymmetricInverseMonoid := function(degree) 
  local S,G,mt,prefix,subreps,ndigits;
  S := SymmetricInverseMonoid(degree);
  ndigits := Size(String(Size(S)));
  SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  G := SymmetricGroup(IsPermGroup,degree);
  mt := MulTab(S,G);
  prefix := Concatenation("I",String(degree),"_");
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  IndicatorSetsTOClassifiedSmallGenSet(subreps,mt,prefix,ndigits,
          degree, SetDegreeOfPartialPermSemigroup); #semigroups issue #100
  #converting to small generator sets
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileIsomClasses);
end;

for i in [1..3] do  
  BuildSubsOfSymmetricInverseMonoid(i);  
od;
