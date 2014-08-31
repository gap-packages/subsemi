BuildSubsOfJonesMonoid := function(degree) 
  local S,G,mt,prefix,subreps,ndigits;
  S := JonesMonoid(degree);
  ndigits := Size(String(Size(S)));
  SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  G := Group(PermList(Reversed([1..degree])));
  mt := MulTab(S,G);
  prefix := Concatenation("J",String(degree),"_");
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  IndicatorSetsTOClassifiedSmallGenSet(subreps,mt,prefix,ndigits);#,
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileIsomClasses);
end;

for i in [1..9] do  
  BuildSubsOfJonesMonoid(i);  
od;
