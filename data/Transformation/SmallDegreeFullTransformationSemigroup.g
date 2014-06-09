BuildSubsOfFullTransformationSemigroup := function(degree) 
  local S,G,mt,prefix;
  S := FullTransformationSemigroup(degree);
  SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  G := SymmetricGroup(IsPermGroup,degree);
  mt := MulTab(S,G);
  prefix := Concatenation("T",String(degree),"_");
  Print("Calculating and classifying ",prefix,"\n\c");
  FilingIndicatorSets(AsList(SubSgpsByMinExtensions(mt)),
          x->BLSgpTag(x, mt, 2),
          prefix);
  #converting to small generator sets
  Print("Converting to small generating sets  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),
          function(x)
    Print(x,"\n");
    BlistToTSGens(x,mt);
    GensFileIsomClasses(Concatenation(x,".gens"));
  end);
end;

for i in [1..3] do  
  BuildSubsOfFullTransformationSemigroup(i);  
od;
