#input := "test";; # just put the proper filename here
Read("sgps.g");
SetInfoLevel(SubSemiInfoClass,0);
time := TimeInSeconds();;
mt := MulTab(K43,S4);;
filter := IndicatorSetOfElements(AsList(K42),SortedElements(mt));
subs := LoadIndicatorSets(input);
result := [];
for T in subs do
  Append(result, AsList(SubSgpsByMinExtensionsParametrized(mt, T, filter)));
od;
SaveIndicatorSets(result,Concatenation(input,"M"));;
PrintTo(Concatenation(input,"F"),String(TimeInSeconds()-time));;

