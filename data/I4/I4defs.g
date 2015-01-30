LoadPackage("subsemi");

# VARIABLES for I4 and its subs
S4 := SymmetricGroup(IsPermGroup,4);
I4 := SymmetricInverseMonoid(4);
I43 := SemigroupIdealByGenerators(I4, [PartialPerm([0,1,2,3])]);
SetName(I43,"I43");
I42 := SemigroupIdealByGenerators(I43,[PartialPerm([0,0,2,3])]);
SetName(I42,"I42");

# FUNCTIONS for the calculations
# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3} and I4
I42SubReps := function()
  local output, mtI4, mtI43, mtI42, reps, r;
  mtI4 := MulTab(I4,S4);
  mtI43 := MulTab(I43,S4);
  mtI42 := MulTab(I42,S4);
  reps := AsList(SubSgpsByMinExtensions(mtI42));
  output := OutputTextFile("I42_I43.reps", false);
  for r in List(reps,
          x->ConjugacyClassRep(ReCodeIndicatorSet(x,mtI42,mtI43),mtI43)) do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
  output := OutputTextFile("I42_I4.reps", false);
  for r in List(reps,
          x->ConjugacyClassRep(ReCodeIndicatorSet(x,mtI42,mtI4),mtI4)) do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
end;

#takes couple of days, requires at least 4GB RAM
#there are a few more reps than uppertorsos
I43modI42subs := function()
local rfh, T, mtT, reps,mtI43, preimgs, elts, itf, otf, s, indset, torso;
  rfh := ReesFactorHomomorphism(I42);
  T := Range(rfh);
  SetName(T,"I43modI42");
  mtT := MulTab(T,S4,rfh);
  reps := SubSgpsByMinExtensions(mtT);
  SaveIndicatorSets(reps, "I43modI42.reps");
  mtI43 := MulTab(I43);
  preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
  elts := List(preimgs,
               function(x) 
                 if Size(x)> 1 then return fail;else return x[1];fi;end);
  itf := InputTextFile("I43modI42.reps");
  otf := OutputTextFile("I43modI42.uppertorsos",false);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    indset := AsBlist(DecodeBitString(s));
    torso := ElementsByIndicatorSet(indset,elts);
    if fail in torso then Remove(torso,Position(torso,fail));fi;
    WriteLine(otf,EncodeBitString(AsBitString(
            IndicatorFunction(torso,mtI43))));
    s := ReadLine(itf);
  until s=fail;
end;

I43SubsFromUpperTorsos := function(filename)
  local U, result, mt, gens, time, torsos;
  SetInfoLevel(SubSemiInfoClass,0);#because this is used in parallel
  time := TimeInSeconds();
  result := [];
  mt := MulTab(I43,S4);
  gens := IndicatorFunction(AsList(I42), SortedElements(mt));
  torsos := LoadIndicatorSets(filename);
  for U in torsos do
    Append(result, AsList(
            SubSgpsByMinExtensionsParametrized(mt, U, gens, Stack(),[])));
  od;
  SaveIndicatorSets(result,Concatenation(filename,"M"));;
  PrintTo(Concatenation(filename,"F"),String(TimeInSeconds()-time));;
end;

I43sharp := function()
local mtI43, mtI4, I43reps, I43_I4reps, id;
  mtI43 := MulTab(I43);
  mtI4 := MulTab(I4);
  I43reps := LoadIndicatorSets("I43.reps");
  I43_I4reps := List(I43reps, x->ReCodeIndicatorSet(x,mtI43,mtI4)); 
  SaveIndicatorSets(I43_I4reps,"I43_I4.reps");
  id := Position(SortedElements(mtI4), Identity(I4));
  Perform(I43_I4reps, function(x) x[id]:=true;end);
  SaveIndicatorSets(I43_I4reps,"I43sharp_I4.reps");
end;

I43SubsOneShot := function()
  local mtI4, mtI43, reps, output, r;
  mtI4 := MulTab(I4,S4);
  mtI43 := MulTab(I43,S4);
  reps := AsList(SubSgpsByMinExtensions(mtI43));
  output := OutputTextFile("I43_I4.reps", false);
  for r in List(reps,
          x->ReCodeIndicatorSet(x,mtI43,mtI4)) do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
end;

P_I4 := function()
local mtI4, I, uts, id, result;
  mtI4 := MulTab(I4,S4);
  I := SemigroupIdealByGenerators(I4, [PartialPerm([1,2,3,0])]); #I43
  uts := UpperTorsos(I,S4);
  #remove emptyset
  Remove(uts, Position(uts, EmptySet(mtI4)));
  #remove trivial group
  id := BlistList(Indices(mtI4), [Position(SortedElements(mtI4),Identity(I4))]);
  Remove(uts, Position(uts, id));
  result := SubSgpsByUpperTorsos(I,S4,uts);
  Add(result,id);
  SaveIndicatorSets(result,"P_I4.reps");
end;
