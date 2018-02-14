Read("T4defs.g");

mt := MulTab(T4,S4);

l := SubSgpsByMinimalGenSets(mt,3);

for i in [1..Size(l)] do
  SaveIndicatorFunctions(l[i], Concatenation("T4_",String(i),"generated.reps"));
od;
