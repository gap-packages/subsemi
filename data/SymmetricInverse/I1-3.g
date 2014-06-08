BuildSubsOfSymmetricInverseMonoid := function(degree) 
  local S,G,mt,prefix;
  S := SymmetricInverseMonoid(degree);
  G := SymmetricGroup(IsPermGroup,degree);
  mt := MulTab(S,G);
  prefix := Concatenation("I",String(degree),"_");
  Print("Calculating and classifying ",prefix,"\n\c");
  FilingIndicatorSets(AsList(SubSgpsByMinExtensions(mt)),
          x->BLSgpTag(x, mt, 2),
          prefix);
  #converting to small generator sets
  Print("Converting to small generating sets  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),
          function(x)Print(x,"\n");BlistToTSGens(x,mt);end);
end;

for i in [1..3] do  
  BuildSubsOfSymmetricInverseMonoid(i);  
od;
