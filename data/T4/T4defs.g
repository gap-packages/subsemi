LoadPackage("subsemi");

# VARIABLES for T4 and its subs
S4 := SymmetricGroup(IsPermGroup,4);
S4_T4 := Semigroup([Transformation([2,1,3,4]),Transformation([2,3,4,1])]);
T4 := FullTransformationSemigroup(4);
K43 := SingularTransformationSemigroup(4);
SetName(K43,"K43");
K42 := SemigroupIdealByGenerators(K43,[Transformation([1,2,2,2])]);
SetName(K42,"K42");

# FUNCTIONS for the calculations
# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3} and T4
K42SubReps := function()
  local output, mtT4, mtK43, mtK42, reps, r;
  mtT4 := MulTab(T4,S4);
  mtK43 := MulTab(K43,S4);
  mtK42 := MulTab(K42,S4);
  reps := AsList(SubSgpsByMinExtensions(mtK42));
  output := OutputTextFile("K42_K43.reps", false);
  for r in List(reps,
          x->ConjugacyClassRep(ReCodeIndicatorSet(x,mtK42,mtK43),mtK43)) do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
  output := OutputTextFile("K42_T4.reps", false);
  for r in List(reps,
          x->ConjugacyClassRep(ReCodeIndicatorSet(x,mtK42,mtT4),mtT4)) do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
end;

K43SubFromUpperTorsos := function(filename)
  local U, , result, mt, gens, time;
  SetInfoLevel(SubSemiInfoClass,0);
  time := TimeInSeconds();;
  result := [];
  mt := MulTab(K43,S4);
  gens := IndicatorSetOfElements(K42, SortedElements(mt));
  torsos := LoadIndicatorSets(filename);
  for U in torsos do
    Append(result, AsList(SubSgpsByMinClosuresParametrized(mt, U, gens, Stack(),[])));
  od;
  SaveIndicatorSets(result,Concatenation(input,"M"));;
  PrintTo(Concatenation(input,"F"),String(TimeInSeconds()-time));;
end;
  

mt := MulTab(K43,S4);;
filter := IndicatorSetOfElements(AsList(K42),SortedElements(mt));

result := [];
for T in subs do
  Append(result, AsList(SubSgpsByMinExtensionsParametrized(mt, T, filter, Stack())));
od;

end;
