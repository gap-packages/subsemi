# just checking - it is known that there are no solutions here
mt3 := MulTab(BrauerMonoid(3));;
mt4 := MulTab(BrauerMonoid(4),SymmetricGroup(IsPermGroup, 4));;

B4_2gensubs := NGeneratedSubSgps(mt4,2);;
fltd := Filtered(B4_2gensubs,
                x->SizeBlist(x)>=Size(BrauerMonoid(3)));;
Print(Size(fltd), " candidate 2-generated subs","\n");
results := Filtered(fltd,
                   x-> not IsEmpty(MulTabEmbedding(mt3,
                           MulTab(Semigroup(SetByIndicatorFunction(x,mt4))))));;

SetPrintFormattingStatus("*stdout*",false);
if IsEmpty(results) then Print("NONE\n");fi;
c := 1;;
for gens in results do
  Print(c,"\n");c:=c+1;;
  Print("Generators: ", SetByIndicatorFunction(gens,mt4),"\n");
  Print("Size of the generated sub in B4: ",
        SizeBlist(SgpInMulTab(gens,mt4)),"\n");
  Display("EMBEDDING OF B3");
  mtsub := MulTab(Semigroup(ElementsByIndicatorSet(gens,mt4)));;
  emb := MulTabEmbedding(mt3, mtsub);;
  for i in [1..Size(emb)] do
    Print(Elts(mt3)[i]," -> ", elts(mtsub)[emb[i]],"\n");
  od;
  Print("\n");
od;
