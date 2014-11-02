mt2 := MulTab(PartitionMonoid(2));;
mt3 := MulTab(PartitionMonoid(3),S3);;

P3sub2gensets := NGeneratedSubSgpGenSets(mt3,2);;
fltd := Filtered(P3sub2gensets,
                x->SizeBlist(SgpInMulTab(x,mt3))>=Size(PartitionMonoid(2)));;
results := Filtered(fltd,
                   x-> fail<>EmbedAbstractSemigroup(mt2,
                           MulTab(Semigroup(ElementsByIndicatorSet(x,mt3)))));;

SetPrintFormattingStatus("*stdout*",false);
c := 1;;
for gens in results do
  Print(c,"\n");c:=c+1;;
  Print("Generators: ", ElementsByIndicatorSet(gens,mt3),"\n");
  Print("Size of the generated sub in P3: ",
        SizeBlist(SgpInMulTab(gens,mt3)),"\n");
  Display("EMBEDDING OF P2");
  mtsub := MulTab(Semigroup(ElementsByIndicatorSet(gens,mt3)));;
  emb := EmbedAbstractSemigroup(mt2, mtsub);;
  for i in [1..Size(emb)] do
    Print(SortedElements(mt2)[i]," -> ", SortedElements(mtsub)[emb[i]],"\n");
  od;
  Print("\n");
od;
