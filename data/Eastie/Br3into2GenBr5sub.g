# just checking - it is known that there are no solutions here
mt3 := MulTab(BrauerMonoid(3));;
mt5 := MulTab(BrauerMonoid(5),S5);;

B5_2gensubs := NGeneratedSubSgps(mt5,2);;
fltd := Filtered(B5_2gensubs,
                x->SizeBlist(x)>=Size(BrauerMonoid(3)));;
Print(Size(fltd), " candidate 2-generated subs","\n");
results := Filtered(fltd,
                   x-> fail<>EmbedAbstractSemigroup(mt3,
                           MulTab(Semigroup(ElementsByIndicatorSet(x,mt5)))));;

SetPrintFormattingStatus("*stdout*",false);
if IsEmpty(results) then Print("NONE\n");fi;
c := 1;;
for gens in results do
  Print(c,"\n");c:=c+1;;
  Print("Generators: ", ElementsByIndicatorSet(gens,mt5),"\n");
  Print("Size of the generated sub in B5: ",
        SizeBlist(SgpInMulTab(gens,mt5)),"\n");
  Display("EMBEDDING OF B3");
  mtsub := MulTab(Semigroup(ElementsByIndicatorSet(gens,mt5)));;
  emb := EmbedAbstractSemigroup(mt3, mtsub);;
  for i in [1..Size(emb)] do
    Print(SortedElements(mt3)[i]," -> ", SortedElements(mtsub)[emb[i]],"\n");
  od;
  Print("\n");
od;
