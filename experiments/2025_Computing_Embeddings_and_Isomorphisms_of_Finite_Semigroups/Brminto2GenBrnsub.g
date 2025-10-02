# just checking - it is known that there are no solutions here
LoadPackage("SubSemi");;


Bm_into_2gend_BnSub := function(m,n)
local mtm, mtn, fltd, Bn_2gensubs,results,c,mtsub,emb,i,gens;
Print("Finding embeddings of Brauer(",m,") into 2-generated subs of Brauer(",n,")\n");
mtm := MulTab(BrauerMonoid(m));;
mtn := MulTab(BrauerMonoid(n),SymmetricGroup(IsPermGroup, n));;

Bn_2gensubs := NGeneratedSubSgps(mtn,2);;
fltd := Filtered(Bn_2gensubs,
                x->SizeBlist(x)>=Size(BrauerMonoid(m)));;
Print(Size(fltd), " candidate 2-generated subs","\n");
results := Filtered(fltd,
                   x-> not IsEmpty(MulTabEmbedding(mtm,
                           MulTab(Semigroup(SetByIndicatorFunction(x,mtn))))));;

SetPrintFormattingStatus("*stdout*",false);
if IsEmpty(results) then Print("NONE\n");fi;
c := 1;;
for gens in results do
  Print(c,"\n");c:=c+1;;
  Print("Generators: ", SetByIndicatorFunction(gens,mtn),"\n");
  Print("Size of the generated sub in Bn: ",
        SizeBlist(SgpInMulTab(gens,mtn)),"\n");
  Display("EMBEDDING OF Bm");
  mtsub := MulTab(Semigroup(SetByIndicatorFunction(gens,mtn)));;
  emb := MulTabEmbedding(mtm, mtsub);;
  for i in [1..Size(emb)] do
    Print(Elts(mtm)[i]," -> ", Elts(mtsub)[emb[i]],"\n");
  od;
  Print("\n");
od;
end;

# 2 -> 3 in three different ways
Bm_into_2gend_BnSub(2,3);

# 3 -> 4 not possible
Bm_into_2gend_BnSub(3,4);
