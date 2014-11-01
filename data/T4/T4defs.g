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
K43modK42subs := function()
local rfh, T, mtT, reps,mtK43, preimgs, elts, itf, otf, s, indset, torso;
  rfh := ReesFactorHomomorphism(K42);
  T := Range(rfh);
  SetName(T,"K43modK42");
  mtT := MulTab(T,S4,rfh);
  reps := SubSgpsByMinExtensions(mtT);
  SaveIndicatorSets(reps, "K43modK42.reps");
  mtK43 := MulTab(K43);
  preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
  elts := List(preimgs,
               function(x) 
                 if Size(x)> 1 then return fail;else return x[1];fi;end);
  itf := InputTextFile("K43modK42.reps");
  otf := OutputTextFile("K43modK42.uppertorsos",false);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    indset := AsBlist(DecodeBitString(s));
    torso := ElementsByIndicatorSet(indset,elts);
    if fail in torso then Remove(torso,Position(torso,fail));fi;
    WriteLine(otf,EncodeBitString(AsBitString(
            IndicatorSetOfElements(torso,mtK43))));
    s := ReadLine(itf);
  until s=fail;
end;

K43SubsFromUpperTorsos := function(filename)
  local U, result, mt, gens, time, torsos;
  SetInfoLevel(SubSemiInfoClass,0);#because this is used in parallel
  time := TimeInSeconds();
  result := [];
  mt := MulTab(K43,S4);
  gens := IndicatorSetOfElements(AsList(K42), SortedElements(mt));
  torsos := LoadIndicatorSets(filename);
  for U in torsos do
    Append(result, AsList(
            SubSgpsByMinExtensionsParametrized(mt, U, gens, Stack(),[])));
  od;
  SaveIndicatorSets(result,Concatenation(filename,"M"));;
  PrintTo(Concatenation(filename,"F"),String(TimeInSeconds()-time));;
end;

K43sharp := function()
local mtK43, mtT4, K43reps, K43_T4reps;
  mtK43 := MulTab(K43);
  mtT4 := MulTab(T4);
  K43reps := LoadIndicatorSets("K43.reps");
  K43_T4reps := List(K43reps, x->ReCodeIndicatorSet(x,mtK43,mtT4)); 
  SaveIndicatorSets(K43_T4reps,"K43_T4.reps");
  id := Position(SortedElements(mtT4), IdentityTransformation);
  Perform(K43_T4reps, function(x) x[id]:=true;end);
  SaveIndicatorSets(K43_T4reps,"K43sharp_T4.reps");
end;

K43SubsOneShot := function()
  local mtT4, mtK43, reps, output, r;
  mtT4 := MulTab(T4,S4);
  mtK43 := MulTab(K43,S4);
  reps := AsList(SubSgpsByMinExtensions(mtK43));
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
