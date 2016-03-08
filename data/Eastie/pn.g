mt2 := MulTab(PartitionMonoid(2));;
mt3 := MulTab(PartitionMonoid(3),S3);;

#print the generators of P2
P2gens := Generators(PartitionMonoid(2));
#Perform([1..Size(P2gens)], function(x)
#  PrintTo(Concatenation("P2gen",String(x),".tikz"),TikzStringForBipartition(P2gens[x],rec(labels:=false)));end);

P3sub2gens := NGeneratedSubSgps(mt3,2);;
fltd := Filtered(P3sub2gens,
                x->SizeBlist(x)>=Size(PartitionMonoid(2)));;
results := Filtered(fltd,
                   x-> fail<>MulTabEmbedding(mt2,
                           MulTab(Semigroup(SetByIndicatorFunction(x,mt3)))));;

SetPrintFormattingStatus("*stdout*",false);
c := 1;;
for gens in results do
  Print(c,"\n");
  #Print("Generators: ", SetByIndicatorFunction(gens,mt3),"\n");
  Print("Size of the generated sub in P3: ",
        SizeBlist(SgpInMulTab(gens,mt3)),"\n");
  Display("EMBEDDING OF P2");
  mtsub := MulTab(Semigroup(SetByIndicatorFunction(gens,mt3)));;
  emb := MulTabEmbedding(mt2, mtsub);;
  for i in [1..Size(emb)] do
    Print(Elts(mt2)[i]," -> ", Elts(mtsub)[emb[i]],"\n");
  od;
  Print("\n");
  #just printing the generators
  for i in [1..Size(P2gens)] do
      gindx := Position(Elts(mt2),P2gens[i]);#pos of ith generator
      #PrintTo(Concatenation("P2gen",String(i),"mapped",String(c),".tikz"),
      #        TikzStringForBipartition(Elts(mtsub)[emb[gindx]],
      #                rec(labels:=false)));
  od;
  c:=c+1;
od;
