# no solutions, just checking
mt4 := MulTab(BrauerMonoid(4));;
mt5 := MulTab(BrauerMonoid(5),SymmetricGroup(IsPermGroup, 5));;

B5_2gensubs := NGeneratedSubSgps(mt5,2);;
fltd := Filtered(B5_2gensubs,
                x->SizeBlist(x)>=Size(BrauerMonoid(4)));;
Print(Size(fltd), " candidate 2-generated subs","\n");
results := Filtered(fltd,
                   x-> not IsEmpty(MulTabEmbedding(mt4,
                           MulTab(Semigroup(SetByIndicatorFunction(x,mt5))))));;

SetPrintFormattingStatus("*stdout*",false);
if IsEmpty(results) then Print("NONE\n");fi;
c := 1;;
for gens in results do
  Print(c,"\n");c:=c+1;;
  Print("Generators: ", SetByIndicatorFunction(gens,mt5),"\n");
  Print("Size of the generated sub in B5: ",
        SizeBlist(SgpInMulTab(gens,mt5)),"\n");
  Display("EMBEDDING OF B4");
  mtsub := MulTab(Semigroup(SetByIndicatorFunction(gens,mt5)));;
  emb := MulTabEmbedding(mt4, mtsub);;
  for i in [1..Size(emb)] do
    Print(Elts(mt4)[i]," -> ", Elts(mtsub)[emb[i]],"\n");
  od;
  Print("\n");
od;
