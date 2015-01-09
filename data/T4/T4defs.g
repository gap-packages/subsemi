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

#takes couple of days, requires at least 4GB RAM
#there are a few more reps than uppertorsos
K43modK42subs := function() ImodJSubs(K43, K42, Name(K43),Name(K42),S4); end;

K43SubsFromUpperTorsos := function(filename)
  ISubsFromJUpperTorsos(K43,K42,filename,S4);
end;

K43sharp := function()
local mtK43, mtT4, K43reps, K43_T4reps, id;
  mtK43 := MulTab(K43);
  mtT4 := MulTab(T4);
  K43reps := LoadIndicatorSets("K43.reps");
  K43_T4reps := List(K43reps, x->ReCodeIndicatorSet(x,mtK43,mtT4)); 
  SaveIndicatorSets(K43_T4reps,"K43_T4.reps");
  id := Position(SortedElements(mtT4), IdentityTransformation);
  Perform(K43_T4reps, function(x) x[id]:=true;end);
  SaveIndicatorSets(K43_T4reps,"K43sharp_T4.reps");
end;

#it would be nice to calculate this as a control recalc
K43SubsOneShot := function()
  local mtT4, mtK43, reps, output, r;
  mtT4 := MulTab(T4,S4);
  mtK43 := MulTab(K43,S4);
  reps := AsList(SubSgpsByMinExtensions(mtK43));
  SaveIndicatorSets(reps,"K43.reps");
  output := OutputTextFile("K43_T4.reps", false);
  for r in List(reps,
          x->ReCodeIndicatorSet(x,mtK43,mtT4)) do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
end;

P_T4 := function()
local mtT4, I, uts, id, result;
  mtT4 := MulTab(T4,S4);
  I := SemigroupIdealByGenerators(T4, [Transformation([1,2,3,3])]); #K43
  uts := UpperTorsos(I,S4);
  #remove emptyset
  Remove(uts, Position(uts, EmptySet(mtT4)));
  #remove trivial group
  id := BlistList(Indices(mtT4), [Position(SortedElements(mtT4),IdentityTransformation)]);
  Remove(uts, Position(uts, id));
  result := SubSgpsByUpperTorsos(I,S4,uts);
  Add(result,id);
  SaveIndicatorSets(result,"P_T4.reps");
end;
