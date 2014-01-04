input := "test";;
Read("sgps.g");
SetInfoLevel(SubSemiInfoClass,0);
time := TimeInSeconds();;
mt := MulTab(T4_S4);;
mtT4 := MulTab(T4,S4);
S4subs := AsList(SubSgpsByMinClosures(mt));
S4subs := List(S4subs, x->ReCodeIndicatorSet(x,SortedElements(mt),SortedElement(mtT4)));
result := HeavyBlistContainer();
subs := LoadIndicatorSets(input);
for T in subs do
  for G in S4subs do
    AddSet(result, ConjugacyClassRep(ClosureByIncrements(T,G,mtT4),mtT4));
  od;
od;
SaveIndicatorSets(AsList(result),Concatenation(input,"M"));;
PrintTo(Concatenation(input,"F"),String(TimeInSeconds()-time));;
